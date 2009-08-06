﻿﻿package away3d.core.base{	import away3d.arcane;	import away3d.core.math.*;	import away3d.core.utils.*;	import away3d.events.*;	import away3d.materials.*;		import flash.events.Event;        use namespace arcane;    	 /**	 * Dispatched when the uv mapping of the face changes.	 * 	 * @eventType away3d.events.FaceEvent	 */	[Event(name="mappingChanged",type="away3d.events.FaceEvent")]    	 /**	 * Dispatched when the material of the face changes.	 * 	 * @eventType away3d.events.FaceEvent	 */	[Event(name="materialChanged",type="away3d.events.FaceEvent")]	    /**    * A triangle element used in the mesh object    *     * @see away3d.core.base.Mesh    */    public class Face extends Element    {		/** @private */        arcane var _v0:Vertex;		/** @private */        arcane var _v1:Vertex;		/** @private */        arcane var _v2:Vertex;		/** @private */        arcane var _uv0:UV;		/** @private */        arcane var _uv1:UV;		/** @private */        arcane var _uv2:UV;		/** @private */        arcane var _material:ITriangleMaterial;		/** @private */        arcane var _back:ITriangleMaterial;                private var _normal:Number3D = new Number3D();        private var _normalDirty:Boolean;        private var _area:Number;        private var _areaDirty:Boolean;		private var _a:Number;		private var _b:Number;		private var _c:Number;		private var _s:Number;		private var _index:int;		private var _vertices:Array = new Array();		private var _commands:Array = new Array();		private var _drawingCommands:Array = new Array();		private var _lastAddedVertex:Vertex;		        private function onUVChange(event:Event):void        {            notifyMappingChange();        }				private function updateVertex():void		{			vertexDirty = false;			_normalDirty = true;			_areaDirty = true;		}				private function updateNormal():void		{	    	_normalDirty = false;	    		        var d1x:Number = _v1.x - _v0.x;	        var d1y:Number = _v1.y - _v0.y;	        var d1z:Number = _v1.z - _v0.z;	    	        var d2x:Number = _v2.x - _v0.x;	        var d2y:Number = _v2.y - _v0.y;	        var d2z:Number = _v2.z - _v0.z;	    	        var pa:Number = d1y*d2z - d1z*d2y;	        var pb:Number = d1z*d2x - d1x*d2z;	        var pc:Number = d1x*d2y - d1y*d2x;		        var pdd:Number = Math.sqrt(pa*pa + pb*pb + pc*pc);		        _normal.x = pa / pdd;	        _normal.y = pb / pdd;	        _normal.z = pc / pdd;  		}  		  		private function updateArea():void  		{  			// not quick enough            _a = v0.position.distance(v1.position);            _b = v1.position.distance(v2.position);            _c = v2.position.distance(v0.position);            _s = (_a + _b + _c) / 2;            _area = Math.sqrt(_s*(_s - _a)*(_s - _b)*(_s - _c));  		}  		  		private function addVertexAt(index:uint, vertex:Vertex, command:String):void  		{  			//trace("Face.as - adding vertex: " + vertex + ".");  			  			if(_vertices[index] && _vertices[index] == vertex)  				return;  			  			if (_vertices[index]) {	  			_index = _vertices[index].parents.indexOf(this);	  				if(_index != -1)	  					_vertices[index].parents.splice(_index, 1);	  		}	  					_commands[index] = faceVO.commands[index] = command;  			_vertices[index] = faceVO.vertices[index] = vertex;  			  			if(index == 0)  				_v0 = faceVO.v0 = vertex;  			else if(index == 1)  				_v1 = faceVO.v1 = vertex;  			else if(index == 2)  				_v2 = faceVO.v2 = vertex;  			//else  			  			if(index == 2)	  		{	  			if(-0.5*(_v0.x*(_v2.y - _v1.y) + _v1.x*(_v0.y - _v2.y) + _v2.x*(_v1.y - _v0.y)) < 0)	  				faceVO.reverseArea = true;	  		}	  			  		vertex._index = index;  			  			vertex.parents.push(this);  			  			vertexDirty = true;  		}  		  		public function moveTo(x:Number, y:Number, z:Number):void  		{  			var newVertex:Vertex = new Vertex(x, y, z);  			addVertexAt(_vertices.length, newVertex, DrawingCommand.MOVE);  			  			_drawingCommands.push(new DrawingCommand(DrawingCommand.MOVE, _lastAddedVertex, null, newVertex));  			_lastAddedVertex = newVertex;  		}  		  		public function lineTo(x:Number, y:Number, z:Number):void  		{  			var newVertex:Vertex = new Vertex(x, y, z);  			addVertexAt(_vertices.length, newVertex, DrawingCommand.LINE);  			  			_drawingCommands.push(new DrawingCommand(DrawingCommand.LINE, _lastAddedVertex, null, newVertex));  			_lastAddedVertex = newVertex;  		}  		  		public function curveTo(cx:Number, cy:Number, cz:Number, ex:Number, ey:Number, ez:Number):void  		{  			var newControlVertex:Vertex = new Vertex(cx, cy, cz);  			var newEndVertex:Vertex = new Vertex(ex, ey, ez);  			addVertexAt(_vertices.length, newControlVertex, DrawingCommand.CURVE);  			addVertexAt(_vertices.length, newEndVertex, "P");  			  			_drawingCommands.push(new DrawingCommand(DrawingCommand.CURVE, _lastAddedVertex, newControlVertex, newEndVertex));  			_lastAddedVertex = newEndVertex;  		}  				public var faceVO:FaceVO = new FaceVO();				/**		 * Forces the recalculation of the face normal		 * @param bool      Boolean, forces the refresh of the normal calculation		 */        public  function set normalDirty(val:Boolean):void        {           vertexDirty = val;        }				/**		 * Returns an array of vertex objects that are used by the face.		 */        public override function get vertices():Array        {            return _vertices;        }        		/**		 * Returns an array of drawing command strings that are used by the face.		 */        public override function get commands():Array        {            return _commands;        }                /**		 * Returns an array of drawing command objects that are used by the face.		 */        public function get drawingCommands():Array        {            return _drawingCommands;        }        		/**		 * Returns an array of uv objects that are used by the face.		 */		public function get uvs():Array        {            return [_uv0, _uv1, _uv2];        }				/**		 * Defines the v0 vertex of the face.		 */        public function get v0():Vertex        {            return _v0;        }        public function set v0(value:Vertex):void        {            addVertexAt(0, value, "M");        }				/**		 * Defines the v1 vertex of the face.		 */        public function get v1():Vertex        {            return _v1;        }        public function set v1(value:Vertex):void        {        	 addVertexAt(1, value, "L");        }				/**		 * Defines the v2 vertex of the face.		 */        public function get v2():Vertex        {            return _v2;        }        public function set v2(value:Vertex):void        {             addVertexAt(2, value, "L");        }				/**		 * Defines the material of the face.		 */        public function get material():ITriangleMaterial        {            return _material;        }        public function set material(value:ITriangleMaterial):void        {            if (value == _material)                return;						if (_material != null && parent)				parent.removeMaterial(this, _material);                        _material = faceVO.material = value;            			if (_material != null && parent)					parent.addMaterial(this, _material);                        notifyMappingChange();        }				/**		 * Defines the optional back material of the face.		 * Displays when the face is pointing away from the camera.		 */        public function get back():ITriangleMaterial        {            return _back;        }		        public function set back(value:ITriangleMaterial):void        {            if (value == _back)                return;						if (_back != null)				parent.removeMaterial(this, _back);                        _back = faceVO.back = value;            			if (_back != null)				parent.addMaterial(this, _back);						notifyMappingChange();        }				/**		 * Defines the uv0 coordinate of the face.		 */        public function get uv0():UV        {            return _uv0;        }        public function set uv0(value:UV):void        {            if (value == _uv0)                return;            if (_uv0 != null)                if ((_uv0 != _uv1) && (_uv0 != _uv2))                    _uv0.removeOnChange(onUVChange);            _uv0 = faceVO.uv0 = value;            if (_uv0 != null)                if ((_uv0 != _uv1) && (_uv0 != _uv2))                    _uv0.addOnChange(onUVChange);			            notifyMappingChange();        }				/**		 * Defines the uv1 coordinate of the face.		 */        public function get uv1():UV        {            return _uv1;        }        public function set uv1(value:UV):void        {            if (value == _uv1)                return;            if (_uv1 != null)                if ((_uv1 != _uv0) && (_uv1 != _uv2))                    _uv1.removeOnChange(onUVChange);            _uv1 = faceVO.uv1 = value;            if (_uv1 != null)                if ((_uv1 != _uv0) && (_uv1 != _uv2))                    _uv1.addOnChange(onUVChange);			            notifyMappingChange();        }				/**		 * Defines the uv2 coordinate of the face.		 */        public function get uv2():UV        {            return _uv2;        }        public function set uv2(value:UV):void        {            if (value == _uv2)                return;            if (_uv2 != null)                if ((_uv2 != _uv1) && (_uv2 != _uv0))                    _uv2.removeOnChange(onUVChange);            _uv2 = faceVO.uv2 = value;            if (_uv2 != null)                if ((_uv2 != _uv1) && (_uv2 != _uv0))                    _uv2.addOnChange(onUVChange);			            notifyMappingChange();        }				/**		 * Returns the calculated 2 dimensional area of the face.		 */        public function get area():Number        {        	if (vertexDirty)            	updateVertex();                        if (_areaDirty)            	updateArea();                        return _area;        }				/**		 * Returns the normal vector of the face.		 */        public function get normal():Number3D        {            if (vertexDirty)            	updateVertex();                        if (_normalDirty)            	updateNormal();                        return _normal;        }				/**		 * Returns the squared bounding radius of the face.		 */        public override function get radius2():Number        {            var rv0:Number = _v0._x*_v0._x + _v0._y*_v0._y + _v0._z*_v0._z;            var rv1:Number = _v1._x*_v1._x + _v1._y*_v1._y + _v1._z*_v1._z;            var rv2:Number = _v2._x*_v2._x + _v2._y*_v2._y + _v2._z*_v2._z;            if (rv0 > rv1)            {                if (rv0 > rv2)                    return rv0;                else                    return rv2;            }            else            {                if (rv1 > rv2)                    return rv1;                else                            return rv2;            }        }		    	/**    	 * Returns the maximum x value of the face    	 *     	 * @see		away3d.core.base.Vertex#x    	 */        public override function get maxX():Number        {            if (_v0._x > _v1._x)            {                if (_v0._x > _v2._x)                    return _v0._x;                else                    return _v2._x;            }            else            {                if (_v1._x > _v2._x)                    return _v1._x;                else                    return _v2._x;            }        }            	/**    	 * Returns the minimum x value of the face    	 *     	 * @see		away3d.core.base.Vertex#x    	 */        public override function get minX():Number        {            if (_v0._x < _v1._x)            {                if (_v0._x < _v2._x)                    return _v0._x;                else                    return _v2._x;            }            else            {                if (_v1._x < _v2._x)                    return _v1._x;                else                    return _v2._x;            }        }            	/**    	 * Returns the maximum y value of the face    	 *     	 * @see		away3d.core.base.Vertex#y    	 */        public override function get maxY():Number        {            if (_v0._y > _v1._y)            {                if (_v0._y > _v2._y)                    return _v0._y;                else                    return _v2._y;            }            else            {                if (_v1._y > _v2._y)                    return _v1._y;                else                    return _v2._y;            }        }            	/**    	 * Returns the minimum y value of the face    	 *     	 * @see		away3d.core.base.Vertex#y    	 */        public override function get minY():Number        {            if (_v0._y < _v1._y)            {                if (_v0._y < _v2._y)                    return _v0._y;                else                    return _v2._y;            }            else            {                if (_v1._y < _v2._y)                    return _v1._y;                else                    return _v2._y;            }        }            	/**    	 * Returns the maximum zx value of the face    	 *     	 * @see		away3d.core.base.Vertex#z    	 */        public override function get maxZ():Number        {            if (_v0._z > _v1._z)            {                if (_v0._z > _v2._z)                    return _v0._z;                else                    return _v2._z;            }            else            {                if (_v1._z > _v2._z)                    return _v1._z;                else                    return _v2._z;            }        }            	/**    	 * Returns the minimum z value of the face    	 *     	 * @see		away3d.core.base.Vertex#z    	 */        public override function get minZ():Number        {            if (_v0._z < _v1._z)            {                if (_v0._z < _v2._z)                    return _v0._z;                else                    return _v2._z;            }            else            {                if (_v1._z < _v2._z)                    return _v1._z;                else                    return _v2._z;            }        }				/**		 * Creates a new <code>Face</code> object.		 *		 * @param	v0						The first vertex object of the triangle		 * @param	v1						The second vertex object of the triangle		 * @param	v2						The third vertex object of the triangle		 * @param	material	[optional]	The material used by the triangle to render		 * @param	uv0			[optional]	The first uv object of the triangle		 * @param	uv1			[optional]	The second uv object of the triangle		 * @param	uv2			[optional]	The third uv object of the triangle		 * 		 * @see	away3d.core.base.Vertex		 * @see	away3d.materials.ITriangleMaterial		 * @see	away3d.core.base.UV		 */        public function Face(v0:Vertex = null, v1:Vertex = null, v2:Vertex = null, material:ITriangleMaterial = null, uv0:UV = null, uv1:UV = null, uv2:UV = null)        {        	if(v0)            	this.v0 = v0;            if(v1)            	this.v1 = v1;            if(v2)            	this.v2 = v2;                        this.material = material;            this.uv0 = uv0;            this.uv1 = uv1;            this.uv2 = uv2;                        faceVO.face = this;                        vertexDirty = true;        }				/**		 * Inverts the geometry of the face object by swapping the <code>v1</code>, <code>v2</code> and <code>uv1</code>, <code>uv2</code> points.		 */        public function invert():void        {            faceVO.v2 = this._v1;            faceVO.v1 = this._v2;            faceVO.uv2 = this._uv1;            faceVO.uv1 = this._uv2;			            this._v1 = faceVO.v1;            this._v2 = faceVO.v2;            this._uv1 = faceVO.uv1;            this._uv2 = faceVO.uv2;						vertexDirty = true;			            notifyMappingChange();        }                /**         * Produces a clone of the face.         * NOTE: Supports only irregular faces for now.          * @return [Face] The cloned face.         *          */                public function clone():Face        {        	var clonedFace:Face = new Face();        	for(var i:uint; i<drawingCommands.length; i++)			{				var command:DrawingCommand = drawingCommands[i];				switch(command.type)				{					case DrawingCommand.MOVE:						clonedFace.moveTo(command.pEnd.x, command.pEnd.y, command.pEnd.z);						break;					case DrawingCommand.LINE:						clonedFace.lineTo(command.pEnd.x, command.pEnd.y, command.pEnd.z);						break;					case DrawingCommand.CURVE:						clonedFace.curveTo(command.pControl.x, command.pControl.y, command.pControl.z, command.pEnd.x, command.pEnd.y, command.pEnd.z);						break;				}			}        	return clonedFace;        }                        /**         * Offsets the vertices of the face by given amounts in x, y and z.         * NOTE: Supports only irregular faces for now.          * @param x [Number] Offset in x.         * @param y [Number] Offset in y.         * @param z [Number] Offset in z.         *          */            public function offset(x:Number, y:Number, z:Number):void        {        	for(var i:uint; i<drawingCommands.length; i++)			{				var command:DrawingCommand = drawingCommands[i];				if(command.pControl)				{					command.pControl.x += x;					command.pControl.y += y;					command.pControl.z += z; 				}				if(command.pEnd)				{					command.pEnd.x += x;					command.pEnd.y += y;					command.pEnd.z += z; 				}			}        }                /**         * Scales the face by a given factor about its unweighed center.         * NOTE: Supports only irregular faces for now.          * @param scale [Number] The amount factor to scale the face.         *          */            public function scaleAboutCenter(scale:Number):void        {        	var minX:Number = Number.MAX_VALUE;        	var maxX:Number = -Number.MAX_VALUE;        	var minY:Number = Number.MAX_VALUE;        	var maxY:Number = -Number.MAX_VALUE;        	var minZ:Number = Number.MAX_VALUE;        	var maxZ:Number = -Number.MAX_VALUE;        	var i:uint;        	var command:DrawingCommand;			for(i = 0; i<drawingCommands.length; i++)			{				command = drawingCommands[i];				if(command.pControl)				{					if(command.pControl.x < minX)						minX = command.pControl.x;					if(command.pControl.x > maxX)						maxX = command.pControl.x;					if(command.pControl.y < minY)						minY = command.pControl.y;					if(command.pControl.y > maxY)						maxY = command.pControl.y;					if(command.pControl.z < minZ)						minZ = command.pControl.z;					if(command.pControl.z > maxZ)						maxZ = command.pControl.z;				}				if(command.pEnd)				{					if(command.pEnd.x < minX)						minX = command.pEnd.x;					if(command.pEnd.x > maxX)						maxX = command.pEnd.x;					if(command.pEnd.y < minY)						minY = command.pEnd.y;					if(command.pEnd.y > maxY)						maxY = command.pEnd.y;					if(command.pEnd.z < minZ)						minZ = command.pEnd.z;					if(command.pEnd.z > maxZ)						maxZ = command.pEnd.z;				}			}						var unweighedCenter:Number3D = new Number3D((maxX + minX)/2, (maxY + minY)/2, (maxZ + minZ)/2);			for(i = 0; i<drawingCommands.length; i++)			{				command = drawingCommands[i];				if(command.pControl)				{					var pControlCenterVec:Number3D = new Number3D(command.pControl.x, command.pControl.y, command.pControl.z);					pControlCenterVec.sub(pControlCenterVec, unweighedCenter);					pControlCenterVec.scale(pControlCenterVec, scale);					command.pControl.x = unweighedCenter.x + pControlCenterVec.x;					command.pControl.y = unweighedCenter.y + pControlCenterVec.y;					command.pControl.z = unweighedCenter.z + pControlCenterVec.z;				}				if(command.pEnd)				{					var pEndCenterVec:Number3D = new Number3D(command.pEnd.x, command.pEnd.y, command.pEnd.z);					pEndCenterVec.sub(pEndCenterVec, unweighedCenter);					pEndCenterVec.scale(pEndCenterVec, scale);					command.pEnd.x = unweighedCenter.x + pEndCenterVec.x;					command.pEnd.y = unweighedCenter.y + pEndCenterVec.y;					command.pEnd.z = unweighedCenter.z + pEndCenterVec.z;				}			}        }    }}