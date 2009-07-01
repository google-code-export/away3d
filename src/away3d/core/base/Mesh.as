﻿﻿package away3d.core.base{    import away3d.animators.data.*;    import away3d.arcane;    import away3d.containers.*;    import away3d.core.math.*;    import away3d.core.project.*;    import away3d.core.utils.*;    import away3d.events.*;    import away3d.materials.*;        import flash.utils.Dictionary;        use namespace arcane;    	/**	 * Dispatched when a sequence of animations completes.	 * 	 * @eventType away3d.events.AnimationEvent	 */	[Event(name="sequenceDone",type="away3d.events.AnimationEvent")]    	/**	 * Dispatched when a single animation in a sequence completes.	 * 	 * @eventType away3d.events.AnimationEvent	 */	[Event(name="cycle",type="away3d.events.AnimationEvent")]	    /**    * 3d object containing face and segment elements     */    public class Mesh extends Object3D    {    	private var _face:Face;    	private var _vertex:Vertex;		private var _geometry:Geometry;		private var _material:IMaterial;		private var _uvMaterial:IUVMaterial;		private var _faceMaterial:ITriangleMaterial;		private var _back:ITriangleMaterial;		private var _segmentMaterial:ISegmentMaterial;		private var _billboardMaterial:IBillboardMaterial;				private function onMaterialUpdate(event:MaterialEvent):void		{			_sessionDirty = true;						//cancel session update for moviematerials			//if (event.material is MovieMaterial && _scene)			//	delete _scene.updatedSessions[_session];						}		        private function onMappingChange(event:ElementEvent):void		{			_sessionDirty = true;						if ((_face = event.element as Face)) {				if (_face.material)					_uvMaterial = _face.material as IUVMaterial;				else					_uvMaterial = _faceMaterial as IUVMaterial;								if (_uvMaterial)					_uvMaterial.getFaceMaterialVO(_face.faceVO, this).invalidated = true;			}		}                private function onDimensionsChange(event:GeometryEvent):void        {        	_sessionDirty = true;        	        	notifyDimensionsChange();        }                private function removeMaterial(mat:IMaterial):void        {        	if (!mat)        		return;        	            //remove update listener			mat.removeOnMaterialUpdate(onMaterialUpdate);        }                private function addMaterial(mat:IMaterial):void        {        	if (!mat)        		return;        	        	//add update listener			mat.addOnMaterialUpdate(onMaterialUpdate);        }                protected override function updateDimensions():void        {        	//update bounding radius        	var vertices:Array = geometry.vertices.concat();        	var _length:int = vertices.length;        	        	if (_length) {        			        	if (_scaleX < 0)	        		_boundingScale = -_scaleX;	        	else	        		_boundingScale = _scaleX;            	            	if (_scaleY < 0 && _boundingScale < -_scaleY)            		_boundingScale = -_scaleY;            	else if (_boundingScale < _scaleY)            		_boundingScale = _scaleY;            	            	if (_scaleZ < 0 && _boundingScale < -_scaleZ)            		_boundingScale = -_scaleZ;            	else if (_boundingScale < _scaleZ)            		_boundingScale = _scaleZ;            		        	var mradius:Number = 0;	        	var vradius:Number;	            var num:Number3D = new Number3D();	            for each (var vertex:Vertex in vertices) {	            	num.sub(vertex.position, _pivotPoint);	                vradius = num.modulo2;	                if (mradius < vradius)	                    mradius = vradius;	            }	            if (mradius)	           		_boundingRadius = Math.sqrt(mradius);	           	else	           		_boundingRadius = 0;	             	            //update max/min X	            vertices.sortOn("x", Array.DESCENDING | Array.NUMERIC);	            _maxX = vertices[0].x;	            _minX = vertices[_length - 1].x;	            	            //update max/min Y	            vertices.sortOn("y", Array.DESCENDING | Array.NUMERIC);	            _maxY = vertices[0].y;	            _minY = vertices[_length - 1].y;	            	            //update max/min Z	            vertices.sortOn("z", Array.DESCENDING | Array.NUMERIC);	            _maxZ = vertices[0].z;	            _minZ = vertices[_length - 1].z;         	}         	            super.updateDimensions();        }                //TODO: create effective dispose mechanism for meshs		/*        private function clear():void        {            for each (var face:Face in _faces.concat([]))                removeFace(face);        }        */        		/**		 * String defining the source of the mesh.		 * 		 * If the mesh has been created internally, the string is used to display the package name of the creating object.		 * Used to display information in the stats panel		 * 		 * @see away3d.core.stats.Stats		 */       	public var url:String;				/**		 * String defining the type of class used to generate the mesh.		 * Used to display information in the stats panel		 * 		 * @see away3d.core.stats.Stats		 */       	public var type:String = "mesh";       	        /**        * Defines a segment material to be used for outlining the 3d object.        */        public var outline:ISegmentMaterial;				/**		 * Indicates whether both the front and reverse sides of a face should be rendered.		 */        public var bothsides:Boolean;                /**        * Placeholder for md2 frame indexes        */        public var indexes:Array;        		/**		 * Returns an array of the vertices contained in the mesh object.		 */        public function get vertices():Array        {            return _geometry.vertices;        }        		/**		 * Returns an array of the indices contained in the mesh object.		 */        public function get indices():Array        {            return _geometry.indices;        }        		/**		 * Returns an array of the start indices contained in the mesh object.		 */        public function get startIndices():Array        {            return _geometry.startIndices;        }        		/**		 * Returns an array of the vertex indices contained in the mesh object.		 */        public function get faceVOs():Array        {        	return _geometry.faceVOs;        }				/**		 * Returns an array of the segmentVOs contained in the mesh object.		 */        public function get segmentVOs():Array        {        	return _geometry.segmentVOs;        }        		/**		 * Returns an array of the billboardVOs contained in the mesh object.		 */        public function get billboardVOs():Array        {        	return _geometry.billboardVOs;        }        		/**		 * Returns an array of the faces contained in the mesh object.		 */        public function get faces():Array        {            return _geometry.faces;        }		/**		 * Returns an array of the segments contained in the mesh object.		 */        public function get segments():Array        {            return _geometry.segments;        }				/**		 * Returns an array of the billboards contained in the mesh object.		 */        public function get billboards():Array        {            return _geometry.billboards;        }				/**		 * Returns an array of all elements contained in the mesh object.		 */        public function get elements():Array        {            return _geometry.elements;        }                /**        * Defines the geometry object used for the mesh.        */        public function get geometry():Geometry        {        	return _geometry;        }                public function set geometry(val:Geometry):void        {        	if (_geometry == val)                return;                        if (_geometry != null) {            	_geometry.removeOnMaterialUpdate(onMaterialUpdate);            	_geometry.removeOnMappingChange(onMappingChange);            	_geometry.removeOnDimensionsChange(onDimensionsChange);            }                    	_geometry = val;        	            if (_geometry != null) {            	_geometry.addOnMaterialUpdate(onMaterialUpdate);            	_geometry.addOnMappingChange(onMappingChange);            	_geometry.addOnDimensionsChange(onDimensionsChange);            }        }            		/**		 * Defines the material used to render the faces, segments or billboards in the geometry object.		 * Individual material settings on faces, segments and billboards will override this setting.		 * 		 * @see away3d.core.base.Face#material		 */        public function get material():IMaterial        {        	return _material;        }                public function set material(val:IMaterial):void        {        	if (_material == val && _material != null)                return;                        removeMaterial(_material);						//set material value        	addMaterial(_material = val);        	        	if (_material is ITriangleMaterial)        		_faceMaterial = _material as ITriangleMaterial;        	else        		faceMaterial = new WireColorMaterial();        	        	if (_material is ISegmentMaterial)        		_segmentMaterial = _material as ISegmentMaterial;        	else        		segmentMaterial = new WireframeMaterial();        	        	if (_material is IBillboardMaterial)        		_billboardMaterial = _material as IBillboardMaterial;        	else        		billboardMaterial = new ColorMaterial();        	        	_sessionDirty = true;        }                /**        * Defines a triangle material to be used for the backface of all faces in the 3d object.        */        public function get back():ITriangleMaterial        {        	return _back;        }        		public function set back(val:ITriangleMaterial):void        {        	if (_back == val)                return;                        removeMaterial(_back);						//set back value        	addMaterial(_back = val);        }        		public function get faceMaterial():ITriangleMaterial        {        	return _faceMaterial;        }                public function set faceMaterial(val:ITriangleMaterial):void        {        	if (_faceMaterial == val)                return;                        removeMaterial(_faceMaterial);						//set material value        	addMaterial(_faceMaterial = val);        }				public function get segmentMaterial():ISegmentMaterial        {        	return _segmentMaterial;        }                public function set segmentMaterial(val:ISegmentMaterial):void        {        	if (_segmentMaterial == val)                return;                        removeMaterial(_segmentMaterial);						//set material value        	addMaterial(_segmentMaterial = val);        }				public function get billboardMaterial():IBillboardMaterial        {        	return _billboardMaterial;        }                public function set billboardMaterial(val:IBillboardMaterial):void        {        	if (_billboardMaterial == val)                return;                        removeMaterial(_billboardMaterial);						//set material value        	addMaterial(_billboardMaterial = val);        }        		/**		* return the prefix of the animation actually started.		* 		*/		public function get activePrefix():String		{			return geometry.activePrefix;		}				/**		 * Indicates the current frame of animation		 */        public function get frame():int        {            return geometry.frame;        }                public function set frame(value:int):void        {        	geometry.frame = value;        }        		/**		 * Indicates whether the animation has a cycle event listener		 */		public function get hasCycleEvent():Boolean        {        	return geometry.hasCycleEvent;        }        		/**		 * Indicates whether the animation has a sequencedone event listener		 */		public function get hasSequenceEvent():Boolean        {			return geometry.hasSequenceEvent;        }        		/**		 * Determines the frames per second at which the animation will run.		 */		public function set fps(fps:int):void		{			geometry.fps = fps;		}				/**		 * Determines whether the animation will loop.		 */		public function set loop(loop:Boolean):void		{			geometry.loop = loop;		}                /**        * Determines whether the animation will smooth motion (interpolate) between frames.        */		public function set smooth(smooth:Boolean):void		{			geometry.smooth = smooth;		}				/**		 * Indicates whether the animation is currently running.		 */		public function get isRunning():Boolean		{			return geometry.isRunning;		}				/**		 * Determines howmany frames a transition between the actual and the next animationSequence should interpolate together.		 * must be higher or equal to 1. Default = 10;		 */		public function set transitionValue(val:Number):void		{			geometry.transitionValue = val;		}				public function get transitionValue():Number		{			return geometry.transitionValue;		}				/**		 * Creates a new <code>BaseMesh</code> object.		 *		 * @param	init			[optional]	An initialisation object for specifying default instance properties.		 */        public function Mesh(init:Object = null)        {            super(init);                            geometry = new Geometry();                        outline = ini.getSegmentMaterial("outline");            material = ini.getMaterial("material");            faceMaterial = ini.getMaterial("faceMaterial") as ITriangleMaterial || _faceMaterial;            segmentMaterial = ini.getMaterial("segmentMaterial") as ISegmentMaterial || _segmentMaterial;            billboardMaterial = ini.getMaterial("billboardMaterial") as IBillboardMaterial || _billboardMaterial;            back = ini.getMaterial("back") as ITriangleMaterial;            bothsides = ini.getBoolean("bothsides", false);                        projectorType = ProjectorType.MESH;        }				/**		 * Adds a face object to the mesh object.		 * 		 * @param	face	The face object to be added.		 */        public function addFace(face:Face):void        {            _geometry.addFace(face);        }				/**		 * Removes a face object from the mesh object.		 * 		 * @param	face	The face object to be removed.		 */        public function removeFace(face:Face):void        {            _geometry.removeFace(face);        }				/**		 * Adds a segment object to the mesh object.		 * 		 * @param	segment	The segment object to be added.		 */        public function addSegment(segment:Segment):void        {            _geometry.addSegment(segment);        }				/**		 * Removes a segment object from the mesh object.		 * 		 * @param	segment	The segment object to be removed.		 */        public function removeSegment(segment:Segment):void        {            _geometry.removeSegment(segment);        }				/**		 * Adds a billboard object to the mesh object.		 * 		 * @param	billboard	The billboard object to be added.		 */        public function addBillboard(billboard:Billboard):void        {            _geometry.addBillboard(billboard);        }        		/**		 * Removes a billboard object from the mesh object.		 * 		 * @param	billboard	The billboard object to be removed.		 */        public function removeBillboard(billboard:Billboard):void        {            _geometry.removeBillboard(billboard);        }				/**		 * Inverts the geometry of all face objects.		 * 		 * @see away3d.code.base.Face#invert()		 */        public function invertFaces():void        {            _geometry.invertFaces();        }        		/**		* Divides all faces objects of a Mesh into 4 equal sized face objects.		* Used to segment a geometry in order to reduce affine persepective distortion.		* 		* @see away3d.primitives.SkyBox		*/        public function quarterFaces():void        {            _geometry.quarterFaces();        }				/**		* Divides a face object into 4 equal sized face objects.		* 		 * @param	face	The face to split in 4 equal faces.		*/        public function quarterFace(face:Face):void        {            _geometry.quarterFace(face);        }        		/**		* Divides all faces objects of a Mesh into 3 face objects.		* 		*/        public function triFaces():void        {            _geometry.triFaces();        }				/**		* Divides a face object into 3 face objects.		* 		 * @param	face	The face to split 3 faces.		*/        public function triFace(face:Face):void        {            _geometry.triFace(face);        }				/**		* Divides all faces objects of a Mesh into 2 face objects.		* 		* @param	side	The side of the faces to split in two. 0 , 1 or 2. (clockwize).		*/        public function splitFaces(side:int = 0):void        {			 _geometry.splitFaces(side);        }		/**		* Divides a face object into 2 face objects.		* 		* @param	face	The face to split in 2 faces.		* @param	side	The side of the face to split in two. 0 , 1 or 2. (clockwize).		*/		public function splitFace(face:Face, side:int = 0):void        {			 _geometry.splitFace(face, side);        }                /**        * Updates the materials in the mesh object        */        public function updateMaterials(source:Object3D, view:View3D):void        {    	        	if (_material)        		_material.updateMaterial(source, view);        	if (back)        		back.updateMaterial(source, view);        	        	geometry.updateMaterials(source, view);        }        		/**		 * Duplicates the mesh properties to another 3d object.  Usage: existingObject = objectToClone.clone( existingObject ) as Mesh;		 * 		 * @param	object	[optional]	The new object instance into which all properties are copied. The default is <code>Mesh</code>.		 * @return						The new object instance with duplicated properties applied.		 */        public override function clone(object:Object3D = null):Object3D        {            var mesh:Mesh = (object as Mesh) || new Mesh();            super.clone(mesh);            mesh.type = type;            mesh.material = material;            mesh.outline = outline;            mesh.back = back;            mesh.bothsides = bothsides;            mesh.debugbb = debugbb;			mesh.geometry = geometry;			            return mesh;        }        		/**		 * Duplicates the mesh properties to another 3d object, including geometry. Usage: var newObject:Mesh = oldObject.cloneAll( newObject ) as Mesh;		 * 		 * @param	object	[optional]	The new object instance into which all properties are copied. The default is <code>Mesh</code>.		 * @return						The new object instance with duplicated properties applied.		 */        public function cloneAll(object:Object3D = null):Object3D        {            var mesh:Mesh = (object as Mesh) || new Mesh();            super.clone(mesh);            mesh.type = type;            mesh.material = material;            mesh.outline = outline;            mesh.back = back;            mesh.bothsides = bothsides;            mesh.debugbb = debugbb;			mesh.geometry = geometry.clone();						return mesh;        }        		/**		 * Plays a sequence of frames		 * 		 * @param	sequence	The animationsequence to play		 */        public function play(sequence:AnimationSequence):void        {        	geometry.play(sequence);        }        		/**		 * Starts playing the animation at the specified frame.		 * 		 * @param	value		A number representing the frame number.		 */		public function gotoAndPlay(value:int):void		{			geometry.gotoAndPlay(value);		}				/**		 * Brings the animation to the specifed frame and stops it there.		 * 		 * @param	value		A number representing the frame number.		 */		public function gotoAndStop(value:int):void		{			geometry.gotoAndStop(value);		}				/**		* Plays a sequence of frames. 		* Note that the framenames must be be already existing in the system before you can use this handler		*		* @param	prefixes  	Array. The list of framenames to be played		* @param	fps			uint: frames per second		* @param	smooth		[optional] Boolean. if the animation must interpolate. Default = true.		* @param	loop			[optional] Boolean. if the animation must loop. Default = false.		*/		public function playFrames( prefixes:Array, fps:uint, smooth:Boolean=true, loop:Boolean=false ):void		{			geometry.playFrames(prefixes, fps, smooth, loop);		}				/**		 * Passes an array of animationsequence objects to be added to the animation.		 * 		 * @param	playlist				An array of animationsequence objects.		 * @param	loopLast	[optional]	Determines whether the last sequence will loop. Defaults to false.		 */		public function setPlaySequences(playlist:Array, loopLast:Boolean = false):void		{			geometry.setPlaySequences(playlist, loopLast);		}				/**		 * Default method for adding a sequenceDone event listener		 * 		 * @param	listener		The listener function		 */		public function addOnSequenceDone(listener:Function):void        {            geometry.addOnSequenceDone(listener);        }				/**		 * Default method for removing a sequenceDone event listener		 * 		 * @param	listener		The listener function		 */		public function removeOnSequenceDone(listener:Function):void        {            geometry.removeOnSequenceDone(listener);        }				/**		 * Default method for adding a cycle event listener		 * 		 * @param	listener		The listener function		 */		public function addOnCycle(listener:Function):void        {			geometry.addOnCycle(listener);        }				/**		 * Default method for removing a cycle event listener		 * 		 * @param	listener		The listener function		 */		public function removeOnCycle(listener:Function):void        {			geometry.removeOnCycle(listener);        } 		 		/** 		 * Returns a formatted string containing a self contained AS3 class definition that can be used to re-create the mesh. 		 *  		 * @param	classname	[optional]	Defines the class name used in the output string. Defaults to <code>Away3DObject</code>. 		 * @param	packagename	[optional]	Defines the package name used in the output string. Defaults to no package. 		 * @param	round		[optional]	Rounds all values to 4 decimal places. Defaults to false. 		 * @param	animated	[optional]	Defines whether animation data should be saved. Defaults to false. 		 *  		 * @return	A string to be pasted into a new .as file 		 */ 		public function asAS3Class(classname:String = null, packagename:String = "", round:Boolean = false, animated:Boolean = false):String        {            classname = classname || name || "Away3DObject";						var importextra:String  = (animated)? "\timport flash.utils.Dictionary;\n" : "";             var source:String = "package "+packagename+"\n{\n\timport away3d.core.base.*;\n\timport away3d.core.utils.*;\n"+importextra+"\n\tpublic class "+classname+" extends Mesh\n\t{\n";            source += "\t\tprivate var varr:Array = [];\n\t\tprivate var uvarr:Array = [];\n\t\tprivate var scaling:Number;\n";						if(animated){				source += "\t\tprivate var fnarr:Array = [];\n\n";				source += "\n\t\tprivate function v():void\n\t\t{\n";				source += "\t\t\tfor(var i:int = 0;i<vcount;++i){\n\t\t\t\tvarr.push(new Vertex(0,0,0));\n\t\t\t}\n\t\t}\n\n";			} else{				source += "\n\t\tprivate function v(x:Number,y:Number,z:Number):void\n\t\t{\n";				source += "\t\t\tvarr.push(new Vertex(x*scaling, y*scaling, z*scaling));\n\t\t}\n\n";			}            source += "\t\tprivate function uv(u:Number,v:Number):void\n\t\t{\n";            source += "\t\t\tuvarr.push(new UV(u,v));\n\t\t}\n\n";            source += "\t\tprivate function f(vn0:int, vn1:int, vn2:int, uvn0:int, uvn1:int, uvn2:int):void\n\t\t{\n";            source += "\t\t\taddFace(new Face(varr[vn0],varr[vn1],varr[vn2], null, uvarr[uvn0],uvarr[uvn1],uvarr[uvn2]));\n\t\t}\n\n";            source += "\t\tpublic function "+classname+"(init:Object = null)\n\t\t{\n\t\t\tsuper(init);\n\t\t\tinit = Init.parse(init);\n\t\t\tscaling = init.getNumber(\"scaling\", 1);\n\t\t\tbuild();\n\t\t\ttype = \""+classname+"\";\n\t\t}\n\n";            source += "\t\tprivate function build():void\n\t\t{\n";							var refvertices:Dictionary = new Dictionary();            var verticeslist:Array = [];            var remembervertex:Function = function(vertex:Vertex):void            {                if (refvertices[vertex] == null)                {                    refvertices[vertex] = verticeslist.length;                    verticeslist.push(vertex);                }            };            var refuvs:Dictionary = new Dictionary();            var uvslist:Array = [];            var rememberuv:Function = function(uv:UV):void            {                if (uv == null)                    return;                if (refuvs[uv] == null)                {                    refuvs[uv] = uvslist.length;                    uvslist.push(uv);                }            };            for each (var face:Face in _geometry.faces)            {                remembervertex(face._v0);                remembervertex(face._v1);                remembervertex(face._v2);                rememberuv(face._uv0);                rememberuv(face._uv1);                rememberuv(face._uv2);            } 						var uv:UV;			var v:Vertex;			var myPattern:RegExp;			var myPattern2:RegExp;						if(animated){				myPattern = new RegExp("vcount","g");				source = source.replace(myPattern, verticeslist.length);				source += "\n\t\t\tv();\n\n";													} else{				for each (v in verticeslist)					source += (round)? "\t\t\tv("+v._x.toFixed(4)+","+v._y.toFixed(4)+","+v._z.toFixed(4)+");\n" : "\t\t\tv("+v._x+","+v._y+","+v._z+");\n";							}			 			for each (uv in uvslist)				source += (round)? "\t\t\tuv("+uv._u.toFixed(4)+","+uv._v.toFixed(4)+");\n"  :  "\t\t\tuv("+uv._u+","+uv._v+");\n";			if(round){				var tmp:String;				myPattern2 = new RegExp(".0000","g");			}						var f:Face;				if(animated){				var ind:Array;				var auv:Array = [];				for each (f in _geometry.faces)									auv.push((round)? refuvs[f._uv0].toFixed(4)+","+refuvs[f._uv1].toFixed(4)+","+refuvs[f._uv2].toFixed(4) : refuvs[f._uv0]+","+refuvs[f._uv1]+","+refuvs[f._uv2]);								for(var i:int = 0; i< indexes.length;++i){					ind = indexes[i];					source += "\t\t\tf("+ind[0]+","+ind[1]+","+ind[2]+","+auv[i]+");\n";				}							} else{				for each (f in _geometry.faces)					source += "\t\t\tf("+refvertices[f._v0]+","+refvertices[f._v1]+","+refvertices[f._v2]+","+refuvs[f._uv0]+","+refuvs[f._uv1]+","+refuvs[f._uv2]+");\n";			}			if(round) source = source.replace(myPattern2,"");						if(animated){				var afn:Array = [];				var avp:Array;				var tmpnames:Array = [];				i= 0;				var y:int = 0;				source += "\n\t\t\tgeometry.frames = new Dictionary();\n";            	source += "\t\t\tgeometry.framenames = new Dictionary();\n";				source += "\t\t\tvar oFrames:Object = {};\n";								myPattern = new RegExp(" ","g");								for (var framename:String in geometry.framenames){					tmpnames.push(framename);				}								tmpnames.sort(); 				var fr:Frame;				for (i = 0;i<tmpnames.length;++i){					avp = [];					fr = geometry.frames[geometry.framenames[tmpnames[i]]];					if(tmpnames[i].indexOf(" ") != -1) tmpnames[i] = tmpnames[i].replace(myPattern,"");					afn.push("\""+tmpnames[i]+"\"");					source += "\n\t\t\toFrames."+tmpnames[i]+"=[";					for(y = 0; y<verticeslist.length ;y++){						if(round){							avp.push(fr.vertexpositions[y].x.toFixed(4));							avp.push(fr.vertexpositions[y].y.toFixed(4));							avp.push(fr.vertexpositions[y].z.toFixed(4));						} else{							avp.push(fr.vertexpositions[y].x);							avp.push(fr.vertexpositions[y].y);							avp.push(fr.vertexpositions[y].z);						}					}					if(round){						tmp = avp.toString();						tmp = tmp.replace(myPattern2,"");						source += tmp +"];\n";					} else{						source += avp.toString() +"];\n";					}				}								source += "\n\t\t\tfnarr = ["+afn.toString()+"];\n";				source += "\n\t\t\tvar y:int;\n";				source += "\t\t\tvar z:int;\n";				source += "\t\t\tvar frame:Frame;\n";				source += "\t\t\tfor(var i:int = 0;i<fnarr.length; ++i){\n";				source += "\t\t\t\ttrace(\"[ \"+fnarr[i]+\" ]\");\n";				source += "\t\t\t\tframe = new Frame();\n";				source += "\t\t\t\tgeometry.framenames[fnarr[i]] = i;\n";				source += "\t\t\t\tgeometry.frames[i] = frame;\n";				source += "\t\t\t\tz=0;\n";				source += "\t\t\t\tfor (y = 0; y < oFrames[fnarr[i]].length; y+=3){\n";				source += "\t\t\t\t\tvar vp:VertexPosition = new VertexPosition(varr[z]);\n";				source += "\t\t\t\t\tz++;\n";				source += "\t\t\t\t\tvp.x = oFrames[fnarr[i]][y]*scaling;\n";				source += "\t\t\t\t\tvp.y = oFrames[fnarr[i]][y+1]*scaling;\n";				source += "\t\t\t\t\tvp.z = oFrames[fnarr[i]][y+2]*scaling;\n";				source += "\t\t\t\t\tframe.vertexpositions.push(vp);\n";				source += "\t\t\t\t}\n";				source += "\t\t\t\tif (i == 0)\n";				source += "\t\t\t\t\tframe.adjust();\n";				source += "\t\t\t}\n";							}			source += "\n\t\t}\n\t}\n}";			//here a setClipboard to avoid Flash slow trace window might be beter...            return source;        } 		 		/** 		 * Returns an xml representation of the mesh 		 *  		 * @return	An xml object containing mesh information 		 */        public function asXML():XML        {            var result:XML = <mesh></mesh>;            var refvertices:Dictionary = new Dictionary();            var verticeslist:Array = [];            var remembervertex:Function = function(vertex:Vertex):void            {                if (refvertices[vertex] == null)                {                    refvertices[vertex] = verticeslist.length;                    verticeslist.push(vertex);                }            };            var refuvs:Dictionary = new Dictionary();            var uvslist:Array = [];            var rememberuv:Function = function(uv:UV):void            {                if (uv == null)                    return;                if (refuvs[uv] == null)                {                    refuvs[uv] = uvslist.length;                    uvslist.push(uv);                }            };            for each (var face:Face in _geometry.faces)            {                remembervertex(face._v0);                remembervertex(face._v1);                remembervertex(face._v2);                rememberuv(face._uv0);                rememberuv(face._uv1);                rememberuv(face._uv2);            }            var vn:int = 0;            for each (var v:Vertex in verticeslist)            {                v;//TODO : FDT Warning                result.appendChild(<vertex id={vn} x={v._x} y={v._y} z={v._z}/>);                vn++;            }            var uvn:int = 0;            for each (var uv:UV in uvslist)            {                uv;//TODO : FDT Warning                result.appendChild(<uv id={uvn} u={uv._u} v={uv._v}/>);                uvn++;            }            for each (var f:Face in _geometry.faces)            {                f;//TODO : FDT Warning                result.appendChild(<face v0={refvertices[f._v0]} v1={refvertices[f._v1]} v2={refvertices[f._v2]} uv0={refuvs[f._uv0]} uv1={refuvs[f._uv1]} uv2={refuvs[f._uv2]}/>);            }            return result;        }				/** 		 * update vertex information. 		 *  		 * @param		v						The vertex object to update 		 * @param		x						The new x value for the vertex 		 * @param		y						The new y value for the vertex 		 * @param		z						The new z value for the vertex		 * @param		refreshNormals	[optional]	Defines whether normals should be recalculated 		 *  		 */		public function updateVertex(v:Vertex, x:Number, y:Number, z:Number, refreshNormals:Boolean = false):void		{			_geometry.updateVertex(v, x, y, z, refreshNormals);		}				/** 		* Apply the local rotations to the geometry without altering the appearance of the mesh 		*/		public override function applyRotations():void		{			_geometry.applyRotations(rotationX, rotationY, rotationZ);			            rotationX = 0;            rotationY = 0;            rotationZ = 0;		}				/** 		* Apply the given position to the geometry without altering the appearance of the mesh 		*/		public override function applyPosition(dx:Number, dy:Number, dz:Number):void		{			_geometry.applyPosition(dx, dy, dz);			var dV:Number3D = new Number3D(dx, dy, dz);            dV.rotate(dV, _transform);            dV.add(dV, position);            moveTo(dV.x, dV.y, dV.z);  		}		    }}