package away3d.materials;	import away3d.arcane;	import away3d.core.base.*;	import away3d.core.draw.*;	import away3d.core.math.*;	import away3d.core.render.*;	import away3d.core.utils.*;	import away3d.events.*;		import flash.display.BitmapData;	import flash.display.Sprite;	import flash.events.AsyncErrorEvent;	import flash.events.IOErrorEvent;	import flash.events.NetStatusEvent;	import flash.events.SecurityErrorEvent;	import flash.media.Video;	import flash.net.NetConnection;	import flash.net.NetStream;	import flash.text.StyleSheet;	import flash.text.TextField;		use namespace arcane;		/**	 * Animated movie material.	 */    class VideoMaterial extends MovieMaterial {                public var file(getFile, setFile) : String;                /**        * Defines the path to the rtmp stream used for rendering the material        */                        /**        * Defines the path to the rtmp stream used for rendering the material        */        public var rtmp:String;                /**        * Defines the FLV used for rendering the material        */        var _file:String;                public function getFile():String{        	return _file;        }         public function setFile(file:String):String{        	_file = file;        	startPlaying();        	return file;        }                 /**        * Defines if the FLV will be looping playback        */        public var loop:Bool;                /**        * Defines the NetStream we'll use        */        public var netStream:NetStream;                /**        * Defines the NetConnection we'll use        */        public var nc:NetConnection;                /**        * Holds the video Object        */        public var video:Video;                /**        * A Sprite we can return to the MovieMaterial        */        public var sprite:Sprite;        		var _lockW:Float;		var _lockH:Float;		/**		 * Creates a new <code>VideoMaterial</code> object.		 * Pass file:"somevideo.flv" in the initobject or set the file to start playing a video.		 * Be aware that FLV files must be located in the same domain as the SWF or you will get security errors.		 * NOTE: rtmp is not yet supported		 * 		 * @param	file				The url to the FLV file.		 * @param	init	[optional]	An initialisation object for specifying default instance properties.		 */                public function new(?init:Dynamic = null)        {            ini = Init.parse(init);            loop = ini.getBoolean("loop", false);            file = ini.getString("file", "");            rtmp = ini.getString("rtmp", "");			        	sprite = new Sprite();			this._file = file;			super(sprite,ini); // Attach sprite to MovieMaterial						// Play the video if we have one			if(file != ""){ startPlaying(); }        }        function startPlaying():Void        {        	if(rtmp == ""){				try {					// Use null connection for progressive files					nc = new NetConnection();					nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler,false,0,true);		        	nc.connect(null);		        	netStream = new NetStream(nc);					this.netStream = netStream;										// Setup stream. Remember that the FLV must be in the same security sandbox as the SWF.					netStream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler,false,0,true);					netStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, ayncErrorHandler,false,0,true);					netStream.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler,false,0,true);					netStream.play(file);										// ignore metadata					var anyObject:Dynamic = new Object();					anyObject.onCuePoint = metaDataHandler;					anyObject.onMetaData = metaDataHandler;					netStream.client = anyObject;										// Setup video object					video = new Video();					video.smoothing = true;					video.attachNetStream(netStream);					sprite.addChild(video);										// update the material dimensions					this.movie = sprite;					updateDimensions();				} catch (e:Error) {					showError("an error has occured with the flv stream:" + e.message);				}			} else {				// rtmp is not currently implemented due to Flash Player security restrictions				/* try {					nc = new NetConnection();					nc.addEventListener(NetStatusEvent.NET_STATUS,netStatusHandler);					nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler,false,0,true);		        	nc.connect(rtmp);				} catch (e:Error) {					trace("an error has occured with the flv stream:" + e.message);				} */			}						        }                /**        * Plays rtmp streams when they've connected to the server        */        function playStream():Void        {        	netStream = new NetStream(nc);			this.netStream = netStream;			netStream.checkPolicyFile = true;        	netStream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler,false,0,true);			netStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, ayncErrorHandler,false,0,true);			netStream.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler,false,0,true);			netStream.play(file);						// ignore metadata			var anyObject:Dynamic = new Object();			anyObject.onMetaData = metaDataHandler;			netStream.client = anyObject;						// Setup video object			video = new Video();			video.smoothing = true;			video.attachNetStream(netStream);			sprite.addChild(video);        }                /**        * We must update the material        */        function updateDimensions():Void        {        	_lockW = ini.getNumber("lockW", movie.width);			_lockH = ini.getNumber("lockH", movie.height);            _bitmap = new BitmapData(Math.max(1,_lockW), Math.max(1,_lockH), transparent, (transparent) ? 0x00ffffff : 0);        }				// Event handling		function ayncErrorHandler(event:AsyncErrorEvent): Void {			// Must be present to prevent errors, but won't do anything		}		function metaDataHandler(?oData:Dynamic = null):Void {			// Offers info such as oData.duration, oData.width, oData.height, oData.framerate and more (if encoded into the FLV)			this.dispatchEvent( new VideoEvent(VideoEvent.METADATA,netStream,file,oData) );		}		function ioErrorHandler(e:IOErrorEvent):Void {			showError("An IOerror occured: "+e.text);		}		function securityErrorHandler(e:SecurityErrorEvent):Void {			showError("A security error occured: "+e.text+" Remember that the FLV must be in the same security sandbox as your SWF.");		}		function showError(txt:String, ?e:NetStatusEvent = null):Void {			sprite.graphics.beginFill(0x333333);			sprite.graphics.drawRect(0,0,400,300);			sprite.graphics.endFill();						// Error text formatting			var style:StyleSheet = new StyleSheet();			var styleObj:Dynamic = new Object();			styleObj.fontSize = 24;			styleObj.fontWeight = "bold";			styleObj.color = "#FF0000";			style.setStyle("p", styleObj);						// make textfield			var text:TextField = new TextField();			text.width = 400;			text.multiline = true;			text.wordWrap = true;			text.styleSheet = style;			text.text = "<p>"+txt+"</p>";			sprite.addChild(text);						// apply			updateDimensions()		}		function netStatusHandler(e:NetStatusEvent):Void {            switch (e.info.code) {                case "NetStream.Play.Stop": this.dispatchEvent( new VideoEvent(VideoEvent.STOP,netStream,file) ); if(loop){ netStream.play(file) }; break;                case "NetStream.Play.Play": this.dispatchEvent( new VideoEvent(VideoEvent.PLAY,netStream,file) ); break;                case "NetStream.Play.StreamNotFound": showError("The file "+file+"was not found", e); break;                case "NetConnection.Connect.Success": playStream(); break;            }        }    }