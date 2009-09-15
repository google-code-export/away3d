package
{
	import away3dlite.materials.WireframeMaterial;
	import away3dlite.templates.ui.Keyboard3D;
	
	import flash.geom.Vector3D;
	
	import jiglib.physics.RigidBody;
	import jiglib.plugin.away3dlite.Away3DLiteMesh;
	import jiglib.templates.PhysicsTemplate;

	[SWF(backgroundColor="#666666", frameRate = "30", quality = "MEDIUM", width = "800", height = "600")]
	/**
	 * Example : Keyboard Control
	 * 
 	 * @see http://away3d.googlecode.com/svn/trunk/fp10/Away3DLite/src
	 * @see http://away3d.googlecode.com/svn/branches/JigLibLite/src
	 * 
	 * @author katopz
	 */
	public class ExKeyboardControl extends PhysicsTemplate
	{
		private var ball:RigidBody;

		override protected function build():void
		{
			//system
			title += " | Keyboard Control | Use Key Up, Down, Left, Right | ";
			
			camera.y = -1000;
			
			//event
			new Keyboard3D(stage);
			
			//decor
			for (var i:int = 0; i < 16; i++)
			{
				var box:RigidBody = physics.createCube(new WireframeMaterial(0xFFFFFF * Math.random()), 25, 25, 25);
				box.moveTo(new Vector3D(0, 500 + (100 * i + 100), 0));
			}
			
			for (i=0; i < 4; i++)
			{
				var color:uint = (i == 0) ? 0xff8888 : 0xeeee00;
				var sphere:RigidBody = physics.createSphere(new WireframeMaterial(), 25);
				sphere.mass = 5;
				sphere.moveTo(new Vector3D(-100, 500 + (100 * i + 100), -100));
			}
			
			//player
			ball = sphere;
		}

		override protected function onPreRender():void
		{
			//move
			var position:Vector3D = Keyboard3D.position.clone();
			position.scaleBy(20);
			
			ball.addWorldForce(position, ball.currentState.position);
			
			//run
			physics.step();

			//system
			camera.lookAt(Away3DLiteMesh(ground.skin).mesh.position, new Vector3D(0, -1, 0));
		}
	}
}