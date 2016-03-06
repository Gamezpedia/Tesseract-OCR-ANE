package com.lj.ane.tesseract.events
{
	import flash.events.Event;

	public class TesseractANEEvent extends Event
	{		
		public static const RECOGNIZED:String = "status_recognized";
		public static const LOG:String = "status_log";
		
		private var _uuid : String;
		private var _text : String;
		
		public function get uuid():String
		{
			return _uuid;
		}

		public function get text():String
		{
			return _text;
		}

		public function TesseractANEEvent( type : String, uuid : String, text : String ) {

			super(type, false, false);
			
			_uuid = uuid;
			_text = text;
		}

		public override function clone():Event {

			return new TesseractANEEvent(type, uuid, text);
		}

		public override function toString():String {

			return formatToString("TesseractANEEvent", "uuid", "text");
		}
	}
}