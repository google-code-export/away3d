﻿package away3d.tools{		import away3d.core.base.Mesh;	import away3d.core.base.Vertex;	import away3d.core.base.Face;	import away3d.core.base.UV;	import away3d.core.base.Object3D;	import away3d.containers.ObjectContainer3D;	import away3d.materials.Material;	import away3d.arcane;		use namespace arcane;		/**	 * Class Explode corrects all the faces of an object3d with unic vertexes.<code>Explode</code>	 * Each faces can then be moved independently without influence for the surrounding faces. 	 */	public class Explode{		private var _unicmeshes:Boolean;		private var _unicuvs:Boolean;		private var _recenter:Boolean;		private var _container:ObjectContainer3D;		 		private function parse(object3d:Object3D):void		{			 			if(object3d is ObjectContainer3D){							var obj:ObjectContainer3D = (object3d as ObjectContainer3D);							for(var i:uint =0;i<obj.children.length;++i){										if(obj.children[i] is ObjectContainer3D){						parse(obj.children[i]);					} else if(obj.children[i] is Mesh){						explode(obj.children[i] as Mesh);					}				}							}else if(object3d is Mesh){				explode( object3d as Mesh);			}			 		}		 		private function explode(obj:Mesh):void		{				var i:int = 0;				var loop:int = obj.faces.length;				var face:Face;				var va: Vertex;				var vb: Vertex;				var vc :Vertex;								var uva: UV;				var uvb: UV;				var uvc :UV;				 				if(_unicmeshes){										var mesh:Mesh;										for(i=0;i<loop;++i){												face = obj.faces[i];						mesh = new Mesh();												va = new Vertex(face.v0.x, face.v0.y, face.v0.z);						vb = new Vertex(face.v1.x, face.v1.y, face.v1.z);						vc = new Vertex(face.v2.x, face.v2.y, face.v2.z);						uva = new UV(face.uv0.u, face.uv0.v);						uvb = new UV(face.uv1.u, face.uv1.v);						uvc = new UV(face.uv2.u, face.uv2.v);												mesh.addFace(new Face(va, vb, vc, obj.material as Material, uva, uvb, uvc));						_container.addChild(mesh);												if(_recenter)							mesh.applyPosition( (mesh.minX+mesh.maxX)*.5,  (mesh.minY+mesh.maxY)*.5, (mesh.minZ+mesh.maxZ)*.5);					}									} else{															var index:int = 0;					var v:Array = [];										if(_unicuvs)						var uvs:Array = [];									for(i=0;i<loop;++i){						face = obj.faces[i];						va = new Vertex(face.v0.x, face.v0.y, face.v0.z);						vb = new Vertex(face.v1.x, face.v1.y, face.v1.z);						vc = new Vertex(face.v2.x, face.v2.y, face.v2.z);						v.push(va, vb, vc);												if(_unicuvs){							uva = new UV(face.uv0.u, face.uv0.v);							uvb = new UV(face.uv1.u, face.uv1.v);							uvc = new UV(face.uv2.u, face.uv2.v);														uvs.push(uva, uvb, uvc);						}											}					 					for(i=0;i<loop;++i){						face = obj.faces[i];						face.v0 = v[index];						face.v1 = v[index+1];						face.v2 = v[index+2];						if(_unicuvs){							face.uv0 = uvs[index];							face.uv1 = uvs[index+1];							face.uv2 = uvs[index+2];						}						index+=3;					}					v = null;					uvs = null;				}		}		 		/**		*  Class Explode corrects all the faces of an object3d with unic vertexes. <code>Explode</code>		* Each faces can then be moved independently without influence for the surrounding faces.		*		* @param	 unicUvs					[optional] Boolean. Defines if unicmeshes is false, if the faces receive unique uvs or not. Default = false;		* @param	 unicMeshes			[optional] Boolean. Defines if an isolated face becomes a unic Mesh objects or not. Default = false;		* @param	 recenter				[optional] Boolean. Defines if the meshes are recentered or not. unicMeshes must be true. Default = false;				*/		 		function Explode(unicUvs:Boolean = false, unicMeshes:Boolean = false, recenter:Boolean = false):void {			_unicmeshes = unicMeshes;			unicuvs = unicUvs;			_recenter = recenter;		}				/**		* Apply the explode code to a given object3D		* 		* @param	 object3d		Object3D. The target Object3d object.		*		* @return	 Object3D		if unicmeshes, returns an ObjectContainer3D with all the unic meshes in it, or the original object3d affected by the explode code.		*/		public function apply(object3d:Object3D):Object3D		{			if(_unicmeshes)				_container = new ObjectContainer3D();							parse(object3d);						if(_unicmeshes)				return _container;			else				return object3d;		}				/**		* Defines if an isolated face becomes a unic Mesh objects or not. Class default = false;		*/		public function set unicmeshes(b:Boolean):void		{			_unicmeshes = b;		}		public function get unicmeshes():Boolean		{			return _unicmeshes;		}				/**		* Defines if the uvs are reused or not		*/		public function set unicuvs(b:Boolean):void		{			_unicuvs = b;		}		public function get unicuvs():Boolean		{			return _unicuvs;		}				/**		* if unicmeshes is true, defines if the unic meshes are recentered or not. Default = false;		*/		public function set recenter(b:Boolean):void		{			_recenter = b;		}		public function get recenter():Boolean		{			return _recenter;		}		 	}}