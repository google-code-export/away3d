//OK

package away3dlite.containers;
import away3dlite.cameras.Camera3D;
import away3dlite.core.base.Face;
import away3dlite.core.base.Object3D;
import away3dlite.core.clip.Clipping;
import away3dlite.core.clip.RectangleClipping;
import away3dlite.core.render.BasicRenderer;
import away3dlite.core.render.Renderer;
import away3dlite.events.ClippingEvent;
import away3dlite.events.MouseEvent3D;
import away3dlite.materials.Material;
import flash.display.Sprite;
import flash.Error;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Vector3D;
import flash.display.StageScaleMode;
import flash.Lib;

//use namespace arcane;
using away3dlite.namespace.Arcane;

/**
 * Sprite container used for storing camera, scene, renderer and clipping references, and resolving mouse events
 */
class View3D extends Sprite
{
	/** @private */
	/*arcane*/ private var _totalFaces:Int;
	/** @private */
	/*arcane*/ private var _totalObjects:Int;
	/** @private */
	/*arcane*/ private var _renderedFaces:Int;
	/** @private */
	/*arcane*/ private var _renderedObjects:Int;
	/** @private */
	/*arcane*/ private var screenClipping(get_screenClipping, null):Clipping;
	/*arcane*/ private function get_screenClipping():Clipping
	{
		if (_screenClippingDirty) {
			updateScreenClipping();
			_screenClippingDirty = false;
			
			return _screenClipping = _clipping.arcane().screen(this, _loaderWidth, _loaderHeight);
		}
		
		return _screenClipping;
	}
	
	private var _renderer:Renderer;
	private var _camera:Camera3D;
	private var _scene:Scene3D;
	private var _clipping:Clipping;
	private var _screenClipping:Clipping;
	private var _loaderWidth:Float;
	private var _loaderHeight:Float;
	private var _loaderDirty:Bool;
	private var _screenClippingDirty:Bool;
	private var _viewZero:Point;
	private var _x:Float;
	private var _y:Float;
	private var _stageWidth:Float;
	private var _stageHeight:Float;
	private var _mouseIsOverView:Bool;
	private var _material:Material;
	private var _object:Object3D;
	private var _uvt:Vector3D;
	private var _scenePosition:Vector3D;
	private var _mouseObject:Object3D;
	private var _mouseMaterial:Material;
	private var _lastmove_mouseX:Float;
	private var _lastmove_mouseY:Float;
	private var _face:Face;
	
	private function onClippingUpdated(e:ClippingEvent):Void
	{
		_screenClippingDirty = true;
	}
	
	private function onScreenUpdated(e:ClippingEvent):Void
	{
		
	}
	
	private function updateScreenClipping():Void
	{
		//check for loaderInfo update
		//HAXE
		//TODO: Take off that try/catch!
		try {
			_loaderWidth = loaderInfo.width;
			_loaderHeight = loaderInfo.height;
			if (_loaderDirty) {
				_loaderDirty = false;
				_screenClippingDirty = true;
			}
		} catch (error:Error) {
			_loaderDirty = true;
			_loaderWidth = stage.stageWidth;
			_loaderHeight = stage.stageHeight;
		}
		
		//check for global view movement
		_viewZero.x = 0;
		_viewZero.y = 0;
		_viewZero = localToGlobal(_viewZero);
		
		if (_x != _viewZero.x || _y != _viewZero.y || stage.scaleMode != StageScaleMode.NO_SCALE && (_stageWidth != stage.stageWidth || _stageHeight != stage.stageHeight)) {
			_x = _viewZero.x;
			_y = _viewZero.y;
			_stageWidth = stage.stageWidth;
			_stageHeight = stage.stageHeight;
			_screenClippingDirty = true;
		}
	}
	
	private function onStageResized(event:Event):Void
	{
		_screenClippingDirty = true;
	}
	
	private function onAddedToStage(event:Event):Void
	{
		stage.addEventListener(Event.RESIZE, onStageResized);
	}
			
	private function onMouseDown(e:MouseEvent):Void
	{
		fireMouseEvent(MouseEvent3D.MOUSE_DOWN, e.ctrlKey, e.shiftKey);
	}

	private function onMouseUp(e:MouseEvent):Void
	{
		fireMouseEvent(MouseEvent3D.MOUSE_UP, e.ctrlKey, e.shiftKey);
	}

	private function onRollOut(e:MouseEvent):Void
	{
		_mouseIsOverView = false;
		
		fireMouseEvent(MouseEvent3D.MOUSE_OUT, e.ctrlKey, e.shiftKey);
	}
	
	private function onRollOver(e:MouseEvent):Void
	{
		_mouseIsOverView = true;
		
		fireMouseEvent(MouseEvent3D.MOUSE_OVER, e.ctrlKey, e.shiftKey);
	}
	
	private function bubbleMouseEvent(event:MouseEvent3D):Array<Object3D>
	{
		var tar:Object3D = event.object;
		var tarArray:Array<Object3D> = [];
		while (tar != null)
		{
			tarArray.unshift(tar);
			
			tar.dispatchEvent(event);
			
			tar = Lib.as(tar.parent, Object3D);
		}
		
		return tarArray;
	}
	
	private function traverseRollEvent(event:MouseEvent3D, array:Array<Object3D>, overFlag:Bool):Void
	{
		for (tar in array) {
			tar.dispatchEvent(event);
			if (overFlag)
				buttonMode = buttonMode || tar.useHandCursor;
			else if (buttonMode && tar.useHandCursor)
				buttonMode = false;
		}
	}
	
	private function fireMouseEvent(type:String, ?ctrlKey:Bool = false, ?shiftKey:Bool = false):Void
	{
		if (!mouseEnabled)
			return;
		
		_face = renderer.getFaceUnderPoint(mouseX, mouseY);
		
		if (_face != null) {
			_uvt = _face.calculateUVT(mouseX, mouseY);
			_material = _face.material;
			_object = _face.mesh;
			var persp:Float =  _uvt.z/(camera.zoom*camera.focus);
			_scenePosition = new Vector3D(mouseX*persp, mouseY*persp, _uvt.z - camera.focus);
			_scenePosition = camera.transform.matrix3D.transformVector(_scenePosition);
		} else {
			_uvt = null;
			_material = null;
			_object = null;
		}
		
		var event:MouseEvent3D = getMouseEvent(type);
		var outArray:Array<Object3D> = [];
		var overArray:Array<Object3D> = [];
		event.ctrlKey = ctrlKey;
		event.shiftKey = shiftKey;
		
		if (type != MouseEvent3D.MOUSE_OUT && type != MouseEvent3D.MOUSE_OVER) {
			dispatchEvent(event);
			bubbleMouseEvent(event);
		}
		
		//catch mouseOver/mouseOut rollOver/rollOut object3d events
		if (_mouseObject != _object || _mouseMaterial != _material) {
			if (_mouseObject != null) {
				event = getMouseEvent(MouseEvent3D.MOUSE_OUT);
				event.object = _mouseObject;
				event.material = _mouseMaterial;
				event.ctrlKey = ctrlKey;
				event.shiftKey = shiftKey;
				dispatchEvent(event);
				outArray = bubbleMouseEvent(event);
			}
			if (_object != null) {
				event = getMouseEvent(MouseEvent3D.MOUSE_OVER);
				event.ctrlKey = ctrlKey;
				event.shiftKey = shiftKey;
				dispatchEvent(event);
				overArray = bubbleMouseEvent(event);
			}
			
			if (_mouseObject != _object) {
				
				var i:Int = 0;
				
				while (outArray[i] != null && outArray[i] == overArray[i])
					++i;
				
				if (_mouseObject != null) {
					event = getMouseEvent(MouseEvent3D.ROLL_OUT);
					event.object = _mouseObject;
					event.material = _mouseMaterial;
					event.ctrlKey = ctrlKey;
					event.shiftKey = shiftKey;
					traverseRollEvent(event, outArray.slice(i), false);
				}
				
				if (_object != null) {
					event = getMouseEvent(MouseEvent3D.ROLL_OVER);
					event.ctrlKey = ctrlKey;
					event.shiftKey = shiftKey;
					traverseRollEvent(event, overArray.slice(i), true);
				}
			}
			
			_mouseObject = _object;
			_mouseMaterial = _material;
		}
		
	}
	
	private function getMouseEvent(type:String):MouseEvent3D
	{
		var event:MouseEvent3D = new MouseEvent3D(type);
		event.screenX = mouseX;
		event.screenY = mouseY;
		event.scenePosition = _scenePosition;
		event.view = this;
		event.material = _material;
		event.object = _object;
		event.uvt = _uvt;

		return event;
	}
	
	private function fireMouseMoveEvent(?force:Bool = false):Void
	{
		if(!_mouseIsOverView)
			return;
		
		if (!(mouseZeroMove || force))
			if ((mouseX == _lastmove_mouseX) && (mouseY == _lastmove_mouseY))
				return;

		fireMouseEvent(MouseEvent3D.MOUSE_MOVE);

		 _lastmove_mouseX = mouseX;
		 _lastmove_mouseY = mouseY;
	}
	
	/**
	 * Forces mousemove events to fire even when cursor is static.
	 */
	public var mouseZeroMove:Bool;
	
	/**
	 * Scene used when rendering.
	 * 
	 * @see render()
	 */
	public var scene(get_scene, set_scene):Scene3D;
	private function get_scene():Scene3D
	{
		return _scene;
	}
	
	private function set_scene(val:Scene3D):Scene3D
	{
		if (_scene == val)
			return val;
		
		if (_scene != null) {
			removeChild(_scene);
		}
		
		_scene = val;
		
		if (_scene != null) {
			addChild(_scene);
		}
		return val;
	}
	
	/**
	 * Camera used when rendering.
	 * 
	 * @see #render()
	 */
	public var camera(get_camera, set_camera):Camera3D;
	private function get_camera():Camera3D
	{
		return _camera;
	}
	
	private function set_camera(val:Camera3D):Camera3D
	{
		if (_camera == val)
			return val;
			
		if (_camera != null) {
			removeChild(_camera);
			_camera.arcane()._view = null;
		}
		
		_camera = val;
		
		if (_camera != null) {
			addChild(_camera);
			_camera.arcane()._view = this;
		}
		return val;
	}
	
	/**
	 * Renderer object used to traverse the scenegraph and output the drawing primitives required to render the scene to the view.
	 * 
	 * @see #render()
	 */
	public var renderer(get_renderer, set_renderer):Renderer;
	private function get_renderer():Renderer
	{
		return _renderer;
	}
	
	private function set_renderer(val:Renderer):Renderer
	{
		if (_renderer == val)
			return val;
		
		_renderer = val;
		_renderer.arcane().setView(this);
		return val;
	}
	
	/**
	 * Clipping used when rendering.
	 * 
	 * @see render()
	 */
	public var clipping(get_clipping, set_clipping):Clipping;
	private function get_clipping():Clipping
	{
		return _clipping;
	}
	
	private function set_clipping(val:Clipping):Clipping
	{
		if (_clipping == val)
			return val;
		
		if (_clipping != null) {
			_clipping.removeEventListener(ClippingEvent.CLIPPING_UPDATED, onClippingUpdated);
			_clipping.removeEventListener(ClippingEvent.SCREEN_UPDATED, onScreenUpdated);
		}
		
		_clipping = val;
		_clipping.arcane().setView(this);
		
		if (_clipping != null) {
			_clipping.addEventListener(ClippingEvent.CLIPPING_UPDATED, onClippingUpdated);
			_clipping.addEventListener(ClippingEvent.SCREEN_UPDATED, onScreenUpdated);
		} else {
			throw new Error("View cannot have clipping set to null");
		}
		
		_screenClippingDirty = true;
		return val;
	}
	
	/**
	 * Returns the total amount of faces processed in the last executed render
	 * 
	 * @see #render()
	 */
	public var totalFaces(get_totalFaces, null):Int;
	private function get_totalFaces():Int
	{
		return _totalFaces;
	}
	
	/**
	 * Returns the total amount of 3d objects processed in the last executed render
	 * 
	 * @see #render()
	 */
	public var totalObjects(get_totalObjects, null):Int;
	private function get_totalObjects():Int
	{
		return _totalObjects;
	}
	
	/**
	 * Returns the total amount of faces rendered in the last executed render
	 * 
	 * @see #render()
	 */
	public var renderedFaces(get_renderedFaces, null):Int;
	private function get_renderedFaces():Int
	{
		return _renderedFaces;
	}
	
	/**
	 * Returns the total amount of objects rendered in the last executed render
	 * 
	 * @see #render()
	 */
	public var renderedObjects(get_renderedObjects, null):Int;
	private function get_renderedObjects():Int
	{
		
		return _renderedObjects;
	}
	
	/**
	 * Creates a new <code>View3D</code> object.
	 * 
	 * @param	scene		Scene used when rendering.
	 * @param	camera		Camera used when rendering.
	 * @param	renderer	Renderer object used to traverse the scenegraph and output the drawing primitives required to render the scene to the view.
	 * @param	clipping	Clipping used when rendering.
	 */
	public function new(?scene:Scene3D = null, ?camera:Camera3D = null, ?renderer:Renderer = null, ?clipping:Clipping = null)
	{
		super();
		
		_viewZero = new Point();
		
		this.scene = (scene != null) ? scene : new Scene3D();
		this.camera = (camera != null) ? camera : new Camera3D();
		this.renderer = (renderer != null) ? renderer : new BasicRenderer();
		this.clipping = (clipping != null) ? clipping : new RectangleClipping();
		
		//setup events on view
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		addEventListener(MouseEvent.ROLL_OUT, onRollOut);
		addEventListener(MouseEvent.ROLL_OVER, onRollOver);
	}
	
	/**
	 * Renders a snapshot of the view.
	 */
	public function render():Void
	{
		_totalFaces = 0;
		_totalObjects = -1;
		_renderedFaces = 0;
		_renderedObjects = -1;
		
		updateScreenClipping();
		
		camera.arcane().update();
		
		_scene.arcane().project(camera.projectionMatrix3D);
		
		graphics.clear();
		
		renderer.render();
		
		if (mouseEnabled)
			fireMouseMoveEvent();
	}
}
