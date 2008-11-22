package away3d.loaders.data;

	import away3d.containers.ObjectContainer3D;
	/**
	 * Data class for 3d object containers.
	 */
	class ContainerData extends ObjectData {
		/**
		 * An array containing the child 3d objects of the container.
		 */
		public function new() {
		children = [];
		}
		
		/**
		 * An array containing the child 3d objects of the container.
		 */
		public var children:Array<Dynamic> ;
		
		/**
		 * Reference to the 3d container object of the resulting container.
		 */
		public var container:ObjectContainer3D;
	}
