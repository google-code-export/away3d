package 
{
    import away3d.cameras.*;
    import away3d.core.*;
    import away3d.core.block.*;
    import away3d.core.draw.*;
    import away3d.core.material.*;
    import away3d.core.math.*;
    import away3d.core.mesh.*;
    import away3d.core.render.*;
    import away3d.core.scene.*;
    import away3d.core.sprite.*;
    import away3d.core.utils.*;
    import away3d.loaders.*;
    import away3d.objects.*;
    import away3d.test.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.utils.*;
    
    import mx.core.BitmapAsset;
    
    //[SWF(backgroundColor="#222266", frameRate="60", width="800", height="600")]
    [SWF(backgroundColor="#222266", frameRate="60")]
    public class EngineTest extends BaseDemo
    {
        public function EngineTest()
        {
            Debug.warningsAsErrors = true;

            super("Away3D engine test", 5*5*5);
            
            addSlide("Primitives", 
"Basic primitives to start playing with", 
            new Scene3D(new Primitives), 
            Renderer.CORRECT_Z_ORDER);

            addSlide("Transforms", 
"Affine transforms for object and groups",
            new Scene3D(new Transforms), 
            Renderer.CORRECT_Z_ORDER);

            addSlide("Texturing", 
"Bitmap texturing", 
            new Scene3D(new Texturing), 
            Renderer.CORRECT_Z_ORDER);
            
            addSlide("Texture Tiling", 
"Tiling bitmap textures", 
            new Scene3D(new Tiling), 
            Renderer.CORRECT_Z_ORDER);
            
            addSlide("Texture Projecting", 
"Projecting bitmap textures", 
            new Scene3D(new Projecting), 
            Renderer.CORRECT_Z_ORDER);
            
            addSlide("Smooth texturing", 
"Smooth bitmap texturing", 
            new Scene3D(new SmoothTexturing), 
            Renderer.CORRECT_Z_ORDER);

            addSlide("Wire primitives", 
"First class support for segments", 
            new Scene3D(new WirePrimitives), 
            Renderer.CORRECT_Z_ORDER);

            addSlide("Movie texturing", 
"Any Sprite or MovieClip can be used as a material", 
            new Scene3D(new MovieTexturing), 
            Renderer.CORRECT_Z_ORDER);

            addSlide("MovieClipSprite", 
"Insert a DisplayObject directly inline with z-sorted triangles", 
            new Scene3D(new MovieSprite), 
            Renderer.CORRECT_Z_ORDER);
            
            addSlide("ownCanvas and filters", 
"render objects in separate sprites. Can apply filters at an object level", 
            new Scene3D(new CanvasSprite), 
            Renderer.CORRECT_Z_ORDER);
                               
            addSlide("Occlusion culling", 
"Unnecessary triangles elimination",
            new Scene3D(new Blockers), 
            Renderer.BASIC);
            
            addSlide("Mouse events", 
"Click on the objects to change their color", 
            new Scene3D(new MouseEvents), 
            Renderer.CORRECT_Z_ORDER);

            addSlide("Drawing", 
"Click on the plane to start drawing", 
            new Scene3D(new Drawing), 
            Renderer.CORRECT_Z_ORDER);

            addSlide("Meshes", 
"", 
            new Scene3D(new AseMesh), 
            Renderer.BASIC);

            addSlide("Sprites", 
"Directional sprites support", 
            new Scene3D(new Sprites), 
            Renderer.CORRECT_Z_ORDER);

            addSlide("Level of details", 
"Reducing triangle count for distant objects", 
            new Scene3D(new LODs), 
            Renderer.BASIC);

            addSlide("Perspective texturing", 
"Correct perspective transform for textures",
            new Scene3D(new PerspectiveTexturing), 
            Renderer.BASIC);
/*
            addSlide("Skybox", 
"",
            new Scene3D(new SimpleSkybox), 
            new BasicRenderer());
*/
            addSlide("Skybox",
"Multiple panorama options",
            new Scene3D(new SmoothSkybox), 
            Renderer.BASIC);

            addSlide("Z ordering", 
"Correct z-ordering for triangles",
            new Scene3D(new ZOrdering), 
            Renderer.CORRECT_Z_ORDER);

            addSlide("Intersecting objects", 
"Ability to render intersecting objects",
            new Scene3D(new IntersectingObjects, new IntersectingObjects2), 
            Renderer.INTERSECTING_OBJECTS);

            addSlide("Color lighting", 
"Phong model color lighting",
            new Scene3D(new ColorLighting), 
            Renderer.BASIC);

            addSlide("White lighting", 
"White lighting for bitmap textures",
            new Scene3D(new WhiteLighting), 
            Renderer.BASIC);

            addSlide("Mesh morphing", 
"Linear mesh morphing",
            new Scene3D(new Morphing), 
            Renderer.BASIC);

            addSlide("Texture projection", 
"Projecting textures on objects", 
            new Scene3D(new FunnyCube), 
            Renderer.CORRECT_Z_ORDER);

        }
    }
}

import flash.display.*;
import flash.events.*;
import flash.text.*;
import flash.utils.*;
import flash.geom.*;

import mx.core.BitmapAsset;

import away3d.cameras.*;
import away3d.objects.*;
import away3d.loaders.*;
import away3d.test.*;
import away3d.core.*;
import away3d.core.block.*;
import away3d.core.draw.*;
import away3d.core.material.*;
import away3d.core.math.*;
import away3d.core.mesh.*;
import away3d.core.render.*;
import away3d.core.scene.*;
import away3d.core.sprite.*;
import away3d.core.utils.*;
import flash.filters.GlowFilter;
import flash.filters.BlurFilter;

class Asset
{
	
    [Embed(source="images/circle.dae",mimeType="application/octet-stream")]
    public static var CircleModel:Class;

    [Embed(source="images/tri.dae",mimeType="application/octet-stream")]
    public static var TriModel:Class;

    [Embed(source="images/square.dae",mimeType="application/octet-stream")]
    public static var SquareModel:Class;

    //[Embed(source="images/temple.dae",mimeType="application/octet-stream")]
    public static var TempleModel:Class;
    
    [Embed(source="images/seaturtle.ase",mimeType="application/octet-stream")]
    public static var SeaTurtleModel:Class;

    [Embed(source="images/seaturtle.jpg")]
    public static var SeaTurtleImage:Class;

    [Embed(source="images/mandelbrot.jpg")]
    public static var ManderlbrotImage:Class;

    public static function get mandelbrot():BitmapData
    {
        return Cast.bitmap(ManderlbrotImage);
    }

    [Embed(source="images/grad.jpg")]
    public static var GradImage:Class;

    public static function get grad():BitmapData
    {
        return Cast.bitmap(GradImage);
    }

    [Embed(source="images/ls_front.png")]
    public static var LostSoulFrontImage:Class;
    [Embed(source="images/ls_leftfront.png")]
    public static var LostSoulLeftFrontImage:Class;
    [Embed(source="images/ls_left.png")]
    public static var LostSoulLeftImage:Class;
    [Embed(source="images/ls_leftback.png")]
    public static var LostSoulLeftBackImage:Class;
    [Embed(source="images/ls_back.png")]
    public static var LostSoulBackImage:Class;

    public static function getLostSoul(dir:String):BitmapData
    {
        var asset:BitmapAsset;
        switch (dir)
        {
            case "front":      asset = new LostSoulFrontImage; break;
            case "leftfront":  asset = new LostSoulLeftFrontImage; break;
            case "left":       asset = new LostSoulLeftImage; break;
            case "leftback":   asset = new LostSoulLeftBackImage; break;
            case "back":       asset = new LostSoulBackImage; break;
            default: throw new Error("Unknown direction");
        }
        return asset.bitmapData;
    }

    public static function flipX(source:BitmapData):BitmapData
    {
        var bitmap:BitmapData = new BitmapData(source.width, source.height);
        for (var i:int = 0; i < bitmap.width; i++)
            for (var j:int = 0; j < bitmap.height; j++)
                bitmap.setPixel32(i, j, source.getPixel32(source.width-i-1, j));
        return bitmap;
    }

    [Embed(source="images/foil-dots.png")]
    public static var FoilDotsImage:Class;

    public static function get foilDots():BitmapData
    {
        return Cast.bitmap(FoilDotsImage);
    }

    [Embed(source="images/foil-white.png")]
    public static var FoilWhiteImage:Class;

    public static function get foilWhite():BitmapData
    {
        return Cast.bitmap(FoilWhiteImage);
    }

    [Embed(source="images/foil-color.png")]
    public static var FoilColorImage:Class;

    public static function get foilColor():BitmapData
    {
        return Cast.bitmap(FoilColorImage);
    }

    //[Embed(source="images/marble.jpg")]
    public static var MarbleImage:Class;

    public static function get marble():BitmapData
    {
        return Cast.bitmap(MarbleImage);
    }

    [Embed(source="images/httt.jpg")]
    public static var HttTImage:Class;
    public static function get httt():BitmapData
    {
        return Cast.bitmap(HttTImage);
    }

    [Embed(source="images/target.png")]
    public static var TargetImage:Class;
    public static function get target():BitmapData
    {
        return Cast.bitmap(TargetImage);
    }
    
    [Embed(source="images/blue.jpg")]
    public static var BlueImage:Class;

    public static function get blue():BitmapData
    {
        return Cast.bitmap(BlueImage);
    }

    [Embed(source="images/green.jpg")]
    public static var GreenImage:Class;

    public static function get green():BitmapData
    {
        return Cast.bitmap(GreenImage);
    }
    
	[Embed(source="images/Smiley-face.gif")]
	public static var SmileyImage:Class;
	
    public static function get smiley():BitmapData
    {
        return Cast.bitmap(SmileyImage);
    }
    
    [Embed(source="images/red.jpg")]
    public static var RedImage:Class;

    public static function get red():BitmapData
    {
        return Cast.bitmap(RedImage);
    }

    [Embed(source="images/yellow.jpg")]
    public static var YellowImage:Class;

    public static function get yellow():BitmapData
    {
        return Cast.bitmap(YellowImage);
    }

    //[Embed(source="images/morning-back.jpg")]
    public static var MorningBackImage:Class;

    public static function get morningBack():BitmapData
    {
        return Cast.bitmap(MorningBackImage);
    }

    //[Embed(source="images/morning-down.jpg")]
    public static var MorningDownImage:Class;

    public static function get morningDown():BitmapData
    {
        return Cast.bitmap(MorningDownImage);
    }

    //[Embed(source="images/morning-front.jpg")]
    public static var MorningFrontImage:Class;

    public static function get morningFront():BitmapData
    {
        return Cast.bitmap(MorningFrontImage);
    }

    //[Embed(source="images/morning-left.jpg")]
    public static var MorningLeftImage:Class;

    public static function get morningLeft():BitmapData
    {
        return Cast.bitmap(MorningLeftImage);
    }

    //[Embed(source="images/morning-right.jpg")]
    public static var MorningRightImage:Class;

    public static function get morningRight():BitmapData
    {
        return Cast.bitmap(MorningRightImage);
    }

    //[Embed(source="images/morning-up.jpg")]
    public static var MorningUpImage:Class;

    public static function get morningUp():BitmapData
    {
        return Cast.bitmap(MorningUpImage);
    }

    [Embed(source="images/peterskybox2.jpg")]
    public static var DarkSkyImage:Class;

    public static function get darkSky():BitmapData
    {
        return Cast.bitmap(DarkSkyImage);
    }

    [Embed(source="images/sand.jpg")]
    public static var SandImage:Class;

    public static function get sand():BitmapData
    {
        return Cast.bitmap(SandImage);
    }
    
    [Embed(source="images/trackedge.jpg")]
    public static var TrackedgeImage:Class;

    public static function get trackedge():BitmapData
    {
        return Cast.bitmap(TrackedgeImage);
    }
        
    public static function get black1x1():BitmapData
    {
        return fill(0x000000, 1, 1);
    }

    public static function get white1x1():BitmapData
    {
        return fill(0xFFFFFF, 1, 1);
    }

    public static function color1x1(color:int):BitmapData
    {
        return fill(color, 1, 1);
    }

    public static function fill(color:int, width:int, height:int):BitmapData
    {
        var b:BitmapData = new BitmapData(width, height, false);
        for (var i:int = 0; i < width; i++)
            for (var j:int = 0; j < height; j++)
                b.setPixel(i, j, color);
        return b;
    }

    public static function get bwwb():BitmapData
    {
        var b:BitmapData = new BitmapData(2, 2, false);
        b.setPixel(0, 0, 0xFFFFFF);
        b.setPixel(1, 1, 0xFFFFFF);
        b.setPixel(0, 1, 0);
        b.setPixel(1, 0, 0);
        return b;
    }
}

class AseMesh extends ObjectContainer3D
{
    public function AseMesh()
    {
        var turtle:Mesh = Ase.parse(Asset.SeaTurtleModel, {material:new BitmapMaterial(Cast.bitmap(Asset.SeaTurtleImage))});
        //turtle.y = -40;

        super(turtle);
    }
    
}

class LostSoul extends Sprite2DDir
{
    public var role:String;
    public var nextthink:int;
    public var lastmove:int;

    public function LostSoul(init:Object = null)
    {
        super(init);

        add( 0  , 0,-1  , Asset.getLostSoul("front"));
        add(-0.7, 0,-0.7, Asset.getLostSoul("leftfront"));
        add(-1  , 0, 0  , Asset.getLostSoul("left"));
        add(-0.7, 0, 0.7, Asset.getLostSoul("leftback"));
        add( 0  , 0, 1  , Asset.getLostSoul("back"));
        add( 0.7, 0, 0.7, Asset.flipX(Asset.getLostSoul("leftback")));
        add( 1  , 0, 0  , Asset.flipX(Asset.getLostSoul("left")));
        add( 0.7, 0,-0.7, Asset.flipX(Asset.getLostSoul("leftfront")));
    }       
            
    public override function tick(time:int):void
    {
        if ((role == null) || (nextthink < time))
        {
            role = (["stop", "right", "left", "forward"])[int(Math.random()*4)];
            if ((Math.abs(x) > 300) || (Math.abs(z) > 300))
                role = "right";
                //role = (["right", "left"])[int(Math.random()*2)];
            nextthink = time + Math.random()*3000;
        }

        var delta:Number = (lastmove - time)/1000;
        switch (role)
        {
            case "stop":    rotationY += delta*(Math.random()*20-10); break;
            case "right":   rotationY += delta*Math.random()*10; moveForward(delta*20); break;
            case "left":    rotationY -= delta*Math.random()*10; moveForward(delta*20); break;
            case "forward": moveForward(delta*60) break;
        }
        lastmove = time;

        if (x > 500)
            x = 500;
        if (x < -500)
            x = -500;
        if (z > 500)
            z = 500;
        if (z < -500)
            z = -500;
    }
}

class Sprites extends ObjectContainer3D
{
    private var plane:Plane;

    public function Sprites()
    {
        plane = new Plane({material:new BitmapMaterial(Asset.yellow, {precision:1.5}), y:-100 , width:1000, height:1000});

        super(plane);

        addChild(new LostSoul({x:-300, z:-300, rotationY:240}));
        addChild(new LostSoul({x:   0, z:-300, rotationY:120}));
        addChild(new LostSoul({x: 300, z:-300, rotationY:0}));
        addChild(new LostSoul({x:-300, z:   0, rotationY:280}));
        addChild(new LostSoul({x:   0, z:   0, rotationY:80}));
        addChild(new LostSoul({x: 300, z:   0, rotationY:200}));
        addChild(new LostSoul({x:-300, z: 300, rotationY:320}));
        addChild(new LostSoul({x:   0, z: 300, rotationY:160}));
        addChild(new LostSoul({x: 300, z: 300, rotationY:40}));
    }
}

class AutoLODSphere extends ObjectContainer3D
{
    public function AutoLODSphere(color:int, init:Object = null)
    {
        var sphere0:Sphere = new Sphere({material:new WireColorMaterial(color), radius:150, segmentsW: 4, segmentsH:3 });
        var sphere1:Sphere = new Sphere({material:new WireColorMaterial(color), radius:150, segmentsW: 6, segmentsH:4 });
        var sphere2:Sphere = new Sphere({material:new WireColorMaterial(color), radius:150, segmentsW: 8, segmentsH:6 });
        var sphere3:Sphere = new Sphere({material:new WireColorMaterial(color), radius:150, segmentsW:10, segmentsH:8 });
        var sphere4:Sphere = new Sphere({material:new WireColorMaterial(color), radius:150, segmentsW:12, segmentsH:9 });
        var sphere5:Sphere = new Sphere({material:new WireColorMaterial(color), radius:150, segmentsW:14, segmentsH:10});
        var sphere6:Sphere = new Sphere({material:new WireColorMaterial(color), radius:150, segmentsW:16, segmentsH:12});
                                                                                   
        super(init,                                                                
            new LODObject({minp:0, maxp:0.1}, sphere0), 
            new LODObject({minp:0.1, maxp:0.3}, sphere1), 
            new LODObject({minp:0.3, maxp:0.5}, sphere2), 
            new LODObject({minp:0.5, maxp:1}, sphere3), 
            new LODObject({minp:1, maxp:2}, sphere4), 
            new LODObject({minp:2, maxp:3}, sphere5), 
            new LODObject({minp:3, maxp:10}, sphere6));
    }
}

class LODs extends ObjectContainer3D
{
    private var plane:Plane;

    public function LODs()
    {
        plane = new Plane({material:new BitmapMaterial(Asset.green, {precision:1.5}), y:-200 , width:1000, height:1000});

        super(plane, 
            new AutoLODSphere(0xFF0000, {x: 350, y:160, z: 350}), 
            new AutoLODSphere(0xFFFF00, {x: 350, y:160, z:-350}), 
            new AutoLODSphere(0x00FF00, {x:-350, y:160, z:-350}), 
            new AutoLODSphere(0x0000FF, {x:-350, y:160, z: 350}));
    }
}

class MovieSprite extends ObjectContainer3D
{
	protected var torus:Torus;
	protected var movieClip:MovieClip;
	protected var movieClipSprite:MovieClipSprite;
	protected var count:int = 0;
	
	public function MovieSprite()
    {
    	movieClip = new MovieClip();
    	
    	movieClipSprite = new MovieClipSprite(movieClip);
    	torus = new Torus({material:new WireColorMaterial(0x00FF00), x:0, y:0, z:0, radius:400, tube:100, segmentsR:8, segmentsT:6});
    	super(torus, movieClipSprite);
    }
    public override function tick(time:int):void
    {
    	var graphics:Graphics = movieClip.graphics;
    	if (!count) {
    		graphics.clear();
    		graphics.beginFill(0xFFFFFF*Math.random());
    		graphics.drawRect(0, 0, 80, 80);
    	}
    	count++;
    	if (count > 100)
    		count = 0;
        graphics.beginFill(0xFFFFFF*Math.random());
        graphics.drawCircle(20+40*Math.random(), 20+40*Math.random(), 20);
    	//torus.rotationY = time / 20;
    }
}


class CanvasSprite extends ObjectContainer3D
{
	protected var torus:Torus;
	protected var sphere:Sphere;
	protected var sphere1:Sphere;
	protected var sphere2:Sphere;
	protected var sphere3:Sphere;
	protected var sphere4:Sphere;
	
	public function CanvasSprite()
    {
    	
    	sphere = new Sphere({ownCanvas:true, filters:[new GlowFilter(0xFFFFFF, 1, 50, 50)], material:new WireColorMaterial(0xFF0000), x: 0, y:0, z: 0, radius:150, segmentsW:12, segmentsH:9});
    	sphere1 = new Sphere({ownCanvas:true, filters:[new GlowFilter(0xFFFF00, 1, 50, 50)], material:new WireColorMaterial(0xFF00FF), x: 200, y:0, z: 0, radius:20, segmentsW:4, segmentsH:3});
    	sphere2 = new Sphere({ownCanvas:true, filters:[new GlowFilter(0xFFFF00, 1, 50, 50)], material:new WireColorMaterial(0xFF00FF), x: -200, y:0, z: 0, radius:20, segmentsW:4, segmentsH:3});
    	sphere3 = new Sphere({ownCanvas:true, filters:[new GlowFilter(0xFFFF00, 1, 50, 50)], material:new WireColorMaterial(0xFF00FF), x: 0, y:0, z: 200, radius:20, segmentsW:4, segmentsH:3});
    	sphere4 = new Sphere({ownCanvas:true, filters:[new GlowFilter(0xFFFF00, 1, 50, 50)], material:new WireColorMaterial(0xFF00FF), x: 0, y:0, z: -200, radius:20, segmentsW:4, segmentsH:3});
    	torus = new Torus({material:new WireColorMaterial(0x00FF00), x:0, y:0, z:0, radius:400, tube:100, segmentsR:8, segmentsT:6});
    	ownCanvas = true;
    	super(torus, sphere, sphere1, sphere2, sphere3, sphere4);
    	filters = [new BlurFilter()];
    }
}

class Primitives extends ObjectContainer3D
{
    protected var sphere:Sphere;
    protected var plane:Plane;
    protected var cube:Cube;
    protected var torus:Torus;
                       
    public function Primitives()
    {
        plane = new Plane({material:new WireColorMaterial(0xFFFF00), y:-20, width:1000, height:1000, bothsides:true});
        sphere = new Sphere({material:new WireColorMaterial(0xFF0000), x: 300, y:160, z: 300, radius:150, segmentsW:12, segmentsH:9});
        cube = new Cube({material:new WireColorMaterial(0x0000FF), x: 300, y:160, z: -80, width:200, height:200, depth:200});
        torus = new Torus({pushfront:true, outline:new WireframeMaterial(0xFFFFFF, {width:5}), material:new WireColorMaterial(0x00FF00), x:-250, y:160, z:-250, radius:150, tube:60, segmentsR:8, segmentsT:6});

        super(sphere, plane, cube, torus);
    }
    
}

class Transforms extends Primitives
{
	public var cubeScaleX:Number = 0;
	public var cubeScaleY:Number = 0;
    public override function tick(time:int):void
    {
    	var newScaleX:Number = 0.5 * Math.sin(time / 200);
    	var newScaleY:Number = -0.5 * Math.sin(time / 200);
        cube.scaleX(1 + newScaleX - cubeScaleX);
        cube.scaleY(1 + newScaleY - cubeScaleY);
        cubeScaleX = newScaleX;
        cubeScaleY = newScaleY;
        sphere.rotationY = Math.tan(time / 3000)*90;
        torus.rotationX = time / 20;
        torus.rotationY = time / 30;
        torus.rotationZ = time / 40;
    }
}

class Texturing extends Primitives
{
    public function Texturing()
    {
        plane.material = new BitmapMaterial(Asset.yellow, {precision:1.6});
        sphere.material = new BitmapMaterial(Asset.red, {precision:1.6});
        cube.material = new BitmapMaterial(Asset.blue, {precision:1.6});
        torus.material = new BitmapMaterial(Asset.green, {precision:1.6});
    }
    
}

class Tiling extends Primitives
{
    public function Tiling()
    {
    	var t:Matrix = new Matrix();
    	t.rotate(Math.PI/4);
    	t.translate(100, 100);
    	t.scale(0.2, 0.2);
        plane.material = new BitmapMaterial(Asset.yellow, {precision:1.6, transform:t, repeat:true});
        sphere.material = new BitmapMaterial(Asset.red, {precision:1.6});
        cube.material = new BitmapMaterial(Asset.blue, {precision:1.6});
        torus.material = new BitmapMaterial(Asset.green, {precision:1.6});
    }
    
}


class Projecting extends Primitives
{
	public var projectedMaterial:BitmapMaterial;
	public var projectedTransform:Matrix;
	public var projectionVector:Number3D;
    public function Projecting()
    {
    	var t:Matrix = new Matrix();
    	t.rotate(Math.PI/4);
    	t.translate(100, 100);
    	t.scale(0.2, 0.2);
        plane.material = new BitmapMaterial(Asset.yellow, {precision:1.6, transform:t, repeat:true});
        projectedTransform = new Matrix();
        projectedTransform.translate(-64, -64);
        projectionVector = new Number3D(1, 1, 1);
        projectedMaterial = new BitmapMaterial(Asset.smiley, {projectionVector:projectionVector, transform:projectedTransform});
        
        sphere.material = new BitmapMaterialContainer(400, 400, {materials:[
        				new BitmapMaterial(Asset.red),
        				projectedMaterial
        				]});
        cube.material = new BitmapMaterial(Asset.blue, {precision:1.6});
        torus.material = new BitmapMaterial(Asset.green, {precision:1.6});
    }
    
    public override function tick(time:int):void
    {
    	projectedTransform = new Matrix();
    	projectedTransform.translate(-64, -64);
    	//projectedTransform.scale((Math.abs(Math.sin(time/2000))+1), (Math.abs(Math.cos(time/2000))+1));
    	projectedTransform.rotate(time/1000);
    	projectionVector = new Number3D(1*(Math.sin(time/500)), 1, 1*(Math.cos(time/500)));
		projectedMaterial.transform = projectedTransform;
		projectedMaterial.projectionVector = projectionVector;
    }
}

class SmoothTexturing extends Primitives
{
    public function SmoothTexturing()
    {
        plane.material = new BitmapMaterial(Asset.yellow, {precision:1.5, smooth:true});
        sphere.material = new BitmapMaterial(Asset.red, {precision:1.5, smooth:true});
        cube.material = new BitmapMaterial(Asset.blue, {precision:1.5, smooth:true});
        torus.material = new BitmapMaterial(Asset.green, {precision:1.5, smooth:true});
    }
}

class MovieTexturing extends Primitives
{
    public var movie:MovieClip;
    public function MovieTexturing()
    {
        movie = new MovieClip();
        var graphics:Graphics = movie.graphics;
        graphics.beginFill(0xFFCC00);
        graphics.drawCircle(40, 40, 40);

        cube.material = new MovieMaterial(movie, {transparent:true});
    }
    
    public override function tick(time:int):void
    {
        var graphics:Graphics = movie.graphics;
        graphics.beginFill(0xFFFFFF*Math.random());
        graphics.drawCircle(20+40*Math.random(), 20+40*Math.random(), 20);
    }
}

class WirePrimitives extends ObjectContainer3D
{
    private var sphere:WireSphere;
    private var plane:WirePlane;
    private var gridplane:GridPlane;
    private var cube:WireCube;
    private var torus:WireTorus;
                       
    public function WirePrimitives()
    {
        plane = new WirePlane({material:new WireframeMaterial(0xFFFF00), y:-70, width:1000, height:1000, segments:10});
        sphere = new WireSphere({material:new WireframeMaterial(0xFF0000), x:300, y:160, z:300, radius:150, segmentsW:12, segmentsH:9});
        cube = new WireCube({material:new WireframeMaterial(0x0000FF), x:300, y:160, z:-80, width:200, height:200, depth:200});
        gridplane = new GridPlane({material:new WireframeMaterial(0xFFFFFF), y:-170, width:1000, height:1000, segmentsW:10});
        torus = new WireTorus({material:new WireframeMaterial(0x00FF00), x:-250, y:160, z:-250, radius:150, tube:60, segmentsR:8, segmentsT:6});

        for each (var v:Vertex in plane.vertices)
            v.y += Math.random() * 50;

        super(sphere, plane, cube, gridplane, torus);
    }
    
}

class Blockers extends ObjectContainer3D
{
    protected var sphere:Sphere;
    protected var plane:Plane;
    protected var cube:Cube;
    protected var torus:Torus;
                       
    protected var sphereblock:ConvexBlock;
    protected var planeblock:ConvexBlock;

    public function Blockers()
    {
        plane = new Plane({material:new WireColorMaterial(0xFFFF00), y:-20, width:1000, height:1000, pushback:true});
        cube = new Cube({material:new WireColorMaterial(0x0000FF), x: 300, y:160, z: -80, width:200, height:200, depth:200});
        torus = new Torus({material:new WireColorMaterial(0x00FF00), x:-250, y:160, z:-250, radius:150, tube:60, segmentsR:8, segmentsT:6});
        sphere = new Sphere({material:new WireColorMaterial(0xFF0000), x:300, y:160, z: 300, radius:150, segmentsW:12, segmentsH:9});

        sphereblock = new ConvexBlock(new Sphere({radius:150, segmentsW:8, segmentsH:6}).vertices, {x:-300, y:160, z: 300, debug:true});
        planeblock = new ConvexBlock(new Plane({width:400, height:1000}).vertices, {x:650, y:200, z:0, rotationZ:90, debug:true});

        super(sphere, plane, cube, torus, sphereblock, planeblock);
    }
    
}

class MouseEvents extends Primitives
{
    public function MouseEvents()
    {
		addOnMouseDown(onMouseDown);
    }

    public function onMouseDown(e:MouseEvent3D):void
    {
        if (e.object is Mesh)
        {
            var mesh:Mesh = e.object as Mesh;
            mesh.material = new WireColorMaterial();
        }
    }
}

class Drawing extends ObjectContainer3D
{
    private var plane:Plane;
    private var paintData:BitmapData;
    private var pallete:BitmapData;
    private var drawing:Boolean;
    private var lastx:Number;
    private var lasty:Number;

    private var thickness:Number = 8;
    private var spray:Number = 1;
    private var color:Number = 0x808080;
    private var smooth:Boolean = true;
    private var wireplane:WirePlane;

    public function Drawing()
    {
        paintData = new BitmapData(400, 400);
        plane = new Plane({material:new BitmapMaterial(paintData, {precision:8, smooth:true}), width:1000, height:1000, segmentsW:10, segmentsH:10, y:-20});
        wireplane = new WirePlane({material:new WireframeMaterial(0x000000), width:1002, height:1002, y:-20});

        plane.addOnMouseDown(onPlaneMouseDown);
        plane.addOnMouseMove(onPlaneMouseMove);

        super(plane, wireplane);
    }

    public function onPlaneMouseDown(e:MouseEvent3D):void
    {
        drawing = !drawing;
        if (drawing)
        {
            lastx = e.uv.u*paintData.width;
            lasty = (1-e.uv.v)*paintData.height;
        }
    }
    
    public function onPlaneMouseMove(e:MouseEvent3D):void
    {
        if (drawing)
        {
            color = Color.fromHSV((getTimer()/100) % 360, 1, 1);

            var x:Number = e.uv.u*paintData.width;
            var y:Number = (1-e.uv.v)*paintData.height;
            var n:Number = Math.sqrt((lastx-x)*(lastx-x) + (lasty-y)*(lasty-y)) * (thickness+1.2);
            for (var i:int = 0; i < n; i++)
            {
                var k:Number = Math.random();
                var dx:Number = (2*Math.random()-1)*(thickness*(0.2+spray));
                var dy:Number = (2*Math.random()-1)*(thickness*(0.2+spray));
                var bx:Number = k*x + (1-k)*lastx + dx;
                var by:Number = k*y + (1-k)*lasty + dy;

                var rx:int = int(Math.round(bx));
                var ry:int = int(Math.round(by));
                paintData.setPixel(rx, ry, color);
				/*
                if (i % 20 == 0)
                {
                    var px:Number = (bx / paintData.width * 2 - 1) * 500;
                    var py:Number = (1 - by / paintData.height * 2) * 500;

                    for each (var vertex:Vertex in plane.vertices)
                        vertex.y += 40 * thickness / ((vertex.x-px)*(vertex.x-px) + (vertex.z-py)*(vertex.z-py) + 5000);
                }
				*/
            }
            lastx = x;
            lasty = y;
        }
    }
}

class PerspectiveTexturing extends ObjectContainer3D
{
    public var cube:Cube;
                       
    public function PerspectiveTexturing()
    {
        cube = new Cube({material:new BitmapMaterial(Asset.httt, {precision:2.5}), width:800, height:800, depth:800});
        
        super(cube);
    }
    
}

class FunnyCube extends ObjectContainer3D
{
    public var cube:Cube;
    public var material:BitmapMaterial;
                       
    public override function tick(time:int):void
    {
        if (cube != null)
            removeChild(cube);

        var m:Matrix = new Matrix();
        m.translate(-250,-250);
        m.scale(2*(Math.abs(Math.sin(time/2000))+0.2), 2*(Math.abs(Math.cos(time/2000))+0.2));
        material = new BitmapMaterial(Asset.target, {precision:2.5, transform:m, repeat:false, normal:new Number3D(1, 1, 1)});
        cube = new Cube({material:material, width:500, height:500, depth:500, bothsides:true});

        addChild(cube);
    }
    
}

class SimpleSkybox extends ObjectContainer3D
{
    public var skybox:Skybox;
                       
    public function SimpleSkybox()
    {
        skybox = new Skybox(new BitmapMaterial(Asset.morningFront, {smooth:true}), 
                            new BitmapMaterial(Asset.morningLeft, {smooth:true}), 
                            new BitmapMaterial(Asset.morningBack, {smooth:true}), 
                            new BitmapMaterial(Asset.morningRight, {smooth:true}), 
                            new BitmapMaterial(Asset.morningUp, {smooth:true}), 
                            new BitmapMaterial(Asset.morningDown, {smooth:true}));

        skybox.quarterFaces();

        super(skybox);
    }
    
}

class SmoothSkybox extends ObjectContainer3D
{
    public var skybox:Skybox6;
                       
    public function SmoothSkybox()
    {
        skybox = new Skybox6(new BitmapMaterial(Asset.darkSky, {precision:5}));                   

        super(skybox);
    }
    
}

class ZOrdering extends ObjectContainer3D
{
    private var cube:Cube;
                       
    public function ZOrdering()
    {
        var white:IMaterial = new WireColorMaterial(0xFFFFFF, 0xEEEEEE);// new ColorShadingBitmapMaterial(0xFFFFFF, 0xFFFFFF, 0);
        var grey:IMaterial = new WireColorMaterial(0x808080, 0x777777);// new ColorShadingBitmapMaterial(0x808080, 0x808080, 0);

        cube = new Cube({material:white, width:600, height:600, depth:600});

        super(null, cube);

        addChild(new Cube({material:grey, x: 340, y: 210, z: 210, width:60, height:60, depth:60}));
        addChild(new Cube({material:grey, x: 340, y: 210, z:-210, width:60, height:60, depth:60}));
        addChild(new Cube({material:grey, x: 340, y:-210, z: 210, width:60, height:60, depth:60}));
        addChild(new Cube({material:grey, x: 340, y:-210, z:-210, width:60, height:60, depth:60}));
        addChild(new Cube({material:grey, x:-340, y: 210, z: 210, width:60, height:60, depth:60}));
        addChild(new Cube({material:grey, x:-340, y: 210, z:-210, width:60, height:60, depth:60}));
        addChild(new Cube({material:grey, x:-340, y:-210, z: 210, width:60, height:60, depth:60}));
        addChild(new Cube({material:grey, x:-340, y:-210, z:-210, width:60, height:60, depth:60}));

        addChild(new Cube({material:grey, x: 210, y: 340, z: 210, width:60, height:60, depth:60}));
        addChild(new Cube({material:grey, x: 210, y: 340, z:-210, width:60, height:60, depth:60}));
        addChild(new Cube({material:grey, x: 210, y:-340, z: 210, width:60, height:60, depth:60}));
        addChild(new Cube({material:grey, x: 210, y:-340, z:-210, width:60, height:60, depth:60}));
        addChild(new Cube({material:grey, x:-210, y: 340, z: 210, width:60, height:60, depth:60}));
        addChild(new Cube({material:grey, x:-210, y: 340, z:-210, width:60, height:60, depth:60}));
        addChild(new Cube({material:grey, x:-210, y:-340, z: 210, width:60, height:60, depth:60}));
        addChild(new Cube({material:grey, x:-210, y:-340, z:-210, width:60, height:60, depth:60}));

        addChild(new Cube({material:grey, x: 210, y: 210, z: 340, width:60, height:60, depth:60}));
        addChild(new Cube({material:grey, x: 210, y: 210, z:-340, width:60, height:60, depth:60}));
        addChild(new Cube({material:grey, x: 210, y:-210, z: 340, width:60, height:60, depth:60}));
        addChild(new Cube({material:grey, x: 210, y:-210, z:-340, width:60, height:60, depth:60}));
        addChild(new Cube({material:grey, x:-210, y: 210, z: 340, width:60, height:60, depth:60}));
        addChild(new Cube({material:grey, x:-210, y: 210, z:-340, width:60, height:60, depth:60}));
        addChild(new Cube({material:grey, x:-210, y:-210, z: 340, width:60, height:60, depth:60}));
        addChild(new Cube({material:grey, x:-210, y:-210, z:-340, width:60, height:60, depth:60}));
    }
    
}

class IntersectingObjects extends ObjectContainer3D
{
    private var cubeA:Cube;
    private var cubeB:Cube;
    private var cubeC:Cube;
                       
    public function IntersectingObjects()
    {
        cubeA = new Cube({material:new BitmapMaterial(Asset.red, {precision:2}), width:40, height:120, depth:400});
        cubeB = new Cube({material:new BitmapMaterial(Asset.yellow, {precision:2}), width:400, height:40, depth:120});
        cubeC = new Cube({material:new BitmapMaterial(Asset.blue, {precision:2}), width:120, height:400, depth:40});

        super(cubeA, cubeB, cubeC);

        x = 250;
    }
    
}

class IntersectingObjects2 extends ObjectContainer3D
{
    private var a:Sphere;
    private var b:Sphere;

    public function IntersectingObjects2()
    {
        var k:int = 1;
        a = new Sphere({material:new WireColorMaterial(0xFFFFFF, 0x000000), radius:280, segmentsW:3, segmentsH:2});
        b = new Sphere({material:new BitmapMaterial(Asset.foilColor), radius:200, segmentsW:8, segmentsH:6});

        a.rotationY = 360 / 6 / 2;
        super(a, b);

        x = -250;
    }
}

class ColorLighting extends ObjectContainer3D
{
    private var plane:Plane;
    private var sphere:Sphere;
    private var texture:ShadingColorMaterial;
    private var light1:Light3D;
    private var light2:Light3D;
    private var light3:Light3D;
    private var lights:ObjectContainer3D;

    public function ColorLighting()
    {
        texture = new ShadingColorMaterial({ambient:0xFFFFFF, diffuse:0xFFFFFF, specular:0xFFFFFF, alpha:20});
        plane = new Plane({material:texture, y:-100, width:1000, height:1000, segments:16});
        sphere = new Sphere({material:texture, y:800, radius:200, segmentsW:12, segmentsH:9});
        light1 = new Light3D({color:0xFF0000, ambient:0.5, diffuse:0.5, specular:1});
        light2 = new Light3D({color:0x808000, ambient:0.5, diffuse:0.5, specular:1});
        light3 = new Light3D({color:0x0000FF, ambient:0.5, diffuse:0.5, specular:1});
        super(plane, light1, light2, light3);
    }
    
    public override function tick(time:int):void
    {
        for (var x:int = 0; x <= 16; x++)
            for (var y:int = 0; y <= 16; y++)
                plane.vertex(x, y).y = 50*Math.sin(dist(x-16/2*Math.sin(time/5000), y-16/2*Math.cos(time/7000))/2+time/500);

        light1.x = 600*Math.sin(time/5000) + 200*Math.sin(time/6000) + 200*Math.sin(time/7000);
        light1.z = 400*Math.cos(time/5000) + 500*Math.cos(time/6000) + 100*Math.cos(time/7000);
        light1.y = 400 + 100*Math.sin(time/10000);

        light2.x = 400*Math.sin(time/5500) + 400*Math.sin(time/4000) + 200*Math.sin(time/5000);
        light2.z = 400*Math.cos(time/5500) + 500*Math.cos(time/4000) + 100*Math.cos(time/5000);
        light2.y = 400 + 100*Math.sin(time/11000);

        light3.x = 300*Math.sin(time/3000) + 200*Math.sin(time/6500) + 300*Math.sin(time/4000);
        light3.z = 100*Math.cos(time/3000) + 300*Math.cos(time/6500) + 600*Math.cos(time/4000);
        light3.y = 400 + 100*Math.sin(time/12000);
    }

    private static function dist(dx:Number, dy:Number):Number
    {
        return Math.sqrt(dx*dx + dy*dy);
    }
}

class WhiteLighting extends ObjectContainer3D
{
    private var sphere:Sphere;
    private var light1:Light3D;
    private var light2:Light3D;
    private var texture:WhiteShadingBitmapMaterial;
    private var light1c:ObjectContainer3D;
    private var light2c:ObjectContainer3D;

    public function WhiteLighting()
    {
        texture = new WhiteShadingBitmapMaterial(Asset.mandelbrot);
        texture.smooth = true;

        sphere = new Sphere({material:texture, radius:200, segmentsW:4*7, segmentsH:3*7});
        sphere.scaleY(1.2);

        for each (var v:Vertex in sphere.vertices)
        {
            var y:Number = v.y / sphere.radius;
            y = y + (y*y - 1)*0.2;
            v.y = y * sphere.radius * 1.1;

            v.x += Math.random()*4-2;
            v.z += Math.random()*4-2;
            v.y += Math.random()*2-1;
        }

        light1 = new Light3D({color:0x555555, ambient:1, diffuse:1, specular:1});
        light1.x = 3500/2;
        light1.y = 3500/2;
        light1.z = 3500/2;
        light2 = new Light3D({color:0xAAAAAA, ambient:1, diffuse:1, specular:1});
        light2.x = -3000/2;
        light2.y = 3000/2;
        light2.z = 3000/2;
        light1c = new ObjectContainer3D(null, light1);
        light2c = new ObjectContainer3D(null, light1);

        super(sphere, light1c, light2c);
    }
    
    public override function tick(time:int):void
    {
        light1c.rotationY = time / 100;
        light2c.rotationY = time / 200;
        if (time % 19 == 1)
            texture.doubleStepTo(64);

        if (light1.x*light1.x + light1.y*light1.y + light1.z*light1.z > 350*350)
        {
            light1.x *= 0.996;
            light1.y *= 0.996;
            light1.z *= 0.996;
        }
            
        if (light2.x*light2.x + light2.y*light2.y + light2.z*light2.z > 300*300)
        {
            light2.x *= 0.997;
            light2.y *= 0.997;
            light2.z *= 0.997;
        }
    }
}

class Morphing extends ObjectContainer3D
{
    private var circle:Mesh;
    private var tri:Mesh;
    private var square:Mesh;
    private var morph:Mesh;
    private var morpher:Morpher;
    private var texture:WireColorMaterial;

    public function Morphing()
    {
        texture = new WireColorMaterial();
        circle = Collada.parse(Asset.CircleModel, {materials:{face:texture}}).children[0];
        tri    = Collada.parse(Asset.TriModel, {materials:{face:texture}}).children[0];
        square = Collada.parse(Asset.SquareModel, {materials:{face:texture}}).children[0];
        morph  = Collada.parse(Asset.CircleModel, {materials:{face:texture}}).children[0];
        morpher = new Morpher(morph);

        super(morph);
    }

    public override function tick(time:int):void
    {
        var kt:Number = Math.min(Math.max(Math.sin(time/3000), 0), 1);
        var ks:Number = Math.min(Math.max(Math.sin(time/3000+2*Math.PI/3), 0), 1);
        morpher.start();
        morpher.mix(tri, kt);
        morpher.mix(square, ks);
        morpher.finish(circle);
        texture.color = int(255*kt)*0x10000 + int(255*(1-kt-ks))*0x100 + int(255*ks);
    }
}
