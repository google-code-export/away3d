﻿package away3d.loaders.utils{    import away3d.core.utils.Debug;    import away3d.loaders.data.*;        import flash.utils.Dictionary;        /**    * Store for all geometries associated with an externally loaded file.    */    public dynamic class GeometryLibrary extends Dictionary    {    	private var _geometry:GeometryData;	    private var _geometryArray:Array;	    private var _geometryArrayDirty:Boolean;	    	    private function updateGeometryArray():void	    {	    	_geometryArray = [];	    	for each (_geometry in this) {	    		_geometryArray.push(_geometry);	    	}	    }	    		/**		 * The name of the geometry used as a unique reference.		 */		public var name:String;		    	/**    	 * Adds a geometry name reference to the library.    	 */        public function addGeometry(name:String, geoXML:XML = null, ctrlXML:XML = null):GeometryData        {        	//return if geometry already exists        	if (this[name])        		return this[name];        	        	_geometryArrayDirty = true;        	        	var geometryData:GeometryData = new GeometryData();        	geometryData.geoXML = geoXML;        	geometryData.ctrlXML = ctrlXML;            this[geometryData.name = name] = geometryData;            return geometryData;        }            	/**    	 * Returns a geometry data object for the given name reference in the library.    	 */        public function getGeometry(name:String):GeometryData        {        	//return if geometry exists        	if (this[name])        		return this[name];        	        	Debug.warning("Geometry '" + name + "' does not exist");        	        	return null;        }            	/**    	 * Returns an array of all geometries.    	 */        public function getGeometryArray():Array        {        	if (_geometryArrayDirty)        		updateGeometryArray();        		        	return _geometryArray;        }    }}