package laml.xml {
	import flash.errors.IllegalOperationError;
	import flash.utils.getDefinitionByName;
	
	import laml.display.ISkin;
	import laml.display.Layoutable;
	
	public class LAMLParser {
		public static const COMMENT:String 				 	= "comment";
		public static const ELEMENT:String 					= "element";
		public static const PROCESSING_INSTRUCTION:String 	= "processing-instruction";
		public static const TEXT:String 					= "text";
		
		private var capitalized:Object;
		private var context:Object;
		private var skin:ISkin;
		
		// TODO: Maybe skin can be pulled out to become a parameter
		// of context?
		// Left it in for now to support two optional arguments - if there is 
		// only one extra argument, we check to see if it's an ISkin and otherwise
		// assume it's a context.
		public function parse(xml:XML, skinOrContext:Object=null, context:Object=null):Object {
			this.context = context;

			if(skinOrContext) {
				if(skinOrContext is ISkin) {
					this.skin = skinOrContext as ISkin;
				}
				else if(!context && !this.context) {
					this.context = skinOrContext;
				}
			}
				
			capitalized = {};

			var result:Object = parseNode(xml, null, null);
			//parsePendingAttributes(result);
			if(result is Layoutable) {
				result.skin = skin;
			}
			
			return result;
		}
		
		public function parseLayoutable(xml:XML, skinOrContext:*=null):Layoutable {
			return parse(xml, skinOrContext) as Layoutable;
		}
		
		protected function parseNode(xml:XML, parent:Object=null, root:Object=null):Object {
			root = (root == null) ? parent : root;
			preVisitNode(xml, parent, root);
			var instance:Object = visitNode(xml, parent, root);
			postVisitNode(xml, parent, root);
			return instance;
		}
		
		protected function preVisitNode(node:XML, parent:Object=null, root:Object=null):void {
		}
		
		protected function visitNode(node:XML, parent:Object=null, root:Object=null):Object {
			var methodName:String = "visit_" + node.name().localName;

			try {
				return this[methodName](node, parent, root);
			}
			catch(e:Error) {}

			return visitDefault(node, parent, root);
		}
		
		protected function visit_textFormat(node:XML, parent:Object=null, root:Object=null):Object {
			if(parent is Layoutable) {
				Layoutable(parent).css = node.text();
			}
			return parent;
		}
		
		protected function visitDefault(node:XML, parent:Object=null, root:Object=null):Object {
			var dynamicConstructor:Object = getDefinitionByName(node.name());
			var instance:Object = new dynamicConstructor();
			if(root == null) {
				root = instance;
			}
			parseAttributes(node, instance, root);
			instance = parseChildren(node.children(), instance, root);
			parseComponent(node, instance as Layoutable, parent as Layoutable, root);
			return instance;
		}
		
		protected function postVisitNode(node:XML, parent:Object=null, root:Object=null):void {
		}

		protected function parseAttributes(node:XML, instance:Object=null, root:Object=null):void {
			var attributes:XMLList = node.attributes();
			var attributeName:String;
			var len:int = attributes.length();
			for(var i:int; i < len; i++) {
				attributeName = attributes[i].name().toString();
				instance[attributeName] = parseAttributeValue(attributeName, attributes[i].valueOf(), instance, root);
			}
		}
		
		private function renderAttributeExpression(name:String, value:String, instance:Object):Object {
			try {
				trace("render attr:", name);
				var parts:Array = value.split('.');
				var tmp:Object = this.context;
				while(parts.length > 0) {
					tmp = tmp[parts.shift()];
				}
				return tmp;
			}
			catch(e:Error) {
				trace(name, "failed to render attribute expression for", name, "with", value);
			}
			return null;
		}

		protected function parseAttributeValue(name:String, value:*, instance:Object, root:Object=null):* {

			// Look for expression values, and evaluate them:
			if(value) {
				var expr:RegExp = new RegExp(/^\{(.*)\}$/);
				var result:Object = expr.exec(value)
				if(result) {
					value = renderAttributeExpression(name, result[1], instance);;
				}
			}
			
			if(name == 'width' || name == 'height') {
				return parseWidthOrHeightAttribute(name, value, instance);
			}
			else if(name == 'backgroundImage') {
				return skin.getBitmapByName(value);
			}
			else if(value == "true") {
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
			else if(value.indexOf("{") == 0) {
				//instance.pendingAttributes[name] = value;
			}
			else {
				return value;
			}
		}
		
		protected function parseWidthOrHeightAttribute(name:String, value:*, instance:Object):Number {
			var key:String;
			if(value.match(/\%$/)) {
				value = Number(value.split('%').join('')) * 0.01;
				key = 'percent' + capitalize(name);
				instance[key] = value;
				return NaN;
			}
			else if(value.match(/^\~/)) {
				value = Number(value.split('~').join(''));
				key = 'preferred' + capitalize(name);
				instance[key] = value;
				return NaN;
			}
			else {
				return Number(value);
			}
		}
		
		protected function capitalize(name:String):String {
			if(capitalized[name]) {
				return capitalized[name];
			}
			var letter:String = name.substr(0, 1);
			return capitalized[name] = letter.toUpperCase() + name.substr(1);
		}
		
		protected function parseHexString(str:String):uint {
			return parseInt(str.split('#').join('0x'), 16);
		}
		
		protected function parseChildren(children:XMLList, instance:Object, root:Object=null):Object {
			var len:int = children.length();
			for(var i:int; i < len; i++) {
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
		
		protected function parseComponent(node:XML, instance:Layoutable, parent:Layoutable, root:Object=null):void {
			if(parent && instance) {
				// Set up width and height only after children have been added.
				// This will ensure that we won't have invalid values...
				if(parent.id == instance.id) {
					throw new IllegalOperationError("Duplicate id encountered with: " + instance.id + " at: " + parent);
				}
				parent.addChild(instance);
			}
		}

		protected function parsePendingAttributes(element:Object):void {
			/*
			if(element.hasOwnProperty("pendingAttributes")) {
				var obj:Object = element.pendingAttributes;
				for(var i:String in obj) {
					trace(">> i: " + i + " : " + obj[i]);
					evaluateAttribute(obj[i], element);
					delete obj[i];
				}
			}
			if(element.hasOwnProperty('children')) {
				var len:int = element.children.length;
				for(var k:int; k < len; k++) {
					parsePendingAttributes(element.getChildAt(k));
				}
			}
			*/
		}
		
		protected function evaluateAttribute(value:String, context:Object):void {
			var matches:Array = value.match(/{(.*)}/);
			var match:RegExp = matches.pop() as RegExp;
			context[match] = context.getElementById(match);
		}

	}
}
