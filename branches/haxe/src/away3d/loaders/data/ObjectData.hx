package away3d.loaders.data;

	import away3d.core.math.Matrix3D;
	
	/**
	 * Data class for a generic 3d object
	 */
	class ObjectData
	 {
		/**
		 * The name of the 3d object used as a unique reference.
		 */
		public function new() {
		transform = new Matrix3D();
		}
		
		/**
		 * The name of the 3d object used as a unique reference.
		 */
		public var name:String;
		
		/**
		 * The 3d transformation matrix for the 3d object
		 */
		public var transform:Matrix3D ;
		
		/**
		 * Colada animation
		 */
		public var id:String;
		public var scale:Float;
	}
