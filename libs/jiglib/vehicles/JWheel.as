﻿/*
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

package jiglib.vehicles {
	import jiglib.collision.CollisionSystem;
	import jiglib.geometry.JSegment;
	import jiglib.math.*;
	import jiglib.physics.RigidBody;
	import jiglib.physics.PhysicsSystem;

	public class JWheel {
		
		private const noslipVel:Number = 0.5;
		private const slipVel:Number = 0.5;
		private const slipFactor:Number = 0.8;
		private const smallVel:Number = 8;
		
		private var _car:JCar;
		private var _pos:JNumber3D;
		private var _axisUp:JNumber3D;
		private var _spring:Number;
		private var _travel:Number;
		private var _inertia:Number;
		private var _radius:Number;
		private var _sideFriction:Number;
		private var _fwdFriction:Number;
		private var _damping:Number;
		private var _numRays:int;
		
		private var _angVel:Number;
		private var _steerAngle:Number;
		private var _torque:Number;
		private var _driveTorque:Number;
		private var _axisAngle:Number;
		private var _displacement:Number;
		private var _upSpeed:Number;
		
		private var _locked:Boolean;
		private var _lastDisplacement:Number;
		private var _lastOnFloor:Boolean;
		private var _angVelForGrip:Number;
		
		private var worldPos:JNumber3D;
		private var worldAxis:JNumber3D;
		private var wheelFwd:JNumber3D;
		private var wheelUp:JNumber3D;
		private var wheelLeft:JNumber3D;
		private var wheelRayEnd:JNumber3D;
		private var wheelRay:JSegment;
		private var groundUp:JNumber3D;
		private var groundLeft:JNumber3D;
		private var groundFwd:JNumber3D;
		private var wheelPointVel:JNumber3D;
		private var rimVel:JNumber3D;
		private var worldVel:JNumber3D;
		private var wheelCentreVel:JNumber3D;
		
		public function JWheel(car:JCar) {
			_car = car;
		}
		
		public function Setup(pos:JNumber3D, axisUp:JNumber3D,
		                      spring:Number=0, travel:Number=0, 
							  inertia:Number=0, radius:Number=0,
							  sideFriction:Number=0, fwdFriction:Number=0,
							  damping:Number=0, numRays:int=0):void
		{
			_pos = pos;
			_axisUp = axisUp;
			_spring = spring;
			_travel = travel;
			_inertia = inertia;
			_radius = radius;
			_sideFriction = sideFriction;
			_fwdFriction = fwdFriction;
			_damping = damping;
			_numRays = numRays;
			Reset();
		}
		
		public function AddTorque(torque:Number):void
		{
			_driveTorque += torque;
		}
		
		public function SetLock(lock:Boolean):void
		{
			_locked = lock;
		}
		
		public function SetSteerAngle(steer:Number):void
		{
			_steerAngle = steer;
		}
		public function GetSteerAngle():Number
		{
			return _steerAngle;
		}
		
		public function GetPos():JNumber3D
		{
			return _pos;
		}
		public function GetLocalAxisUp():JNumber3D
		{
			return _axisUp;
		}
		public function GetRadius():Number
		{
			return _radius;
		}
		public function GetDisplacement():Number
		{
			return _displacement;
		}
		public function GetAxisAngle():Number
		{
			return _axisAngle;
		}
		public function getRollAngle():Number
		{
			return 0.1 * _angVel * 180 / Math.PI;
		}
		public function GetOnFloor():Boolean
		{
			return _lastOnFloor;
		}
		
		public function AddForcesToCar(dt:Number):Boolean
		{
			var force:JNumber3D = new JNumber3D();
			_lastDisplacement = _displacement;
			_displacement = 0;
			 
			var carBody:JChassis = _car.Chassis;
			worldPos = _pos.clone();
			JMatrix3D.multiplyVector(carBody.CurrentState.Orientation, worldPos);
			worldPos = JNumber3D.add(carBody.CurrentState.Position, worldPos);
			worldAxis = _axisUp.clone();
			JMatrix3D.multiplyVector(carBody.CurrentState.Orientation, worldAxis);
			 
			wheelFwd = carBody.CurrentState.Orientation.getCols()[2].clone();
			JMatrix3D.multiplyVector(JMatrix3D.rotationMatrix(worldAxis.x, worldAxis.y, worldAxis.z, _steerAngle * Math.PI / 180), wheelFwd);
			wheelUp = worldAxis;
			wheelLeft = JNumber3D.cross(wheelFwd, wheelUp);
			wheelLeft.normalize();
			 
			var rayLen:Number = 2 * _radius + _travel;
			wheelRayEnd = JNumber3D.sub(worldPos, JNumber3D.multiply(worldAxis, _radius));
			wheelRay = new JSegment(JNumber3D.add(wheelRayEnd, JNumber3D.multiply(worldAxis, rayLen)), JNumber3D.multiply(worldAxis, -rayLen));
			 
			var collSystem:CollisionSystem = PhysicsSystem.getInstance().GetCollisionSystem();
			 
			var maxNumRays:int = 10;
			var numRays:int = Math.min(_numRays, maxNumRays);
			 
			var objArr:Array = new Array();
			var segments:Array = new Array();
			
			var deltaFwd:Number = (2 * _radius) / (numRays + 1);
			var deltaFwdStart:Number = deltaFwd;
			
			_lastOnFloor = false;
			
			var distFwd:Number;
			var yOffset:Number;
			var bestIRay:int = 0;
			var iRay:int = 0;
			for (iRay = 0; iRay < numRays; iRay++)
			{
				objArr[iRay] = new Object();
				distFwd = (deltaFwdStart + iRay * deltaFwd) - _radius;
				yOffset = _radius * (1 - Math.cos( 90 * (distFwd / _radius) * Math.PI / 180));
				segments[iRay] = wheelRay.clone();
				segments[iRay].Origin = JNumber3D.add(segments[iRay].Origin, JNumber3D.add(JNumber3D.multiply(wheelFwd, distFwd), JNumber3D.multiply(wheelUp, yOffset)));
				if (collSystem.SegmentIntersect(objArr[iRay], segments[iRay], carBody))
				{
					_lastOnFloor = true;
					if (objArr[iRay].fracOut < objArr[bestIRay].fracOut)
					{
						bestIRay = iRay;
					}
				}
			}
			 
			if (!_lastOnFloor)
			{
				return false;
			}
			
			var frac:Number=objArr[bestIRay].fracOut;
			var groundPos:JNumber3D = objArr[bestIRay].posOut;
			var otherBody:RigidBody = objArr[bestIRay].bodyOut;
			
			var groundNormal:JNumber3D = worldAxis.clone();
			if (numRays > 1)
			{
				for (iRay = 0; iRay < numRays; iRay++)
				{
					if (objArr[iRay].fracOut <= 1)
					{
						groundNormal = JNumber3D.add(groundNormal, JNumber3D.multiply(JNumber3D.sub(worldPos, segments[iRay].GetEnd()), 1 - objArr[iRay].fracOut));
					}
				}
				groundNormal.normalize();
			}
			else
			{
				groundNormal = objArr[bestIRay].normalOut;
			}
			
			_displacement = rayLen * (1 - frac);
			if (_displacement < 0)
			{
				_displacement = 0;
			}
			else if (_displacement > _travel) {
				_displacement = _travel;
			}
			
			var displacementForceMag:Number = _displacement * _spring;
			displacementForceMag *= JNumber3D.dot(groundNormal, worldAxis);
			
			var dampingForceMag:Number = _upSpeed * _damping;
			var totalForceMag:Number = displacementForceMag + dampingForceMag;
			if (totalForceMag < 0)
			{
				totalForceMag = 0;
			}
			var extraForce:JNumber3D = JNumber3D.multiply(worldAxis, totalForceMag);
			force = JNumber3D.add(force, extraForce);
			
			groundUp = groundNormal;
			groundLeft = JNumber3D.cross(wheelFwd, groundNormal);
			groundLeft.normalize();
			groundFwd = JNumber3D.cross(groundUp, groundLeft);
			
			var tempv:JNumber3D = _pos.clone();
			JMatrix3D.multiplyVector(carBody.CurrentState.Orientation, tempv);
			wheelPointVel = JNumber3D.add(carBody.CurrentState.LinVelocity, JNumber3D.cross(tempv, carBody.CurrentState.RotVelocity));
			
			rimVel = JNumber3D.multiply(JNumber3D.cross(JNumber3D.sub(groundPos, worldPos), wheelLeft), _angVel);
			wheelPointVel = JNumber3D.add(wheelPointVel, rimVel);
			
			if (otherBody.Getmovable())
			{
				worldVel = JNumber3D.add(otherBody.CurrentState.LinVelocity, JNumber3D.cross(JNumber3D.sub(groundPos, otherBody.CurrentState.Position), otherBody.CurrentState.RotVelocity));
				wheelPointVel = JNumber3D.sub(wheelPointVel, worldVel);
			}
			
			var friction:Number = _sideFriction;
			var sideVel:Number = JNumber3D.dot(wheelPointVel, groundLeft);
			if ((sideVel >  slipVel) || (sideVel < -slipVel))
			{
				friction *= slipFactor;
			}else if ((sideVel >  noslipVel) || (sideVel < -noslipVel)) {
				friction *= (1 -  (1 - slipFactor) * (Math.abs(sideVel) - noslipVel) / (slipVel - noslipVel));
			}
			if (sideVel < 0)
			{
				friction *= -1;
			}
			if (Math.abs(sideVel) < smallVel)
			{
				friction *= Math.abs(sideVel) / smallVel;
			}
			
			var sideForce:Number = -friction * totalForceMag;
			extraForce = JNumber3D.multiply(groundLeft, sideForce);
			force = JNumber3D.add(force, extraForce);
			
			friction = _fwdFriction;
			var fwdVel:Number = JNumber3D.dot(wheelPointVel, groundFwd);
			if ( (fwdVel >  slipVel) || (fwdVel < -slipVel) )
			{
				friction *= slipFactor;
			}
			else if ( (fwdVel >  noslipVel) || (fwdVel < -noslipVel) )
			{
				friction *= (1 -  (1 - slipFactor) * (Math.abs(fwdVel) - noslipVel) / (slipVel - noslipVel));
			}
			if (fwdVel < 0)
			{
				friction *= -1;
			}
			if (Math.abs(fwdVel) < smallVel)
			{
				friction *= (Math.abs(fwdVel) / smallVel);
			}
			var fwdForce:Number = -friction * totalForceMag;
			extraForce = JNumber3D.multiply(groundFwd, fwdForce);
			force = JNumber3D.add(force, extraForce);
			
			wheelCentreVel = JNumber3D.add(carBody.CurrentState.LinVelocity, JNumber3D.cross(tempv, carBody.CurrentState.RotVelocity));
			_angVelForGrip = JNumber3D.dot(wheelCentreVel, groundFwd) / _radius;
			_torque += ( -fwdForce * _radius);
			
			carBody.AddWorldForce(force, groundPos);
			if (otherBody.Getmovable())
			{
				var maxOtherBodyAcc:Number = 500;
				var maxOtherBodyForce:Number = maxOtherBodyAcc * otherBody.Mass;
				if (force.modulo2 > maxOtherBodyForce * maxOtherBodyForce)
				{
					force = JNumber3D.multiply(force, maxOtherBodyForce / force.modulo);
				}
				otherBody.AddWorldForce(JNumber3D.multiply(force, -1), groundPos);
			}
			return true;
		}
		
		public function Update(dt:Number):void
		{
			if (dt <= 0)
			{
				return;
			}
			var origAngVel:Number = _angVel;
			_upSpeed = (_displacement - _lastDisplacement) / Math.max(dt, JNumber3D.NUM_TINY);
			
			if (_locked)
			{
				_angVel = 0;
				_torque = 0;
			}
			else
			{
				_angVel += (_torque * dt / _inertia);
				_torque = 0;
			
			
				if (((origAngVel > _angVelForGrip) && (_angVel < _angVelForGrip)) ||
					((origAngVel < _angVelForGrip) && (_angVel > _angVelForGrip)))
					{
						_angVel = _angVelForGrip;
					}
			 
				_angVel += _driveTorque * dt / _inertia;
				_driveTorque = 0;
			 
				if(_angVel<-100)
				{
					_angVel = -100;
				}
				else if(_angVel>100)
				{
					_angVel = 100;
				}
				_angVel *= 0.99;
				_axisAngle += (_angVel * dt * 180 / Math.PI);
			}
			
		}
		
		
		public function Reset():void
		{
			_angVel = 0;
			_steerAngle = 0;
			_torque = 0;
			_driveTorque = 0;
			_axisAngle = 0;
			_displacement = 0;
			_upSpeed = 0;
			_locked = false;
			_lastDisplacement = 0;
			_lastOnFloor = false;
			_angVelForGrip = 0;
		}
		
	}
	
}
