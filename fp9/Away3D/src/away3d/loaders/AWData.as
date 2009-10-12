﻿package away3d.loaders{    import away3d.containers.ObjectContainer3D;    import away3d.arcane;    import away3d.core.base.*;    import away3d.core.utils.*;    import away3d.materials.BitmapFileMaterial;	import away3d.core.math.*;	import away3d.core.utils.Init;	import away3d.loaders.utils.*;	import away3d.loaders.data.*;	 	use namespace arcane;	    /**    * File loader/parser for the native .awd data file format.<br/>    */	    public class AWData extends AbstractParser    {		private var objs:Array = [];		private var geos:Array = [];		private var oList:Array =[];		private var aC:Array = [];		private var resolvedP:String = "";		private var url:String = "";		private var customPath:String = "";		     	/** @private */        arcane override function prepareData(data:*):void        {        	var awdData:String = Cast.string(data);			var lines:Array = awdData.split('\n');			if(lines.length == 1) lines = awdData.split(String.fromCharCode(13));			var trunk:Array;			var state:String = "";			var isMesh:Boolean;			var isMaterial:Boolean;			var id:int = 0;			var buffer:int=0;			var oData:Object;			var dline:Array;			var m:Matrix3D;			var cont:ObjectContainer3D;			var i:uint;			var version:String = "";			            for each (var line:String in lines)            {					if(line.substring(0,1) == "#" && state != line.substring(0,2)){						state = line.substring(0,2);						id = 0;						buffer = 0;												if(state == "#v")							version = line.substring(3,line.length-1);													if(state == "#f"){							isMaterial = (parseInt(line.substring(3,4)) == 2) as Boolean;							resolvedP = "";							if(isMaterial){								if(customPath != ""){									resolvedP = customPath;								} else if(url != ""){									var pathArray:Array = url.split("/");									pathArray.pop();									resolvedP = (pathArray.length>0)?pathArray.join("/")+"/":pathArray.join("/");								}							}						}													if(state == "#t")							isMesh = (line.substring(3,7) == "mesh") as Boolean;						 						continue;					}										dline = line.split(",");										if(dline.length <= 1)						continue;						 					if(state == "#o"){												if(buffer == 0){								id = dline[0];								m = new Matrix3D();								m.sxx = parseFloat(dline[1]);								m.sxy = parseFloat(dline[2]);								m.sxz = parseFloat(dline[3]);								m.tx = parseFloat(dline[4]);								m.syx = parseFloat(dline[5]);								m.syy = parseFloat(dline[6]);								m.syz = parseFloat(dline[7]);								m.ty = parseFloat(dline[8]);								m.szx = parseFloat(dline[9]);								m.szy = parseFloat(dline[10]);								m.szz = parseFloat(dline[11]);								m.tz = parseFloat(dline[12]);																++buffer;						} else {															oData = {name:(dline[0] == "")? "m_"+id: dline[0] ,											transform:m,											pivotPoint:new Number3D(parseFloat(dline[1]), parseFloat(dline[2]), parseFloat(dline[3])),											container:parseInt(dline[4]),											bothsides:(dline[5] == "true")? true : false,											ownCanvas:(dline[6] == "true")? true : false,											pushfront:(dline[7] == "true")? true : false,											pushback:(dline[8] == "true")? true : false,											x:parseFloat(dline[9]),											y:parseFloat(dline[10]),											z:parseFloat(dline[11]),											material:(isMaterial && dline[12] != null && dline[12] != "")? resolvedP+((customPath != "")? dline[12].substring(7, dline[12].length):dline[12]) : null};																			objs.push(oData);								buffer = 0;						}											}										if(state == "#d"){												switch(buffer){							case 0:								id = geos.length;								geos.push({});								++buffer;								geos[id].aVstr = line.substring(2,line.length);								break;															case 1:								geos[id].aUstr = line.substring(2,line.length);								geos[id].aV= read(geos[id].aVstr).split(",");								geos[id].aU= read(geos[id].aUstr).split(",");								++buffer;								break;															case 2:								geos[id].f= line.substring(2,line.length);								buffer = 0;								objs[id].geo = geos[id];						}											}																	if(state == "#c" && !isMesh){						 						id = parseInt(dline[0]);						cont = new ObjectContainer3D();						m = new Matrix3D();						m.sxx = parseFloat(dline[1]);						m.sxy = parseFloat(dline[2]);						m.sxz = parseFloat(dline[3]);						m.tx = parseFloat(dline[4]);						m.syx = parseFloat(dline[5]);						m.syy = parseFloat(dline[6]);						m.syz = parseFloat(dline[7]);						m.ty = parseFloat(dline[8]);						m.szx = parseFloat(dline[9]);						m.szy = parseFloat(dline[10]);						m.szz = parseFloat(dline[11]);						m.tz = parseFloat(dline[12]);						 						cont.transform = m;						cont.name = (dline[13] == "null" || dline[13] == undefined)? "cont_"+id: dline[13];						 						aC.push(cont);						 						if(aC.length > 1)							aC[0].addChild(cont);					}						            }						var ref:Object;			var mesh:Mesh;			var j:int;			var av:Array;			var au:Array;			var v0:Vertex;			var v1:Vertex;			var v2:Vertex;			var u0:UV;			var u1:UV;			var u2:UV;			var aRef:Array ;			 			for(i = 0;i<objs.length;++i){				 				ref = objs[i];				if(ref != null){					mesh = new Mesh();					mesh.type = ".awd";					mesh.bothsides = ref.bothsides;					mesh.name = ref.name;					mesh.pushfront = ref.pushfront;					mesh.pushback = ref.pushback;					mesh.ownCanvas = ref.ownCanvas;					 					if(ref.container != -1 && !isMesh)						aC[ref.container].addChild(mesh); 										mesh.transform = ref.transform;										mesh.movePivot(ref.pivotPoint.x, ref.pivotPoint.y, ref.pivotPoint.z);					mesh.material = (ref.material == null)? ref.material : new BitmapFileMaterial(ref.material);										aRef = ref.geo.f.split(",");					 					for(j = 0;j<aRef.length;j+=6){						av = ref.geo.aV[parseInt(aRef[j], 16)].split("/");						v0 = new Vertex(parseFloat(av[0]), parseFloat(av[1]), parseFloat(av[2]));						av = ref.geo.aV[parseInt(aRef[j+1],16)].split("/");						v1 = new Vertex(parseFloat(av[0]), parseFloat(av[1]), parseFloat(av[2]));						av = ref.geo.aV[parseInt(aRef[j+2],16)].split("/");						v2 = new Vertex(parseFloat(av[0]), parseFloat(av[1]), parseFloat(av[2]));						au = ref.geo.aU[parseInt(aRef[j+3],16)].split("/");						u0 = new UV(parseFloat(au[0]), parseFloat(au[1]));						au = ref.geo.aU[parseInt(aRef[j+4],16)].split("/");						u1 = new UV(parseFloat(au[0]), parseFloat(au[1]));						au = ref.geo.aU[parseInt(aRef[j+5],16)].split("/");						u2 = new UV(parseFloat(au[0]), parseFloat(au[1]));						 						mesh.addFace( new Face(v0, v1, v2, null, u0, u1, u2) );					}									}			}						container = isMesh? mesh : aC[0];			cleanUp();		}				private function cleanUp():void		{			for(var i:int = 0;i<objs.length;++i){				objs[i] == null;			}			objs = geos = oList = aC = null;		}				private function read(str:String):String		{			var start:int= 0;			var chunk:String;			var end:int= 0;			var dec:String = "";			var charcount:int = str.length;			for(var i:int = 0;i<charcount;++i){				if (str.charCodeAt(i)>=44 && str.charCodeAt(i)<= 48 ){					dec+= str.substring(i, i+1);				}else{					start = i;					chunk = "";					while(str.charCodeAt(i)!=44 && str.charCodeAt(i)!= 45 && str.charCodeAt(i)!= 46 && str.charCodeAt(i)!= 47 && i<=charcount){						i++;					}					chunk = ""+parseInt("0x"+str.substring(start, i), 16 );					dec+= chunk;					i--;				}			}			return dec;		}		 		/**		 * Creates a new <code>AWData</code> object.		 * @see away3d.loaders.AWData#parse()		 * @see away3d.loaders.AWData#load()		 */		public function AWData(init:Object = null)        {				super(init);			url = ini.getString("url", "");			binary = false;        }		/**		 * Creates an Object3D from the raw ascii data of an .awd file. The Away3D native.awd data files.		 * Exporters to awd format are available in Away3d exporters package and in PreFab3D export options.		 * 		 * @param	data				The ascii data of a .awd file.		 * @param	init				[optional]	An initialisation object for specifying default instance properties.		 * 		 * @return						An Object3D representation of the .awd file.		 */        public static function parse(data:*, init:Object = null):Object3D        {            return Loader3D.parseGeometry(data, AWData, init).handle;        }    	    	/**    	 * Loads and parses a .awd file (The Away3D native.awd data files) into an Object3D object.		 * @param	url					The url location of the .awd file to load.    	 * @param	init				[optional]	An initialisation object for specifying default instance properties.    	 *     	 * @return						A 3d loader object that can be used as a placeholder in a scene while the file is loading.    	 */        public static function load(url:String, init:Object = null):Loader3D        {			if(init== null)				init = {};							if(init.url == null)				init.url = url;							return Loader3D.loadGeometry(url, AWData, init);        }		/**		 * Allows to set custom path to source(s) map(s) other than set in file		 * Standard output url from Prefab awd files is "images/filename.jpg"		 * when set pathToSources, url becomes  [newurl]filename.jpg.		 * Example: AWData.pathToSources = "mydisc/myfiles/";		 */		public function set pathToSources(url:String):void		{			customPath = url;		}    }}