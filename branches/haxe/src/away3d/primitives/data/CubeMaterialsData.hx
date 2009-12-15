package away3d.primitives.data;

import away3d.core.utils.Init;
import away3d.haxeutils.HashableEventDispatcher;
import away3d.materials.IMaterial;
import away3d.materials.ITriangleMaterial;
import flash.events.Event;
import away3d.events.MaterialEvent;


/**
 * Dispatched when the cube materials object has one of it's materials updated.
 * 
 * @eventType away3d.events.MaterialEvent
 */
// [Event(name="materialchanged", type="away3d.events.MaterialEvent")]

/**
 * Data structure for individual materials on the sides of a cube.
 * 
 * @see away3d.primitives.Cube
 * @see away3d.primitives.Skybox
 */
class CubeMaterialsData extends HashableEventDispatcher  {
	public var left(getLeft, setLeft) : ITriangleMaterial;
	public var right(getRight, setRight) : ITriangleMaterial;
	public var bottom(getBottom, setBottom) : ITriangleMaterial;
	public var top(getTop, setTop) : ITriangleMaterial;
	public var front(getFront, setFront) : ITriangleMaterial;
	public var back(getBack, setBack) : ITriangleMaterial;
	
	private var _materialchanged:MaterialEvent;
	private var _left:ITriangleMaterial;
	private var _right:ITriangleMaterial;
	private var _bottom:ITriangleMaterial;
	private var _top:ITriangleMaterial;
	private var _front:ITriangleMaterial;
	private var _back:ITriangleMaterial;
	/**
	 * Instance of the Init object used to hold and parse default property values
	 * specified by the initialiser object in the 3d object constructor.
	 */
	private var ini:Init;
	

	private function notifyMaterialChange(material:ITriangleMaterial, faceString:String):Void {
		
		if (!hasEventListener(MaterialEvent.MATERIAL_CHANGED)) {
			return;
		}
		//if (!_materialchanged)
		_materialchanged = new MaterialEvent(MaterialEvent.MATERIAL_CHANGED, material);
		/*else
		 _materialchanged.material = material; */
		_materialchanged.extra = faceString;
		dispatchEvent(_materialchanged);
	}

	/**
	 * Defines the material applied to the left side of the cube.
	 */
	public function getLeft():ITriangleMaterial {
		
		return _left;
	}

	public function setLeft(val:ITriangleMaterial):ITriangleMaterial {
		
		if (_left == val) {
			return val;
		}
		_left = val;
		notifyMaterialChange(_left, "left");
		return val;
	}

	/**
	 * Defines the material applied to the right side of the cube.
	 */
	public function getRight():ITriangleMaterial {
		
		return _right;
	}

	public function setRight(val:ITriangleMaterial):ITriangleMaterial {
		
		if (_right == val) {
			return val;
		}
		_right = val;
		notifyMaterialChange(_right, "right");
		return val;
	}

	/**
	 * Defines the material applied to the bottom side of the cube.
	 */
	public function getBottom():ITriangleMaterial {
		
		return _bottom;
	}

	public function setBottom(val:ITriangleMaterial):ITriangleMaterial {
		
		if (_bottom == val) {
			return val;
		}
		_bottom = val;
		notifyMaterialChange(_bottom, "bottom");
		return val;
	}

	/**
	 * Defines the material applied to the top side of the cube.
	 */
	public function getTop():ITriangleMaterial {
		
		return _top;
	}

	public function setTop(val:ITriangleMaterial):ITriangleMaterial {
		
		if (_top == val) {
			return val;
		}
		_top = val;
		notifyMaterialChange(_top, "top");
		return val;
	}

	/**
	 * Defines the material applied to the front side of the cube.
	 */
	public function getFront():ITriangleMaterial {
		
		return _front;
	}

	public function setFront(val:ITriangleMaterial):ITriangleMaterial {
		
		if (_front == val) {
			return val;
		}
		_front = val;
		notifyMaterialChange(_front, "front");
		return val;
	}

	/**
	 * Defines the material applied to the back side of the cube.
	 */
	public function getBack():ITriangleMaterial {
		
		return _back;
	}

	public function setBack(val:ITriangleMaterial):ITriangleMaterial {
		
		if (_back == val) {
			return val;
		}
		_back = val;
		notifyMaterialChange(_back, "back");
		return val;
	}

	/**
	 * Creates a new <code>CubeMaterialsData</code> object.
	 *
	 * @param	init			[optional]	An initialisation object for specifying default instance properties.
	 */
	public function new(?init:Dynamic=null) {
		// autogenerated
		super();
		
		
		ini = Init.parse(init);
		if (ini.hasField("left")) {
			_left = cast(ini.getMaterial("left"), ITriangleMaterial);
		}
		if (ini.hasField("right")) {
			_right = cast(ini.getMaterial("right"), ITriangleMaterial);
		}
		if (ini.hasField("bottom")) {
			_bottom = cast(ini.getMaterial("bottom"), ITriangleMaterial);
		}
		if (ini.hasField("top")) {
			_top = cast(ini.getMaterial("top"), ITriangleMaterial);
		}
		if (ini.hasField("front")) {
			_front = cast(ini.getMaterial("front"), ITriangleMaterial);
		}
		if (ini.hasField("back")) {
			_back = cast(ini.getMaterial("back"), ITriangleMaterial);
		}
	}

	/**
	 * Default method for adding a materialChanged event listener
	 * 
	 * @param	listener		The listener function
	 */
	public function addOnMaterialChange(listener:Dynamic):Void {
		
		addEventListener(MaterialEvent.MATERIAL_CHANGED, listener, false, 0, false);
	}

	/**
	 * Default method for removing a materialChanged event listener
	 * 
	 * @param	listener		The listener function
	 */
	public function removeOnMaterialChange(listener:Dynamic):Void {
		
		removeEventListener(MaterialEvent.MATERIAL_CHANGED, listener, false);
	}

}
