package laml {
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.describeType;
	import flash.errors.IllegalOperationError;
	
	// TODO: Refactor toward a Visitor
	public class LAMLParser {
		public static const COMMENT:String 				 	= "comment";
		public static const ELEMENT:String 					= "element";
		public static const PROCESSING_INSTRUCTION:String 	= "processing-instruction";
		public static const TEXT:String 					= "text";
		
		public function parse(xml) {
			var result = parseNode(xml);
			parsePendingAttributes(result);
			return result;
		}
		
		protected function parseNode(xml, parent=null, root=null) {
			root = (root == null) ? parent : root;
			preVisitNode(xml, parent, root);
			var instance = visitNode(xml, parent, root);
			postVisitNode(xml, parent, root);
			return instance;
		}
		
		protected function preVisitNode(node, parent, root) {
		}
		
		protected function visitNode(node, parent, root) {
			return visitDefault(node, parent, root);
		}
		
		protected function visitDefault(node, parent, root) {
			var dynamicConstructor = getDefinitionByName(node.name());
			var instance = new dynamicConstructor();
			if(root == null) {
				root = instance;
			}
			parseAttributes(node, instance, root);
			instance = parseChildren(node.children(), instance, root);
			parseComponent(instance, parent, root);
			return instance;
		}
		
		protected function postVisitNode(node, parent, root) {
		}

		protected function parseAttributes(node, instance, root) {
			var attributes = node.attributes();
			var attributeName;
			var len = attributes.length();
			for(var i = 0; i < len; i++) {
				attributeName = attributes[i].name().toString();
				instance[attributeName] = parseAttributeValue(attributeName, attributes[i].valueOf(), instance, root);
			}
		}
		
		protected function parseAttributeValue(name, value, instance, root) {
			if(value == "true") {
				return true;
			}
			else if(value == "false") {
				return false;
			}
			else if(value.indexOf('#') == 0) {
				return parseHexString(value);
			}
			else if(!isNaN(value)) {
				return Number(value);
			}
			else if(value.indexOf("{") > -1) {
				root.pendingAttributes[name] = value;
			}
			else {
				return value;
			}
		}
		
		protected function parseHexString(str:String):uint {
			return parseInt(str.split('#').join('0x'), 16);
		}
		
		protected function parseChildren(children, instance, root) {
			var len = children.length();
			for(var i = 0; i < len; i++) {
				switch(children[i].nodeKind()) {
					case TEXT :
						instance = children[i].toXMLString();
						break;
					default :
						parseNode(children[i], instance, root);
						break;
				}
			}
			return instance;
		}
		
		protected function parseComponent(instance, parent, root) {
			if(parent && parent.addChild is Function && instance is Component) {
				var id = instance.id;
				if(id) {
					if(root[id]) {
						throw new IllegalOperationError("Duplicate id encountered with: " + id + " at: " + root);
					}
					if(parent[id]) {
						throw new IllegalOperationError("Duplicate id encountered with: " + id + " at: " + parent);
					}
					root[id] = instance;
					parent[id] = instance;
				}
				parent.addChild(instance);
			}
		}

		protected function parsePendingAttributes(root) {
			if(root.hasOwnProperty("pendingAttributes")) {
				var obj = root.pendingAttributes;
				for(var i in obj) {
					trace(">> i: " + i + " : " + obj[i]);
					evaluateAttribute(obj[i], root);
					delete obj[i];
				}
			}
		}
		
		protected function evaluateAttribute(value, context) {
			trace(">> eval with: " + value);
			var matches = value.match(/{(.*)}/);
			var match = matches.pop();
			trace(">> match: " + match);
			trace("root id is match: " + (context.id == match));
			trace("context: " + context[match]);
		}

	}
}
