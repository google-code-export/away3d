/*
Copyright (c) 2007 Danny Chapman 
http://www.rowlhouse.co.uk

This software is provided 'as-is', without any express or implied
warranty. In no event will the authors be held liable for any damages
arising from the use of this software.
Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions:
1. The origin of this software must not be misrepresented; you must not
claim that you wrote the original software. If you use this software
in a product, an acknowledgment in the product documentation would be
appreciated but is not required.
2. Altered source versions must be plainly marked as such, and must not be
misrepresented as being the original software.
3. This notice may not be removed or altered from any source
distribution.
*/

/**
* @author Muzer(muzerly@gmail.com)
* @link http://code.google.com/p/jiglibflash
*/

package jiglib.collision {

	import jiglib.cof.JConfig;
	import jiglib.geometry.*;
	import jiglib.math.*;
	import jiglib.physics.RigidBody;
	import jiglib.physics.MaterialProperties;
	
	public class CollDetectSpherePlane extends CollDetectFunctor {
		
		public function CollDetectSpherePlane() {
			Name = "SpherePlane";
			Type0 = "SPHERE";
			Type1 = "PLANE";
		}
		
		override public function CollDetect(info:CollDetectInfo, collArr:Array):void
		{
			var tempBody:RigidBody;
			if(info.body0.Type=="PLANE")
			{
				tempBody=info.body0;
				info.body0=info.body1;
				info.body1=tempBody;
			}
			
			var sphere:JSphere = info.body0 as JSphere;
			var plane:JPlane = info.body1 as JPlane;
			
			var dist:Number = plane.PointPlaneDistance(sphere.CurrentState.Position);
			
			if (dist > sphere.BoundingSphere + JConfig.collToll)
			{
				return;
			}
			
			var collPts:Array = new Array();
			var cpInfo:CollPointInfo;
			var depth:Number=sphere.Radius-dist;
			
			var worldPos:JNumber3D=JNumber3D.sub(sphere.CurrentState.Position,JNumber3D.multiply(plane.Normal,sphere.Radius));
			cpInfo=new CollPointInfo();
			cpInfo.R0=JNumber3D.sub(worldPos,sphere.CurrentState.Position);
			cpInfo.R1=JNumber3D.sub(worldPos,plane.CurrentState.Position);
			cpInfo.InitialPenetration=depth;
			collPts.push(cpInfo);
			
			var collInfo:CollisionInfo=new CollisionInfo();
			collInfo.ObjInfo=info;
			collInfo.DirToBody = plane.Normal;
			collInfo.PointInfo = collPts;
			var mat:MaterialProperties = new MaterialProperties();
			mat.Restitution = Math.sqrt(sphere.Material.Restitution * plane.Material.Restitution);
			mat.StaticFriction = Math.sqrt(sphere.Material.StaticFriction * plane.Material.StaticFriction);
			mat.DynamicFriction = Math.sqrt(sphere.Material.DynamicFriction * plane.Material.DynamicFriction);
			collInfo.Mat = mat;
			collArr.push(collInfo);
			info.body0.Collisions.push(collInfo);
			info.body1.Collisions.push(collInfo);
		}
		
	}
	
}
