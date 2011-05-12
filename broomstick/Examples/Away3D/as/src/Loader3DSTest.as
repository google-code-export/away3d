﻿package
{
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.View3D;
	import away3d.events.LoaderEvent;
	import away3d.loaders.Loader3D;
	import away3d.loaders.parsers.Max3DSParser;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.net.URLRequest;
	[SWF(width="800", height="450", frameRate="60", backgroundColor="#000000")]
	public class Loader3DSTest extends Sprite
	{
		private var _view : View3D;
		private var _container : Loader3D;

		public function Loader3DSTest()
		{
			_view = new View3D();
			_view.antiAlias = 2;
			var camera:Camera3D = _view.camera;
			camera.lens = new PerspectiveLens();
			camera.z = 100;
			addChild(_view);
			

			Loader3D.enableParser(Max3DSParser);
			
			_container = new Loader3D();
			_container.scale(10);
			_container.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete);
			_container.addEventListener(LoaderEvent.LOAD_ERROR, onResourceLoadingError);
			//_container.addEventListener(LoaderEvent.LOAD_MAP_ERROR, onResourceMapsLoadingError);
			_container.load(new URLRequest('assets/models/f360.3ds'));
			
			_view.scene.addChild(_container);
			_view.camera.lookAt(_container.position);
			_view.camera.lens.far = Vector3D.distance(_container.position, _view.camera.position)+1000;
			_view.camera.lens.near = 10;
		}

		private function onResourceComplete(e : away3d.events.LoaderEvent) : void
		{
			this.addEventListener(Event.ENTER_FRAME, handleEnterFrame);
		}
		
		private function onResourceLoadingError(e:LoaderEvent) : void
		{
			 trace("oops, model load failed");
		}
		
		private function onResourceMapsLoadingError(e:LoaderEvent) : void
		{
			 trace("A map failed to load in this model: ["+e.url+"]");
		}
		
		private function handleEnterFrame(e : Event) : void
		{
			_container.rotationY += .5;
			_view.render();
		}
	}
}