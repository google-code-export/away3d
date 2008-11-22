package away3d.core.light;
	
	import flash.display.*;

    /**
    * Abstract light primitve.
    */
    class LightPrimitive
     {
 		/**
 		 * Red component level.
 		 */
        
 		/**
 		 * Red component level.
 		 */
        public var red:Float;
        
 		/**
 		 * Green component level.
 		 */
        public var green:Float;
        
 		/**
 		 * Blue component level.
 		 */
        public var blue:Float;
		
		/**
		 * Coefficient for the ambient light intensity.
		 */
        public var ambient:Float;
		
		/**
		 * Coefficient for the diffuse light intensity.
		 */
        public var diffuse:Float;
		
		/**
		 * Coefficient for the specular light intensity.
		 */
        public var specular:Float;
		
		/**
		 * Lightmap for ambient intensity.
		 */
        public var ambientBitmap:BitmapData;
		
		/**
		 * Lightmap for diffuse intensity.
		 */
        public var diffuseBitmap:BitmapData;
        		
		/**
		 * Combined lightmap for ambient and diffuse intensities.
		 */
        public var ambientDiffuseBitmap:BitmapData;
		
		/**
		 * Lightmap for specular intensity.
		 */
    	public var specularBitmap:BitmapData;
	}
