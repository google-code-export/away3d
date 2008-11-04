﻿package away3d.exporters{	import flash.system.*;	import flash.display.BitmapData;	import flash.utils.Dictionary;	   	import away3d.core.base.Vertex;	import away3d.core.base.UV;	import away3d.core.base.Mesh;	import away3d.core.base.Geometry;	import away3d.core.base.Object3D;	import away3d.containers.ObjectContainer3D;	import away3d.core.base.Face;	import away3d.core.base.Frame;	import away3d.core.math.Number3D;	import away3d.core.arcane;	import away3d.primitives.*;	import away3d.materials.BitmapMaterial;		 	/**	* Class AS3Exporter generates a string in the ActionScript3 format representing the object3D(s). The string is added to clipboard. Open and save the string into a texteditor.	* 	*/	public class AS3Exporter {		use namespace arcane;		private var useMesh:Boolean;		private var isAnim:Boolean;		private var asString:String;		private var containerString:String = "";		private var gcount:int = 0;		private var objcount:int = 0;		private var indV:int = 0;		private var indVt:int = 0;		private var indF:int = 0;		private var MaV:Array = [];		private var MaVt:Array = [];		private var p1 = new RegExp(".0000","g");		private var p2 = new RegExp("3333","g");		private var p3 = new RegExp("6666","g");		private var p4 = new RegExp("dddd","g");		private var p5 = new RegExp("cccc","g");		private var p6 = new RegExp("bbb","g");		private var p7 = new RegExp(",0.","g");		private var p8 = new RegExp("/0.","g");		private var p9 = new RegExp("/-","g");				//primitives, segments not supported yet		private var aTypes:Array =  [Plane, Sphere, Cube, Cone, Cylinder, RegularPolygon, Torus]; 		 		private  function write(object3d:Object3D, isInContainer:Boolean):void		{			var mat:String = "null"; 			var nameinsert:String = (object3d.name == null)? "name:null" : "name:\""+object3d.name+"\"";			var type:String = "";			for( var i:int = 0; i<aTypes.length ; ++i)			{				if(object3d is aTypes[i]){					type = (""+aTypes[i]);					type = type.substring(7, type.length-1);					break;				}			}			if(type != ""){					asString +="\n\t\t\tobjs.obj"+objcount+" = {type:"+type+"};";					var objname:String = ""+type.toLowerCase()+objcount;										switch(type){						case "Sphere":							asString +="\n\t\t\tvar "+objname+":"+type+" = new "+type+"({"+nameinsert+", bothsides:"+(object3d as Mesh).bothsides+", material:"+mat+", segmentsH:"+(object3d as aTypes[i]).segmentsH+", segmentsW:"+(object3d as aTypes[i]).segmentsW+", radius:"+(object3d as aTypes[i]).radius+", yUp:"+(object3d as aTypes[i]).yUp+"});";							break;						case "Plane":							asString +="\n\t\t\tvar "+objname+":"+type+" = new "+type+"({"+nameinsert+", bothsides:"+(object3d as Mesh).bothsides+", material:"+mat+", segmentsH:"+(object3d as aTypes[i]).segmentsH+", segmentsW:"+(object3d as aTypes[i]).segmentsW+", width:"+(object3d as aTypes[i]).width+", height:"+(object3d as aTypes[i]).height+", yUp:"+(object3d as aTypes[i]).yUp+"});";							break;						case "Cone":							asString +="\n\t\t\tvar "+objname+":"+type+" = new "+type+"({"+nameinsert+", bothsides:"+(object3d as Mesh).bothsides+", material:"+mat+", segmentsH:"+(object3d as aTypes[i]).segmentsH+", segmentsW:"+(object3d as aTypes[i]).segmentsW+", radius:"+(object3d as aTypes[i]).radius+", height:"+(object3d as aTypes[i]).height+", openEnded:"+(object3d as aTypes[i]).openEnded+", yUp:"+(object3d as aTypes[i]).yUp+"});";							break;						case "Cube":							//material list not supported yet							asString +="\n\t\t\tvar "+objname+":"+type+" = new "+type+"({"+nameinsert+", bothsides:"+(object3d as Mesh).bothsides+", material:"+mat+", height:"+(object3d as aTypes[i]).height+", depth:"+(object3d as aTypes[i]).depth+", width:"+(object3d as aTypes[i]).width+", yUp:"+(object3d as aTypes[i]).yUp+"});";							break;						case "Cylinder":							asString +="\n\t\t\tvar "+objname+":"+type+" = new "+type+"({"+nameinsert+", bothsides:"+(object3d as Mesh).bothsides+", material:"+mat+", segmentsH:"+(object3d as aTypes[i]).segmentsH+", segmentsW:"+(object3d as aTypes[i]).segmentsW+", radius:"+(object3d as aTypes[i]).radius+", height:"+(object3d as aTypes[i]).height+", openEnded:"+(object3d as aTypes[i]).openEnded+", yUp:"+(object3d as aTypes[i]).yUp+"});";							break;						case "RegularPolygon":							asString +="\n\t\t\tvar "+objname+":"+type+" = new "+type+"({"+nameinsert+", bothsides:"+(object3d as Mesh).bothsides+", material:"+mat+", radius:"+(object3d as aTypes[i]).radius+", sides:"+(object3d as aTypes[i]).sides+", yUp:"+(object3d as aTypes[i]).yUp+"});";							break;						case "Torus":							asString +="\n\t\t\tvar "+objname+":"+type+" = new "+type+"({"+nameinsert+", bothsides:"+(object3d as Mesh).bothsides+", material:"+mat+", segmentsR:"+(object3d as aTypes[i]).segmentsR+", segmentsT:"+(object3d as aTypes[i]).segmentsT+", radius:"+(object3d as aTypes[i]).radius+", tube:"+(object3d as aTypes[i]).tube+", yUp:"+(object3d as aTypes[i]).yUp+"});";							break;					}										if((object3d as aTypes[i]).rotationX != 0) asString += "\n\t\t\t"+objname+".rotationX="+(object3d as aTypes[i]).rotationX+";";					if((object3d as aTypes[i]).rotationY != 0) asString += "\n\t\t\t"+objname+".rotationY="+(object3d as aTypes[i]).rotationY+";";					if((object3d as aTypes[i]).rotationZ != 0) asString += "\n\t\t\t"+objname+".rotationZ="+(object3d as aTypes[i]).rotationZ+";";										asString += "\n\t\t\t"+objname+".position= new Number3D("+object3d.x+","+object3d.y+","+object3d.z+");";					asString += "\n\t\t\toList.push("+objname+");";										if(isInContainer){						asString += "\n\t\t\taC["+(gcount-1)+"].addChild("+objname+");\n";					} else{						asString += "\n\t\t\t_scene.addChild("+objname+");\n";					}								} else {					useMesh = true;					var aV:Array = [];					var aVt:Array = [];					var aF:Array = [];					asString +="\n\t\t\tobjs.obj"+objcount+" = {type:null, "+nameinsert+", rotations:new Number3D("+object3d.rotationX+","+object3d.rotationY+","+object3d.rotationZ+"), position:new Number3D("+object3d.x+","+object3d.y+","+object3d.z+"), container:"+((isInContainer)? gcount: "null")+", bothsides:"+(object3d as Mesh).bothsides+", material:"+mat+"};";					 					var aFaces:Array = (object3d as Mesh).faces;					var geometry:Geometry = (object3d as Mesh).geometry;					var va:int;					var vb:int;					var vc:int;					var vta:int;					var vtb:int;					var vtc:int;					var nPos:Number3D = object3d.scenePosition;					var tmp:Number3D = new Number3D();					var j:int;					var aRef:Array = [vc, vb, va];					var animated:Boolean = (object3d as Mesh).geometry.frames != null;					var face:Face;										for(i = 0; i<aFaces.length ; ++i)					{						face = aFaces[i];						 						for(j=0;j<3;++j){							tmp.x =  face["v"+j].x;							tmp.y =  face["v"+j].y;							tmp.z =  face["v"+j].z;							aRef[j] = checkDoubles( MaV, (tmp.x.toFixed(4)+"/"+tmp.y.toFixed(4)+"/"+tmp.z.toFixed(4)) );						}												vta = checkDoubles( MaVt, face.uv0.u +"/"+ face.uv0.v);						vtb = checkDoubles( MaVt, face.uv1.u +"/"+ face.uv1.v);						vtc = checkDoubles( MaVt, face.uv2.u +"/"+ face.uv2.v);												 						aF.push( aRef[0]+","+aRef[1]+","+aRef[2]+","+vta+","+vtb+","+vtc);											}										asString +="\n\t\t\tobjs.obj"+objcount+".f=[";					for( i = 0; i < aF.length ; ++i){						asString += aF[i]+((i<aF.length-1)? "," : "];\n");					}											if(animated) {						readVertexAnimation((object3d as Mesh), "objs.obj"+objcount);					}  			}			objcount ++;		}				private function readVertexAnimation(obj:Mesh, id:String):void{			isAnim = true;			asString +="\n\t\t\tobjs.obj"+objcount+".meshanimated=true;\n";						var tmpnames:Array = [];			var i:int = 0;			var j:int = 0;			var fr:Frame;			var avp:Array;			var afn:Array = [];			//reset names in logical sequence			for (var framename:String in obj.geometry.framenames){				tmpnames.push(framename);			}			tmpnames.sort(); 			var myPattern:RegExp = new RegExp(" ","g");									for (i = 0;i<tmpnames.length;++i){				avp = [];				fr = obj.geometry.frames[obj.geometry.framenames[tmpnames[i]]];				if(tmpnames[i].indexOf(" ") != -1) tmpnames[i] = tmpnames[i].replace(myPattern,"");				afn.push("\""+tmpnames[i]+"\"");				asString += "\n\t\t\t"+id+".fr"+tmpnames[i]+"=[";								for(j = 0; j<fr.vertexpositions.length ;++j){						avp.push(fr.vertexpositions[j].x.toFixed(1));						avp.push(fr.vertexpositions[j].y.toFixed(1));						avp.push(fr.vertexpositions[j].z.toFixed(1)); 				}				asString += avp.toString()+"];\n";			}			//restore right sequence voor non sync md2 files			fr = obj.geometry.frames[obj.geometry.framenames[tmpnames[0]]];			var verticesorder:Array = fr.getIndexes(obj.vertices);			var indexes:Array = [];			var face:Face;			var ox:Number;			var oy:Number;			var oz:Number;			var ind:int = 0;			var k:int;			var tmpval:Number = -1234567890;			for(i = 0; i<obj.faces.length ; ++i)			{				face = obj.faces[i];				for(j=2;j>-1;--j){					ox = face["v"+j].x;					oy = face["v"+j].y;					oz = face["v"+j].z;					ind = 0;					face["v"+j].x = tmpval;					face["v"+j].y = tmpval;					face["v"+j].z = tmpval;					for(k= 0;k<obj.vertices.length;++k){						if( obj.vertices[k].x == tmpval && obj.vertices[k].y == tmpval && obj.vertices[k].z == tmpval){ 							ind = k;							break;						}					}					face["v"+j].x = ox;					face["v"+j].y = oy;					face["v"+j].z = oz;					indexes.push(ind);				}			}						asString += "\n\t\t\t"+id+".indexes=["+indexes.toString()+"];\n";			asString += "\n\t\t\t"+id+".fnarr = ["+afn.toString()+"];\n";					}		private function checkUnicV(arr:Array, v:Vertex, mesh:Mesh):int		{			for(var i:int = 0;i<arr.length;++i){				if(v === arr[i].vertex){					return arr[i].index;				}			}			var id:int;			for(i = 0;i<mesh.vertices.length;++i){				if(v == mesh.vertices[i]){					id = i;					break;				}			}			arr.push({vertex:v, index:id});			 			return id;		}		//to be replaced by the checkdouble code		private function checkUnicUV(arr:Array, uv:UV, mesh:Mesh):int		{			for(var i:int = 0;i<arr.length;++i){				if(uv === arr[i]) return i;			}			arr.push(uv);			return int(arr.length-1);					}		private function checkDoubles(arr:Array, string:String):int		{			string = string.replace(p1,"a").replace(p2,"b").replace(p3,"c").replace(p4,"d").replace(p5,"e").replace(p6,"f").replace(p7,"g").replace(p8,"h").replace(p9,"i");						for(var i:int = 0;i<arr.length;++i)				if(arr[i] == string) return i;			 			arr.push(string);			return arr.length-1;		}				private  function parse(object3d:Object3D, isInContainer:Boolean = false, containerid:int = 0):void		{			if(object3d is ObjectContainer3D){				var obj:ObjectContainer3D = (object3d as ObjectContainer3D);								var id:int = gcount;				containerString +="\n\t\t\tvar cont"+id+":ObjectContainer3D = new ObjectContainer3D();\n";				if(isInContainer){					containerString +="\t\t\tcont"+containerid+".addChild(cont"+id+");\n";				}else{					containerString +="\t\t\t_scene.addChild(cont"+id+");\n";				}				containerString +="\t\t\taC.push(cont"+id+");\n";				if(obj.x != 0) containerString +="\t\t\tcont"+id+".x = "+obj.x+";\n";				if(obj.y != 0) containerString +="\t\t\tcont"+id+".y = "+obj.y+";\n";				if(obj.z != 0) containerString +="\t\t\tcont"+id+".z = "+obj.z+";\n";				if(obj.rotationX != 0) containerString +="\t\t\tcont"+id+".rotationX = "+obj.rotationX+";\n";				if(obj.rotationY != 0) containerString +="\t\t\tcont"+id+".rotationY = "+obj.rotationY+";\n";				if(obj.rotationZ != 0) containerString +="\t\t\tcont"+id+".rotationZ = "+obj.rotationZ+";\n";				if(obj.name != null) containerString +="\t\t\tcont"+id+".name = \""+obj.name+"\";\n";								gcount++;								for(var i:int =0;i<obj.children.length;i++){					if(obj.children[i] is ObjectContainer3D){						parse(obj.children[i], true, id);					} else{						write( obj.children[i], true);					}				}						} else {				write( object3d, isInContainer);			}		}				/**		* Generates a string in the Actionscript3 format representing the object3D(s). Paste to a texteditor and save as filename.as.		*		* @param	object3d				Object3D. The Object3D to be exported to WaveFront obj format.		* @param	classname				[optional] Defines the class name used in the output string. Defaults to <code>Away3DObject</code>. 		* @param	packagename			[optional] Defines the package name used in the output string. Defaults to no package.		*/		function AS3Exporter(object3d:Object3D, classname:String = null, packagename:String = ""){//, embed:Boolean = true){			asString = "//AS3 exporter version 2.0, generated by Away3D: http://www.away3d.com\n";            asString += "package "+packagename+"\n{\n\timport away3d.containers.ObjectContainer3D;\n\timport away3d.containers.Scene3D;\n\timport away3d.core.math.Number3D;\n\timport away3d.materials.BitmapMaterial;\n\timport away3d.core.base.VertexPosition;\n\timport away3d.core.base.Frame;\n\timport away3d.core.base.Mesh;\n\timport away3d.core.base.UV;\n\timport away3d.core.base.Face;\n\timport away3d.core.base.Vertex;\n\timport away3d.core.utils.Init;\n\timport flash.utils.Dictionary;\n\timport away3d.primitives.*;\n\n\tpublic class "+classname+"\n\t{\n";			asString += "\t\tprivate var objs:Object = {};\n\t\tprivate var oList:Array =[];\n\t\tprivate var aC:Array;\n\t\tprivate var aV:Array;\n\t\tprivate var aU:Array;\n\t\tprivate var _scene:Scene3D;\n\t\tprivate var _scaling:Number;\n\n";			asString += "\t\tpublic function "+classname+"(scene:Scene3D, init:Object = null)\n\t\t{\n\t\t\t_scene = scene;\n\t\t\tvar ini:Init = Init.parse(init);\n\t\t\t_scaling = ini.getNumber(\"scaling\", 1);\n\t\t\tsetSource();\n\t\t\taddContainers();\n\t\t\tbuild();\n\t\t\tcleanUp();\n\t\t}\n\n";			             asString += "\t\tprivate function build():void\n\t\t{";			parse(object3d);			if(useMesh){				asString += "\n\t\t\tvar ref:Object;\n\t\t\tvar mesh:Mesh;\n\t\t\tvar j:int;\n\t\t\tvar av:Array;\n\t\t\tvar au:Array;\n\t\t\tvar v0:Vertex;\n\t\t\tvar v1:Vertex;\n\t\t\tvar v2:Vertex;\n\t\t\tvar u0:UV;\n\t\t\tvar u1:UV;\n\t\t\tvar u2:UV;\n\t\t\tfor(var i:int = 0;i<"+objcount+";++i){\n";				asString += "\t\t\t\tref = objs[\"obj\"+i];\n";				asString += "\t\t\t\tif(ref.type == null){\n";				asString += "\t\t\t\t\tmesh = new Mesh();\n\t\t\t\t\tmesh.type = \".as\";\n";				asString += "\t\t\t\t\tfor(j = 0;j<ref.f.length;j+=6){\n";				asString += "\t\t\t\t\t\t\ttry{\n";				asString += "\t\t\t\t\t\t\tav = aV[ref.f[j]].split(\"/\");\n";				asString += "\t\t\t\t\t\t\tv0 = new Vertex(parseFloat(av[0]), parseFloat(av[1]), parseFloat(av[2]));\n";				asString += "\t\t\t\t\t\t\tav = aV[ref.f[j+1]].split(\"/\");\n";				asString += "\t\t\t\t\t\t\tv1 = new Vertex(parseFloat(av[0]), parseFloat(av[1]), parseFloat(av[2]));\n";				asString += "\t\t\t\t\t\t\tav = aV[ref.f[j+2]].split(\"/\");\n";				asString += "\t\t\t\t\t\t\tv2 = new Vertex(parseFloat(av[0]), parseFloat(av[1]), parseFloat(av[2]));\n";				asString += "\t\t\t\t\t\t\tau = aU[ref.f[j+3]].split(\"/\");\n";				asString += "\t\t\t\t\t\t\tu0 = new UV(parseFloat(au[0]), parseFloat(au[1]));\n";				asString += "\t\t\t\t\t\t\tau = aU[ref.f[j+4]].split(\"/\");\n";				asString += "\t\t\t\t\t\t\tu1 = new UV(parseFloat(au[0]), parseFloat(au[1]));\n";				asString += "\t\t\t\t\t\t\tau = aU[ref.f[j+5]].split(\"/\");\n";				asString += "\t\t\t\t\t\t\tu2 = new UV(parseFloat(au[0]), parseFloat(au[1]));\n";				asString += "\t\t\t\t\t\t\tmesh.addFace( new Face(v0, v1, v2, ref.material, u0, u1, u2) );\n";				asString += "\t\t\t\t\t\t}catch(e:Error){\n";				asString += "\t\t\t\t\t\t\ttrace(\"obj\"+i+\": [\"+aV[ref.f[j]].split(\"/\")+\"],[\"+aV[ref.f[j+1]].split(\"/\")+\"],[\"+aV[ref.f[j+2]].split(\"/\")+\"]\");\n";				asString += "\t\t\t\t\t\t\ttrace(\"     uvs: [\"+aV[ref.f[j+3]].split(\"/\")+\"],[\"+aV[ref.f[j+4]].split(\"/\")+\"],[\"+aV[ref.f[j+5]].split(\"/\")+\"]\");\n";				asString += "\t\t\t\t\t\t}\n\t\t\t\t\t}\n";				asString += "\t\t\t\t\tif(ref.meshanimated) setMeshAnim(mesh, ref, oList.length);\n";				asString += "\t\t\t\t\tif(ref.indexes != null) mesh.indexes = ref.indexes;\n";				asString += "\t\t\t\t\tmesh.bothsides = ref.bothsides;\n\t\t\t\t\tmesh.name = ref.name;\n";				asString += "\t\t\t\t\tif(ref.container == null){\n\t\t\t\t\t\t_scene.addChild(mesh);\n\t\t\t\t\t} else {\n\t\t\t\t\t\taC[ref.container-1].addChild(mesh);\n\t\t\t\t\t}\n";				asString += "\n\t\t\t\t\toList.push(mesh);";				asString += "\n\t\t\t\t\tmesh.position = ref.position;\n\t\t\t\t\tmesh.rotationX = ref.rotations.x;\n\t\t\t\t\tmesh.rotationY = ref.rotations.y;\n\t\t\t\t\tmesh.rotationZ = ref.rotations.z;\n\t\t\t\t}\n\t\t\t}\n";				asString += "\t\t}";				asString += "\n\t\t\tprivate function regText(str:String):String\n";				asString += "\t\t\t{\n";				asString += "\t\t\t\tvar aPats:Array = [\".0000\",\"3333\",\"6666\",\"dddd\",\"cccc\",\"bbb\",\",0.\",\"/0.\",\"/-\",\"0/\" ,\"00\"];\n";				asString += "\t\t\t\tvar patt:RegExp;\n";				asString += "\t\t\t\tfor(var i:int = 11;i>0;--i){\n";				asString += "\t\t\t\t\tpatt = new RegExp(String.fromCharCode(96+i),\"g\");\n";				asString += "\t\t\t\t\tstr = str.replace(patt, aPats[i-1]);\n";				asString += "trace(\"[\"+String.fromCharCode(96+i)+\"],[\"+aPats[i-1]+\"]\");\n";				asString += "\t\t\t\t}\n";				asString += "\t\t\t\treturn str;\n";				asString += "\t\t\t}\n";				asString += "\n\n\t\tprivate function setSource():void\n\t\t{";				asString += "\t\t\tvar aVstr:String=\""+MaV.toString()+"\";\n\t\t\tvar aUstr:String=\""+MaVt.toString()+"\";\n";				asString += "\t\t\taV= regText(aVstr).split(\",\");\n\t\t\taU= regText(aUstr).split(\",\");\n";				asString += "\t\t}";			} else{				asString += "\t\t}";				 asString += "\n\n\t\tprivate function setSource():void\n\t\t{}\n";			}						asString += "\n\t\tprivate function cleanUp():void\n\t\t{";			asString += "\n\t\t\tfor(var i:int = 0;i<"+objcount+";++i){\n\t\t\t\tobjs[\"obj\"+i] == null;\n\t\t\t}\n\t\t\taV = null;\n\t\t\taU = null;\n\t\t}";									asString += "\n\n\t\tprivate function setMeshAnim(mesh:Mesh, obj:Object, id:int):void\n\t\t{\n";			if(isAnim){				asString += "\n\t\t\ttrace(\"\\nAnimation frames prefixes for : this.meshes[\"+id+\"]\");";				asString += "\n\t\t\tmesh.geometry.frames = new Dictionary();";            	asString += "\n\t\t\tmesh.geometry.framenames = new Dictionary();";				asString += "\n\t\t\tvar y:int;\n";				asString += "\t\t\tvar z:int;\n";				asString += "\t\t\tvar frame:Frame;\n";				asString += "\t\t\tvar vp:VertexPosition;\n";				asString += "\t\t\tfor(var i:int = 0;i<obj.fnarr.length; ++i){\n";				asString += "\t\t\t\ttrace(\"[ \"+obj.fnarr[i]+\" ]\");\n";				asString += "\t\t\t\tframe = new Frame();\n";				asString += "\t\t\t\tmesh.geometry.framenames[obj.fnarr[i]] = i;\n";				asString += "\t\t\t\tmesh.geometry.frames[i] = frame;\n";				asString += "\t\t\t\tz=0;\n";				asString += "\t\t\t\tfor (y = 0; y < obj[\"fr\"+obj.fnarr[i]].length; y+=3){\n";				asString += "\t\t\t\t\tvp = new VertexPosition(mesh.vertices[z]);\n";				asString += "\t\t\t\t\tz++;\n";				asString += "\t\t\t\t\tvp.x = obj[\"fr\"+obj.fnarr[i]][y]*_scaling;\n";				asString += "\t\t\t\t\tvp.y = obj[\"fr\"+obj.fnarr[i]][y+1]*_scaling;\n";				asString += "\t\t\t\t\tvp.z = obj[\"fr\"+obj.fnarr[i]][y+2]*_scaling;\n";				asString += "\t\t\t\t\tframe.vertexpositions.push(vp);\n";				asString += "\t\t\t\t}\n";				asString += "\t\t\t\tif (i == 0)\n";				asString += "\t\t\t\t\tframe.adjust();\n";				asString += "\t\t\t}\n";			}			asString += "\t\t}";									if(containerString != ""){				asString += "\n\n\t\tprivate function addContainers():void\n\t\t{\n";				asString += "\t\t\taC = [];\n";				asString += "\t\t\t"+containerString+"\n";				asString += "\t\t}";				asString += "\n\n\t\tpublic function get containers():Array\n\t\t{\n";				asString += "\t\t\treturn aC;\n";				asString += "\t\t}\n";			} else{				  asString += "\n\n\t\tprivate function addContainers():void\n\t\t{}\n";			}									asString += "\n\n\t\tpublic function get meshes():Array\n\t\t{\n";			asString += "\t\t\treturn oList;\n\t\t}\n";		 			asString += "\n\t}\n}";			System.setClipboard(asString);			asString = "";			trace("\n----------------------------------------------------------------------------\n AS3Exporter done: open a texteditor,\n\tpaste and save file in directory \""+packagename+"\" as \""+classname+".as\".\n----------------------------------------------------------------------------\n");		}			}}