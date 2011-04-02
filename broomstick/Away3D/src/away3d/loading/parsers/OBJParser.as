﻿package away3d.loading.parsers{	import away3d.arcane;	import away3d.core.base.Geometry;	import away3d.core.base.data.UV;	import away3d.core.base.data.Vertex;	import away3d.core.base.SubGeometry;	import away3d.loading.IResource;	import away3d.entities.Mesh;	import away3d.containers.ObjectContainer3D;	import away3d.loading.IResource;	import away3d.loading.ResourceDependency;	import away3d.loading.BitmapDataResource;	import away3d.materials.BitmapMaterial;	import flash.display.BitmapData;	import flash.events.*;    import flash.net.*;	use namespace arcane;	/**	 * OBJParser provides a parser for the OBJ data type.	 */	public class OBJParser extends ParserBase	{		private var _startedParsing : Boolean;		private var _charIndex:uint;		private var _oldIndex:uint;		private var _stringLength:uint;		private var _currentObject : ObjectGroup;		private var _currentGroup : Group;		private var _currentMaterialGroup : MaterialGroup;		private var _objects : Vector.<ObjectGroup>;		private var _materialIDs : Vector.<String>;		private var _materialLoaded : Vector.<LoadedMaterial>;		private var _meshes : Vector.<Mesh>;		private var _lastMtlID:String;		private var _objectIndex : uint;		private var _realIndices : Array;		private var _vertexIndex : uint;		private var _mtlLib : Boolean;		private var _mtlLibLoaded : Boolean = true;		private var _idCount : uint;		private var _activeMaterialID:String = "";		private var _vertices : Vector.<Vertex>;		private var _vertexNormals : Vector.<Vertex>;		private var _uvs : Vector.<UV>;		private var _container : ObjectContainer3D;		/**		 * Creates a new OBJParser object.		 * @param uri The url or id of the data or file to be parsed.		 */		public function OBJParser(uri : String)		{			super(uri, ParserDataFormat.PLAIN_TEXT);		}		/**		 * Indicates whether or not a given file extension is supported by the parser.		 * @param extension The file extension of a potential file to be parsed.		 * @return Whether or not the given file type is supported.		 */		public static function supportsType(extension : String) : Boolean		{			extension = extension.toLowerCase();			return extension == "obj" || extension == "mtl";		}		/**		 * Tests whether a data block can be parsed by the parser.		 * @param data The data block to potentially be parsed.		 * @return Whether or not the given data is supported.		 */		public static function supportsData(data : *) : Boolean		{			var content : String = String(data);			var hasV : Boolean = content.indexOf("v ") != -1;			var hasF : Boolean = content.indexOf("f ") != -1;//			var hasVT : Boolean = content.indexOf("\nvt ") != -1;			return hasV && hasF/* && hasVT*/;		}		/**		 * @inheritDoc		 */		override protected function initHandle() : IResource		{			_container = new ObjectContainer3D();			return _container;		}		/**		 * @inheritDoc		 */		override arcane function resolveDependency(resourceDependency:ResourceDependency):void		{			var resource:BitmapDataResource = resourceDependency.resource as BitmapDataResource;			if (resource){				var lm:LoadedMaterial = new LoadedMaterial();				lm.materialID = resourceDependency.id;				lm.bitmapData = isBitmapDataValid(resource.bitmapData)? resource.bitmapData : defaultBitmapData ;				_materialLoaded.push(lm);				if(_meshes.length>0)					applyMaterial(lm);			}		}		/**		 * @inheritDoc		 */		override arcane function resolveDependencyFailure(resourceDependency:ResourceDependency):void		{			var lm:LoadedMaterial = new LoadedMaterial();			lm.materialID = resourceDependency.id;			lm.bitmapData = defaultBitmapData;			_materialLoaded.push(lm);			if(_meshes.length>0)				applyMaterial(lm);		}		/**		 * @inheritDoc		 */		 override protected function proceedParsing() : Boolean		{		 	var line:String;			var creturn:String = String.fromCharCode(10);			var trunk:Array;			if(_textData.indexOf(creturn) == -1)				creturn = String.fromCharCode(13);			if(!_startedParsing){				_startedParsing = true;				_vertices = new Vector.<Vertex>();				_vertexNormals = new Vector.<Vertex>();				_materialIDs = new Vector.<String>();				_materialLoaded = new Vector.<LoadedMaterial>();				_meshes = new Vector.<Mesh>();				_uvs = new Vector.<UV>();				 _stringLength = _textData.length;				_charIndex = _textData.indexOf(creturn, 0);				_oldIndex = 0;				_objects = new Vector.<ObjectGroup>();				_objectIndex = 0;			}			while(_charIndex<_stringLength && hasTime()){				_charIndex = _textData.indexOf(creturn, _oldIndex);				if(_charIndex == -1)					_charIndex = _stringLength;				line = _textData.substring(_oldIndex, _charIndex);				line = line.split('\r').join("");				trunk = line.replace("  "," ").split(" ");				_oldIndex = _charIndex+1;				parseLine(trunk);			}			if(_charIndex >= _stringLength){				if(_mtlLib  && !_mtlLibLoaded)					return MORE_TO_PARSE;				try {					translate();					applyMaterials();					return PARSING_DONE;				} catch(e:Error){					parsingFailure = true;					trace("parsing failure");				}			}			return MORE_TO_PARSE;		}		/**		 * Parses a single line in the OBJ file.		 */		private function parseLine(trunk : Array) : void		{			 switch (trunk[0]) {				case "mtllib":					_mtlLib = true;					_mtlLibLoaded = false;					loadMtl (trunk[1]);					break;				case "g":					createGroup(trunk);					break;				case "o":					createObject(trunk);					break;				case "usemtl":					if(_mtlLib){						_materialIDs.push(trunk[1]);						_activeMaterialID = trunk[1];						if(_currentGroup) _currentGroup.materialID= _activeMaterialID;					}					break;				case "v":					parseVertex(trunk);					break;				case "vt":					parseUV(trunk);					break;				case "vn":					parseVertexNormal(trunk);					break;				case "f":					parseFace(trunk);			}		}		/**		 * Converts the parsed data into an Away3D scenegraph structure		 */		private function translate() :void		{			var groups : Vector.<Group> = _objects[_objectIndex].groups;			var numGroups : uint = groups.length;			var materialGroups : Vector.<MaterialGroup>;			var numMaterialGroups : uint;			var geometry : Geometry;			var mesh : Mesh;			var meshid:uint;			_container.name = _objects[_objectIndex].name;			for (var g : uint = 0; g < numGroups; ++g) {				geometry = new Geometry();				materialGroups = groups[g].materialGroups;				numMaterialGroups = materialGroups.length;				for (var m : uint = 0; m < numMaterialGroups; ++m) {					translateMaterialGroup(materialGroups[m], geometry);				}				mesh = new Mesh(new BitmapMaterial(defaultBitmapData), geometry);				meshid = _meshes.length;				mesh.name = "obj"+meshid;				_meshes[meshid] = mesh;				if(groups[g].materialID != ""){					mesh.material.name = groups[g].materialID+"~"+mesh.name;				} else {					mesh.material.name = _lastMtlID+"~"+mesh.name;				}				_container.addChild(mesh);			}		}		/* if no uv's are found (often seen case with obj format) parser generates a new set of default uv's */				private function addDefaultUVs(subGeom : SubGeometry, vertices : Vector.<Number>) :void		{			var uvs:Vector.<Number> = new Vector.<Number>();						for (var i :uint = 0; i<vertices.length; i+=9)				uvs.push(0, 1, .5, 0, 1, 1);							subGeom.updateUVData(uvs);		}		/**		 * Translates an obj's material group to a subgeometry.		 * @param materialGroup The material group data to convert.		 * @param geometry The Geometry to contain the converted SubGeometry.		 */		private function translateMaterialGroup(materialGroup : MaterialGroup, geometry : Geometry) : void		{			var faces : Vector.<FaceData> = materialGroup.faces;			var face : FaceData;			var numFaces : uint = faces.length;			var numVerts : uint;			var subGeom : SubGeometry = new SubGeometry();			subGeom.updateVertexData(new Vector.<Number>());			subGeom.updateUVData(new Vector.<Number>());			subGeom.updateVertexNormalData(new Vector.<Number>());			subGeom.updateIndexData(new Vector.<uint>());			subGeom.autoDeriveVertexTangents = true;			subGeom.autoDeriveVertexNormals = _vertexNormals.length == 0;			_realIndices = [];			_vertexIndex = 0;			var v:uint;			for (var f : uint = 0; f < numFaces; ++f) {				face = faces[f];				numVerts = face.indexIds.length - 1;				for (v = 1; v < numVerts; ++v) {					translateVertexData(face, v, subGeom);					translateVertexData(face, 0, subGeom);					translateVertexData(face, v+1, subGeom);				}			}			var vlength:uint = subGeom.vertexData.length;			var indlength:uint = subGeom.indexData.length;			var uvlength:uint = subGeom.UVData.length;			if(indlength != 0 && vlength > 0){				subGeom.updateVertexData(subGeom.vertexData);				subGeom.updateIndexData(subGeom.indexData);				 if (uvlength> 0){					subGeom.updateUVData(subGeom.UVData);				} else if(uvlength == 0 && subGeom.vertexData.length > 0){					addDefaultUVs(subGeom, subGeom.vertexData);				}								if (!subGeom.autoDeriveVertexNormals) subGeom.updateVertexNormalData(subGeom.vertexNormalData);				geometry.addSubGeometry(subGeom);			}		}		/**		 * Converts the obj's face vertex data and adds it to a SubGeometry.		 * @param face The FaceData containing the vertex data.		 * @param vertexIndex The index into the face's vertex list.		 * @param subGeometry The SubGeometry to contain the vertex.		 */		private function translateVertexData(face : FaceData, vertexIndex : int, subGeometry : SubGeometry) : void		{			var index : uint;			var vertex : Vertex;			var vertexNormal : Vertex;			var uv : UV;			if (!_realIndices[face.indexIds[vertexIndex]]) {				index = _vertexIndex;				_realIndices[face.indexIds[vertexIndex]] = ++_vertexIndex;				vertex = _vertices[face.vertexIndices[vertexIndex]-1];				subGeometry.vertexData.push(vertex.x, vertex.y, vertex.z);				if (face.normalIndices.length > 0) {					vertexNormal = _vertexNormals[face.normalIndices[vertexIndex]-1];					subGeometry.vertexNormalData.push(vertexNormal.x, vertexNormal.y, vertexNormal.z);				}				if (face.uvIndices.length > 0) {					uv = _uvs[face.uvIndices[vertexIndex]-1];					subGeometry.UVData.push(uv.u, uv.v);				}			} else {				index = _realIndices[face.indexIds[vertexIndex]] - 1;			}			subGeometry.indexData.push(index);		}		/**		 * Creates a new object group.		 * @param trunk The data block containing the object tag and its parameters		 */		private function createObject(trunk : Array) : void		{			_currentGroup = null;			_currentMaterialGroup = null;			_objects.push(_currentObject = new ObjectGroup());			if (trunk) _currentObject.name = trunk[1];		}		/**		 * Creates a new group.		 * @param trunk The data block containing the group tag and its parameters		 */		private function createGroup(trunk : Array) : void		{			if (!_currentObject) createObject(null);			_currentGroup = new Group();			_currentGroup.materialID = _activeMaterialID;			if (trunk) _currentGroup.name = trunk[1];			_currentObject.groups.push(_currentGroup);			createMaterialGroup(null);		}		/**		 * Creates a new material group.		 * @param trunk The data block containing the material tag and its parameters		 */		private function createMaterialGroup(trunk : Array) : void		{			_currentMaterialGroup = new MaterialGroup();			if (trunk) _currentMaterialGroup.url = trunk[1];			_currentGroup.materialGroups.push(_currentMaterialGroup);		}		/**		 * Reads the next vertex coordinates.		 * @param trunk The data block containing the vertex tag and its parameters		 */		private function parseVertex(trunk : Array) : void		{			_vertices.push(new Vertex(parseFloat(trunk[1]), parseFloat(trunk[2]), -parseFloat(trunk[3])));		}		/**		 * Reads the next uv coordinates.		 * @param trunk The data block containing the uv tag and its parameters		 */		private function parseUV(trunk : Array) : void		{			_uvs.push(new UV(parseFloat(trunk[1]), 1-parseFloat(trunk[2])));		}		/**		 * Reads the next vertex normal coordinates.		 * @param trunk The data block containing the vertex normal tag and its parameters		 */		private function parseVertexNormal(trunk : Array) : void		{			_vertexNormals.push(new Vertex(parseFloat(trunk[1]), parseFloat(trunk[2]), -parseFloat(trunk[3])));		}		/**		 * Reads the next face's indices.		 * @param trunk The data block containing the face tag and its parameters		 */		private function parseFace(trunk : Array) : void		{			var len : uint = trunk.length;			var face : FaceData = new FaceData();			if (!_currentGroup) createGroup(null);			var indices : Array;			for (var i : uint = 1; i < len; ++i) {				if (trunk[i] == "") continue;				indices = trunk[i].split("/");				face.vertexIndices.push(parseInt(indices[0]));				if (indices[1] && String(indices[1]).length > 0) face.uvIndices.push(parseInt(indices[1]));				if (indices[2] && String(indices[2]).length > 0) face.normalIndices.push(parseInt(indices[2]));				face.indexIds.push(trunk[i]);			}			_currentMaterialGroup.faces.push(face);		}		private function parseMtl (event:Event):void		{			var loader:URLLoader = URLLoader(event.currentTarget);			var lines:Array = loader.data.split('\r').join("").split('\n');			if(lines.length == 1)				lines = loader.data.split(String.fromCharCode(13));			var trunk:Array;			var line:String;			var mapkd:String;			var isMap:Boolean;			var j:uint; 			for(var i:uint = 0; i<lines.length;++i) {				line = lines[i];				trunk = line.split(" ");				if(String(trunk[0]).charCodeAt(0) == 9 || String(trunk[0]).charCodeAt(0) == 32)					trunk[0] = trunk[0].substring(1, trunk[0].length);				switch (trunk[0]) {					case "newmtl":						_lastMtlID = trunk[1];						bmd = null;						break;											case "Kd":						var useColor:Boolean = true;						for(j=i+1;j<lines.length;++j){							if(lines[j].indexOf("map_Kd") != -1){								useColor = false;								break;							}							if(lines[j].indexOf("newmtl") != -1)								break;						}												if(useColor){							var lm:LoadedMaterial = new LoadedMaterial();							lm.materialID = _lastMtlID;							var color:uint = trunk[1]*255 << 16 | trunk[2]*255 << 8 | trunk[3]*255;							var bmd:BitmapData = new BitmapData(256, 256, false, color); 							lm.bitmapData = bmd ;							_materialLoaded.push(lm);														if(_meshes.length>0)								applyMaterial(lm);						}												break;						//Transparency no yet supported, same for Ka, Ns and Ns/Ni						/*						case "d":						case "Tr":							break;						*/					case "map_Kd":						mapkd = baseUri+parseMapKdString(trunk);						mapkd = mapkd.replace(/\\/g, "/");						_dependencies.push(new ResourceDependency(_lastMtlID, mapkd, null , this));						break;				}			}			_mtlLibLoaded = true;        }		private function parseMapKdString(trunk:Array):String		{			var url:String = "";			var i:int;			var breakflag:Boolean;			for(i = 1; i < trunk.length;) {				switch(trunk[i]) {					case "-blendu" :					case "-blendv" :					case "-cc" :					case "-clamp" :					case "-texres" :						i += 2;		//Skip ahead 1 attribute						break;					case "-mm" :						i += 3;		//Skip ahead 2 attributes						break;					case "-o" :					case "-s" :					case "-t" :						i += 4;		//Skip ahead 3 attributes						continue;					default :						breakflag = true;						break;				}				if(breakflag)					break;			}			//Reconstruct URL/filename			for(i; i < trunk.length; i++) {				url += trunk[i];				url += " ";			}			//Remove the extraneous space and/or newline from the right side			url = url.replace(/\s+$/,"");			return url;		}		private function errorMtl (event:Event):void		{			trace("ObjParser MTL LOAD ERROR: unable to load .mtl file");		}		private function loadMtl(mtlurl:String):void        {			var loader:URLLoader = new URLLoader();			loader.addEventListener(Event.COMPLETE, parseMtl);			loader.addEventListener(IOErrorEvent.IO_ERROR, errorMtl);			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorMtl);			loader.load(new URLRequest(baseUri+mtlurl));        }		private function applyMaterial(lm:LoadedMaterial) : void		{			var meshID:String;			var decomposeID:Array;			var mesh:Mesh;			var mat:BitmapMaterial;			for(var i:uint = 0; i <_meshes.length;++i){				mesh = _meshes[i];				decomposeID = mesh.material.name.split("~");				if(decomposeID[0] == lm.materialID){					mesh.material.name = decomposeID[1];					mat = BitmapMaterial(mesh.material);					mat.bitmapData = lm.bitmapData;					_meshes.splice(i, 1);					--i;				}			}		}				private function applyMaterials() : void		{			if(_materialLoaded.length == 0)				return;						for(var i:uint = 0; i <_materialLoaded.length;++i)				applyMaterial(_materialLoaded[i]);		}			}}// value objects:class ObjectGroup{	public var name : String;	public var groups : Vector.<Group> = new Vector.<Group>();}class Group{	public var name : String;	public var materialID : String;	public var materialGroups : Vector.<MaterialGroup> = new Vector.<MaterialGroup>();}class MaterialGroup{	public var url : String;	public var faces : Vector.<FaceData> = new Vector.<FaceData>();}class LoadedMaterial{	import flash.display.BitmapData;		public var materialID : String;	public var bitmapData : BitmapData;}class FaceData{	public var vertexIndices : Vector.<uint> = new Vector.<uint>();	public var uvIndices : Vector.<uint> = new Vector.<uint>();	public var normalIndices : Vector.<uint> = new Vector.<uint>();	public var indexIds : Vector.<String> = new Vector.<String>();	// used for real index lookups}