package helloalternativa3d  {
	
	
	
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import jiglib.data.TriangleVertexIndices;
	import jiglib.plugin.ISkin3D;
	
	public class Alternativa3DSkinObject implements ISkin3D {
		
		private var _mesh : *;
		private var _translationOffset : Vector3D;
		private var _scale : Vector3D;
		private var _transform : Matrix3D = new Matrix3D();

		public function Alternativa3DSkinObject(do3d : *, offset : Vector3D = null)
		{
			this._mesh = do3d;
			
			if (offset) {
				_translationOffset = offset.clone();
			}
			if (do3d.scaleX != 1 || do3d.scaleY != 1 || do3d.scaleZ != 1) {
				_scale = new Vector3D(do3d.scaleX, do3d.scaleY, do3d.scaleZ);
			}
		}

		public function get transform():Matrix3D {
			
			//return _mesh.transform;
			return _mesh.matrix;
		}
		
		public function set transform(m:Matrix3D):void 
		{	
			_transform.identity();
			if (_translationOffset) _transform.appendTranslation(_translationOffset.x, _translationOffset.y, _translationOffset.z);
			if (_scale) _transform.appendScale(_scale.x, _scale.y, _scale.z);
			_transform.append(m);
			//_mesh.transform = _transform;
			_mesh.matrix = _transform;
		}
		
		public function get mesh():* {
			return _mesh;
		}
		
		public function get vertices():Vector.<Vector3D>{
			return null;
		}
		
		public function get indices():Vector.<TriangleVertexIndices>{
			return null;
		}
	}
}
