package awaybuilder.events{	import flash.events.Event;				public class WorldBuilderEvent extends Event	{		static public const PARSER_COMPLETE : String = "WorldBuilderEvent.PARSER_COMPLETE" ;				public var data : * ;								public function WorldBuilderEvent ( type : String , bubbles : Boolean = true , cancelable : Boolean = false )		{			super ( type , bubbles , cancelable ) ;		}	}}