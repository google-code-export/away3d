package away3d.core.draw;

import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.events.EventDispatcher;
import away3d.core.base.Object3D;


// use namespace arcane;

/** Scaled bitmap primitive */
class DrawScaledBitmap extends DrawPrimitive  {
	
	/** @private */
	public var topleft:ScreenVertex;
	/** @private */
	public var topright:ScreenVertex;
	/** @private */
	public var bottomleft:ScreenVertex;
	/** @private */
	public var bottomright:ScreenVertex;
	/** @private */
	public var left:ScreenVertex;
	/** @private */
	public var top:ScreenVertex;
	private var cos:Float;
	private var sin:Float;
	private var cosw:Float;
	private var cosh:Float;
	private var sinw:Float;
	private var sinh:Float;
	private var bounds:ScreenVertex;
	private var mapping:Matrix;
	private var width:Float;
	private var height:Float;
	/**
	 * The bitmapData object used as the scaled bitmap primitive texture.
	 */
	public var bitmap:BitmapData;
	/**
	 * The screenvertex used to position the scaled bitmap primitive in the view.
	 */
	public var screenvertex:ScreenVertex;
	/**
	 * A scaling value used to scale the scaled bitmap primitive.
	 */
	public var scale:Float;
	/**
	 * A rotation value used to rotate the scaled bitmap primitive.
	 */
	public var rotation:Float;
	/**
	 * Determines whether the texture bitmap is smoothed (bilinearly filtered) when drawn to screen.
	 */
	public var smooth:Bool;
	

	/**
	 * @inheritDoc
	 */
	public override function calc():Void {
		
		screenZ = screenvertex.z;
		minZ = screenZ;
		maxZ = screenZ;
		width = bitmap.width * scale;
		height = bitmap.height * scale;
		if (rotation != 0) {
			cos = Math.cos(rotation * Math.PI / 180);
			sin = Math.sin(rotation * Math.PI / 180);
			cosw = cos * width / 2;
			cosh = cos * height / 2;
			sinw = sin * width / 2;
			sinh = sin * height / 2;
			topleft.x = screenvertex.x - cosw - sinh;
			topleft.y = screenvertex.y + sinw - cosh;
			topright.x = screenvertex.x + cosw - sinh;
			topright.y = screenvertex.y - sinw - cosh;
			bottomleft.x = screenvertex.x - cosw + sinh;
			bottomleft.y = screenvertex.y + sinw + cosh;
			bottomright.x = screenvertex.x + cosw + sinh;
			bottomright.y = screenvertex.y - sinw + cosh;
			var boundsArray:Array<Dynamic> = new Array<Dynamic>();
			boundsArray.push(topleft);
			boundsArray.push(topright);
			boundsArray.push(bottomleft);
			boundsArray.push(bottomright);
			minX = 100000;
			minY = 100000;
			maxX = -100000;
			maxY = -100000;
			for (__i in 0...boundsArray.length) {
				bounds = boundsArray[__i];

				if (bounds != null) {
					if (minX > bounds.x) {
						minX = bounds.x;
					}
					if (maxX < bounds.x) {
						maxX = bounds.x;
					}
					if (minY > bounds.y) {
						minY = bounds.y;
					}
					if (maxY < bounds.y) {
						maxY = bounds.y;
					}
				}
			}

			mapping.a = scale * cos;
			mapping.b = -scale * sin;
			mapping.c = scale * sin;
			mapping.d = scale * cos;
			mapping.tx = topleft.x;
			mapping.ty = topleft.y;
		} else {
			topleft.x = screenvertex.x - width / 2;
			topleft.y = screenvertex.y - height / 2;
			topright.x = topleft.x + width;
			topright.y = topleft.y;
			bottomleft.x = topleft.x;
			bottomleft.y = topleft.y + height;
			bottomright.x = topright.x;
			bottomright.y = bottomleft.y;
			minX = topleft.x;
			minY = topleft.y;
			maxX = bottomright.x;
			maxY = bottomright.y;
			mapping.a = mapping.d = scale;
			mapping.c = mapping.b = 0;
			mapping.tx = topleft.x;
			mapping.ty = topleft.y;
		}
	}

	/**
	 * @inheritDoc
	 */
	public override function clear():Void {
		
		bitmap = null;
	}

	/**
	 * @inheritDoc
	 */
	public override function render():Void {
		
		source.session.renderScaledBitmap(this, bitmap, mapping, smooth);
	}

	/**
	 * @inheritDoc
	 */
	public override function contains(x:Float, y:Float):Bool {
		
		if (rotation != 0) {
			if (topleft.x * (y - topright.y) + topright.x * (topleft.y - y) + x * (topright.y - topleft.y) > 0.001) {
				return false;
			}
			if (topright.x * (y - bottomright.y) + bottomright.x * (topright.y - y) + x * (bottomright.y - topright.y) > 0.001) {
				return false;
			}
			if (bottomright.x * (y - bottomleft.y) + bottomleft.x * (bottomright.y - y) + x * (bottomleft.y - bottomright.y) > 0.001) {
				return false;
			}
			if (bottomleft.x * (y - topleft.y) + topleft.x * (bottomleft.y - y) + x * (topleft.y - bottomleft.y) > 0.001) {
				return false;
			}
		}
		if (!bitmap.transparent) {
			return true;
		}
		if (rotation != 0) {
			mapping = new Matrix(scale * cos, -scale * sin, scale * sin, scale * cos, topleft.x, topleft.y);
		} else {
			mapping = new Matrix(scale, 0, 0, scale, topleft.x, topleft.y);
		}
		mapping.invert();
		var p:Point = mapping.transformPoint(new Point(x, y));
		if (p.x < 0) {
			p.x = 0;
		}
		if (p.y < 0) {
			p.y = 0;
		}
		if (p.x >= bitmap.width) {
			p.x = bitmap.width - 1;
		}
		if (p.y >= bitmap.height) {
			p.y = bitmap.height - 1;
		}
		var pixelValue:Int = bitmap.getPixel32(Std.int(p.x), Std.int(p.y));
		return Std.int(pixelValue >> 24) > 0x80;
	}

	// autogenerated
	public function new () {
		super();
		this.topleft = new ScreenVertex();
		this.topright = new ScreenVertex();
		this.bottomleft = new ScreenVertex();
		this.bottomright = new ScreenVertex();
		this.left = new ScreenVertex();
		this.top = new ScreenVertex();
		this.mapping = new Matrix();
		
	}

	

}

