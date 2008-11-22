package away3d.materials;

	import away3d.containers.*;
	import away3d.core.base.*;
	
    /**
    * Interface for all objects that can serve as a material
    */
    interface IMaterial 
    {
		/**
    	 * Indicates whether the material is visible
    	 */
        function visible():Bool;
        
        /**
    	 * Called once per render loop when material is visible.
    	 */
        function updateMaterial(source:Object3D, view:View3D):Void;
		
		/**
		 * Default method for adding a materialupdate event listener
		 * 
		 * @param	listener		The listener function
		 */
        function addOnMaterialUpdate(listener:Dynamic):Void;
		
		/**
		 * Default method for removing a materialupdate event listener
		 * 
		 * @param	listener		The listener function
		 */
        function removeOnMaterialUpdate(listener:Dynamic):Void;
    }
