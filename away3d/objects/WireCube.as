package away3d.objects
{
    import away3d.core.*;
    import away3d.core.proto.*;
    import away3d.core.geom.*;
    import away3d.core.material.*;

    public class WireCube extends Mesh3D
    {
        public function WireCube(material:IMaterial = null, width:Number = 50, height:Number = 50, depth:Number = 50, init:Object = null)
        {
            super(material, init);

            var v000:Vertex3D = new Vertex3D(-width/2, -height/2, -depth/2); 
            var v001:Vertex3D = new Vertex3D(-width/2, -height/2, +depth/2); 
            var v010:Vertex3D = new Vertex3D(-width/2, +height/2, -depth/2); 
            var v011:Vertex3D = new Vertex3D(-width/2, +height/2, +depth/2); 
            var v100:Vertex3D = new Vertex3D(+width/2, -height/2, -depth/2); 
            var v101:Vertex3D = new Vertex3D(+width/2, -height/2, +depth/2); 
            var v110:Vertex3D = new Vertex3D(+width/2, +height/2, -depth/2); 
            var v111:Vertex3D = new Vertex3D(+width/2, +height/2, +depth/2); 

            vertices.push(v000);
            vertices.push(v001);
            vertices.push(v010);
            vertices.push(v011);
            vertices.push(v100);
            vertices.push(v101);
            vertices.push(v110);
            vertices.push(v111);
            
            segments.push(new Segment3D(v000, v001));
            segments.push(new Segment3D(v011, v001));
            segments.push(new Segment3D(v011, v010));
            segments.push(new Segment3D(v000, v010));

            segments.push(new Segment3D(v100, v000));
            segments.push(new Segment3D(v101, v001));
            segments.push(new Segment3D(v111, v011));
            segments.push(new Segment3D(v110, v010));

            segments.push(new Segment3D(v100, v101));
            segments.push(new Segment3D(v111, v101));
            segments.push(new Segment3D(v111, v110));
            segments.push(new Segment3D(v100, v110));
        }
    }
    
}