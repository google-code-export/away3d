package away3d.materials;

    import away3d.containers.*;
    import away3d.core.base.*;
    import away3d.core.draw.*;
    import away3d.core.render.*;
    import away3d.core.utils.*;
    import away3d.events.*;
    
    import flash.events.*;

    /**
    * Wire material for face border outlining only
    */
    class WireframeMaterial extends EventDispatcher, implements ITriangleMaterial, implements ISegmentMaterial {
        public var visible(getVisible, null) : Bool
        ;
        /**
        * Instance of the Init object used to hold and parse default property values
        * specified by the initialiser object in the 3d object constructor.
        */
		
        /**
        * Instance of the Init object used to hold and parse default property values
        * specified by the initialiser object in the 3d object constructor.
        */
		var ini:Init;
				
		/**
		 * Determines the color value of the wire
		 */
        public var color:Int;
		
		/**
		 * Determines the alpha value of the wire
		 */
        public var alpha:Float;
		
		/**
		 * Determines the width value of the wire
		 */
        public var width:Float;
    	
		/**
		 * Creates a new <code>WireframeMaterial</code> object.
		 * 
		 * @param	color				A string, hex value or colorname representing the color of the wire.
		 * @param	init	[optional]	An initialisation object for specifying default instance properties.
		 */
        public function new(?color:Dynamic = null, ?init:Dynamic = null)
        {
            if (color == null)
                color = "random";

            this.color = Cast.trycolor(color);

            ini = Init.parse(init);
            
            alpha = ini.getNumber("alpha", 1, {min:0, max:1});
            width = ini.getNumber("width", 1, {min:0});
        }
        
		/**
		 * @inheritDoc
		 */
        public function updateMaterial(source:Object3D, view:View3D):Void
        {
        	
        }
        
		/**
		 * @inheritDoc
		 */
        public function renderSegment(seg:DrawSegment):Void
        {
            if (alpha <= 0)
                return;
			
			seg.source.session.renderLine(seg.v0, seg.v1, width, color, alpha);
        }
        
		/**
		 * @inheritDoc
		 */
        public function renderTriangle(tri:DrawTriangle):Void
        {
            if (alpha <= 0)
                return;

            tri.source.session.renderTriangleLine(width, color, alpha, tri.v0, tri.v1, tri.v2);
        }
        
		/**
		 * @inheritDoc
		 */
        public function getVisible():Bool
        {
            return (alpha > 0);
        }
        
		/**
		 * @inheritDoc
		 */
        public function addOnMaterialUpdate(listener:Dynamic):Void
        {
        	addEventListener(MaterialEvent.MATERIAL_UPDATED, listener, false, 0, true);
        }
        
		/**
		 * @inheritDoc
		 */
        public function removeOnMaterialUpdate(listener:Dynamic):Void
        {
        	removeEventListener(MaterialEvent.MATERIAL_UPDATED, listener, false);
        }
    }
