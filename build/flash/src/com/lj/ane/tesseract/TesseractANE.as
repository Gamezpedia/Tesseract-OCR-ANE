package com.lj.ane.tesseract
{
	import mx.core.mx_internal;
	
    import flash.external.ExtensionContext;    
    import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.events.StatusEvent;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	
	import com.adobe.images.PNGEncoder;
	
	import com.lj.ane.tesseract.events.TesseractANEEvent;
	import com.foxarc.util.Base64;
    
    public class TesseractANE extends EventDispatcher
    {
		private static const DEFAULT_LANGUAGE : String = "eng";
		private static const DEFAULT_CHARSET : String = "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
		
        private static var _extensionContext:ExtensionContext = null;
		
        private static var _instance:TesseractANE = null;
		private static var _canInstantiate:Boolean = false;
		
		private var _language : String = DEFAULT_LANGUAGE;
		private var _charset : String = DEFAULT_CHARSET;
		private var _absoluteTessdataPath : String;
				        
        public static function getInstance(): TesseractANE {
            
            if(_instance == null) {
				_canInstantiate = true;
                _instance = new TesseractANE();
				_canInstantiate = false;
            }
            
            return _instance;
        }
		
		public function set language(value : String) : void {
			if(value == null) {
				value = DEFAULT_LANGUAGE;
			}
			
			_language = value;
		}
		
		public function get language(): String {
			return _language;
		}
		
		public function set charset(value : String) : void {
			if(value == null) {
				value = DEFAULT_CHARSET;
			}
			
			_charset = value;
		}
		
		public function get charset(): String {
			return _charset;
		}
		
		public function set absoluteTessdataPath(value : String) : void {
			_absoluteTessdataPath = value;
		}
		
		public function get absoluteTessdataPath(): String {
			return _absoluteTessdataPath;
		}
        
        public function TesseractANE()
        {
            if (!_canInstantiate) {
                throw new Error("Can't instantiate class directly!");
            }
			
			_extensionContext = ExtensionContext.createExtensionContext("com.lj.ane.tesseract", "");
			_extensionContext.addEventListener(StatusEvent.STATUS, onStatus);
        }
        
        public function recognize( bitmapData : BitmapData ) : String
        {
			var byteArray : ByteArray = PNGEncoder.encode(bitmapData);			
						
			return _extensionContext.call("recognize", Base64.encode(byteArray), _language, _charset, _absoluteTessdataPath) as String;
        }
		
		private function onStatus( event : StatusEvent ) : void 
		{ 
 			event.stopImmediatePropagation();
			
			switch(event.code) {
				case TesseractANEEvent.RECOGNIZED:
					var result : String = event.level;
					
					var index : int = result.indexOf(" ");
					
					var id : String = result.substring(0, index);
					var text : String = result.substring(index + 1);
										
					dispatchEvent(new TesseractANEEvent(TesseractANEEvent.RECOGNIZED, id, text));
					break;
				
				case TesseractANEEvent.LOG:
					trace(event.level);
					break;	
 			}
		}
    }
}