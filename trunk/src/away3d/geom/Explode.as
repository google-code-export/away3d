﻿package away3d.geom{		import away3d.core.base.Mesh;	import away3d.core.base.Vertex;	import away3d.core.base.Face;	import away3d.core.base.Object3D;	import away3d.containers.ObjectContainer3D;	import away3d.arcane;		use namespace arcane;		/**	 * Class Explode corrects all the faces of an object3d with unic vertexes<Explode></code>	 * Each faces can then be moved independently without influence for the surrounding faces. 	 */	public class Explode{		 		private function parse(object3d:Object3D):void		{			 			if(object3d is ObjectContainer3D){							var obj:ObjectContainer3D = (object3d as ObjectContainer3D);							for(var i:int =0;i<obj.children.length;++i){										if(obj.children[i] is ObjectContainer3D){						parse(obj.children[i]);					} else if(obj.children[i] is Mesh){						explode( obj.children[i]);					}				}							}else if(object3d is Mesh){				explode( object3d as Mesh);			}			 		}		 		private function explode(obj:Mesh):void		{				var face:Face;				var va: Vertex;				var vb: Vertex;				var vc :Vertex;				var i:int = 0;				var index:int = 0;				var v:Array = [];				var loop:int = obj.faces.length;								for(i=0;i<loop;++i){					face = obj.faces[i];					va = new Vertex(face.v0.x, face.v0.y, face.v0.z);					vb = new Vertex(face.v1.x, face.v1.y, face.v1.z);					vc = new Vertex(face.v2.x, face.v2.y, face.v2.z);					v.push(va, vb, vc);				}								obj.vertices = [];								for(i=0;i<loop;++i){					face = obj.faces[i];					face.v0 = null;					face.v1 = null;					face.v2 = null;					face.v0 = v[index];					face.v1 = v[index+1];					face.v2 = v[index+2];					obj.vertices.push(face.v0, face.v1, face.v2);					index+=3;				}				v = null;		}		 		/**		*  Class Explode corrects all the faces of an object3d with unic vertexes<Explode></code>		* Each faces can then be moved independently without influence for the surrounding faces. 		* 		* @param	 object3d		Object3D. The target Object3d object.		*/		 		 function Explode(object3d:Object3D):void		{			parse(object3d);		}					}}