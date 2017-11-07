package helloalternativa3d  
{
	import alternativa.engine3d.controllers.*;import alternativa.engine3d.core.*;
	import alternativa.engine3d.lights.*;import alternativa.engine3d.materials.*;
	import alternativa.engine3d.primitives.*;import alternativa.engine3d.resources.*;
	import alternativa.engine3d.shadows.*;import alternativa.engine3d.loaders.*;
	import alternativa.engine3d.objects.*;import alternativa.engine3d.core.*;
	import alternativa.protocol.codec.primitive.*;
	import flash.concurrent.Mutex;
	import flash.filters.GlowFilter;
	
	import flash.display.*; import flash.events.*; import flash.system.*; 
	import flash.ui.*; import flash.utils.*; import flash.sampler.*; 
	import flash.media.*; import flash.net.*; import flash.external.*;
	import flash.text.*; import flash.geom.*;
	
	import flash.utils.*;
	import mx.graphics.codec.*;
	/**
	 * ...
	 * @author Lexcuk
	 */
	public class Blender3DMesh 
	{
		
		public function Blender3DMesh() 
		{
			
		}


		public static function makeMeshFromBlender(blenderVertices:Array, blenderIndex:Array, blenderUv:Array, sx:Number = 100, sy:Number = 100, sz:Number = 100, shadow:DirectionalLightShadow = null, blaMaterial:VertexLightTextureMaterial = null, stage3D:Stage3D = null, rotationMatrix:Matrix3D = null):Mesh {
			
			var mesh:Mesh = new Mesh();
			var attributes:Array = [
				VertexAttributes.POSITION,
				VertexAttributes.POSITION,
				VertexAttributes.POSITION,
				VertexAttributes.TEXCOORDS[0],
				VertexAttributes.TEXCOORDS[0],
				VertexAttributes.NORMAL,
				VertexAttributes.NORMAL,
				VertexAttributes.NORMAL,
				VertexAttributes.TANGENT4,
				VertexAttributes.TANGENT4,
				VertexAttributes.TANGENT4,
				VertexAttributes.TANGENT4
			];
			
			
			var meVertices:Array = blenderVertices;// [ -0.19641, -0.00000, 0.00000, 0.19641, -0.00000, 0.00000, -0.19641, 1.00000, 0.00000, 0.19641, 1.00000, 0.00000, -0.19641, 0.92388, -0.38268, 0.19641, 0.92388, -0.38268, -0.19641, 0.70711, -0.70711, 0.19641, 0.70711, -0.70711, -0.19641, 0.38268, -0.92388, 0.19641, 0.38268, -0.92388, -0.19641, -0.00000, -1.00000, 0.19641, -0.00000, -1.00000, -0.19641, -0.38268, -0.92388, 0.19641, -0.38268, -0.92388, -0.19641, -0.70711, -0.70711, 0.19641, -0.70711, -0.70711, -0.19641, -0.92388, -0.38268, 0.19641, -0.92388, -0.38268, -0.19641, -1.00000, -0.00000, 0.19641, -1.00000, -0.00000, -0.19641, -0.92388, 0.38268, 0.19641, -0.92388, 0.38268, -0.19641, -0.70711, 0.70711, 0.19641, -0.70711, 0.70711, -0.19641, -0.38268, 0.92388, 0.19641, -0.38268, 0.92388, -0.19641, 0.00000, 1.00000, 0.19641, 0.00000, 1.00000, -0.19641, 0.38268, 0.92388, 0.19641, 0.38268, 0.92388, -0.19641, 0.70711, 0.70711, 0.19641, 0.70711, 0.70711, -0.19641, 0.92388, 0.38268, 0.19641, 0.92388, 0.38268, -0.19641, 1.00000, 0.00000, 0.19641, 1.00000, 0.00000, -0.19641, 0.92388, -0.38268, 0.19641, 0.92388, -0.38268, -0.19641, 0.70711, -0.70711, 0.19641, 0.70711, -0.70711, -0.19641, 0.38268, -0.92388, 0.19641, 0.38268, -0.92388, -0.19641, -0.00000, -1.00000, 0.19641, -0.00000, -1.00000, -0.19641, -0.38268, -0.92388, 0.19641, -0.38268, -0.92388, -0.19641, -0.70711, -0.70711, 0.19641, -0.70711, -0.70711, -0.19641, -0.92388, -0.38268, 0.19641, -0.92388, -0.38268, -0.19641, -1.00000, -0.00000, 0.19641, -1.00000, -0.00000, -0.19641, -0.92388, 0.38268, 0.19641, -0.92388, 0.38268, -0.19641, -0.70711, 0.70711, 0.19641, -0.70711, 0.70711, -0.19641, -0.38268, 0.92388, 0.19641, -0.38268, 0.92388, -0.19641, 0.00000, 1.00000, 0.19641, 0.00000, 1.00000, -0.19641, 0.38268, 0.92388, 0.19641, 0.38268, 0.92388, -0.19641, 0.70711, 0.70711, 0.19641, 0.70711, 0.70711, -0.19641, 0.92388, 0.38268, 0.19641, 0.92388, 0.38268];
			var meIndex:Array = blenderIndex;// [0, 2, 4, 1, 5, 3, 0, 4, 6, 1, 7, 5, 0, 6, 8, 1, 9, 7, 0, 8, 10, 1, 11, 9, 0, 10, 12, 1, 13, 11, 0, 12, 14, 1, 15, 13, 0, 14, 16, 1, 17, 15, 0, 16, 18, 1, 19, 17, 0, 18, 20, 1, 21, 19, 0, 20, 22, 1, 23, 21, 0, 22, 24, 1, 25, 23, 0, 24, 26, 1, 27, 25, 0, 26, 28, 1, 29, 27, 0, 28, 30, 1, 31, 29, 0, 30, 32, 1, 33, 31, 0, 32, 2, 1, 3, 33, 34, 35, 37, 34, 37, 36, 36, 37, 39, 36, 39, 38, 38, 39, 41, 38, 41, 40, 40, 41, 43, 40, 43, 42, 42, 43, 45, 42, 45, 44, 44, 45, 47, 44, 47, 46, 46, 47, 49, 46, 49, 48, 48, 49, 51, 48, 51, 50, 50, 51, 53, 50, 53, 52, 52, 53, 55, 52, 55, 54, 54, 55, 57, 54, 57, 56, 56, 57, 59, 56, 59, 58, 58, 59, 61, 58, 61, 60, 60, 61, 63, 60, 63, 62, 62, 63, 65, 62, 65, 64, 64, 65, 35, 64, 35, 34];
			var meUv:Array = blenderUv;// [0.181198046, 0.844001532, 0.232292399, 0.276565462, 0.051094260, 0.275207728, 0.181198046, 0.844001532, 0.232292399, 0.276565462, 0.051094260, 0.275207728, 0.181198046, 0.844001532, 0.232292399, 0.276565462, 0.051094260, 0.275207728, 0.181198046, 0.844001532, 0.232292399, 0.276565462, 0.051094260, 0.275207728, 0.181198046, 0.844001532, 0.232292399, 0.276565462, 0.051094260, 0.275207728, 0.181198046, 0.844001532, 0.232292399, 0.276565462, 0.051094260, 0.275207728, 0.181198046, 0.844001532, 0.232292399, 0.276565462, 0.051094260, 0.275207728, 0.181198046, 0.844001532, 0.232292399, 0.276565462, 0.051094260, 0.275207728, 0.181198046, 0.844001532, 0.232292399, 0.276565462, 0.051094260, 0.275207728, 0.181198046, 0.844001532, 0.232292399, 0.276565462, 0.051094260, 0.275207728, 0.181198046, 0.844001532, 0.232292399, 0.276565462, 0.051094260, 0.275207728, 0.181198046, 0.844001532, 0.232292399, 0.276565462, 0.051094260, 0.275207728, 0.181198046, 0.844001532, 0.232292399, 0.276565462, 0.051094260, 0.275207728, 0.181198046, 0.844001532, 0.232292399, 0.276565462, 0.051094260, 0.275207728, 0.181198046, 0.844001532, 0.232292399, 0.276565462, 0.051094260, 0.275207728, 0.181198046, 0.844001532, 0.232292399, 0.276565462, 0.051094260, 0.275207728, 0.181198046, 0.844001532, 0.232292399, 0.276565462, 0.051094260, 0.275207728, 0.181198046, 0.844001532, 0.232292399, 0.276565462, 0.051094260, 0.275207728, 0.181198046, 0.844001532, 0.232292399, 0.276565462, 0.051094260, 0.275207728, 0.181198046, 0.844001532, 0.232292399, 0.276565462, 0.051094260, 0.275207728, 0.181198046, 0.844001532, 0.232292399, 0.276565462, 0.051094260, 0.275207728, 0.181198046, 0.844001532, 0.232292399, 0.276565462, 0.051094260, 0.275207728, 0.181198046, 0.844001532, 0.232292399, 0.276565462, 0.051094260, 0.275207728, 0.181198046, 0.844001532, 0.232292399, 0.276565462, 0.051094260, 0.275207728, 0.181198046, 0.844001532, 0.232292399, 0.276565462, 0.051094260, 0.275207728, 0.181198046, 0.844001532, 0.232292399, 0.276565462, 0.051094260, 0.275207728, 0.181198046, 0.844001532, 0.232292399, 0.276565462, 0.051094260, 0.275207728, 0.181198046, 0.844001532, 0.232292399, 0.276565462, 0.051094260, 0.275207728, 0.181198046, 0.844001532, 0.232292399, 0.276565462, 0.051094260, 0.275207728, 0.181198046, 0.844001532, 0.232292399, 0.276565462, 0.051094260, 0.275207728, 0.181198046, 0.844001532, 0.232292399, 0.276565462, 0.051094260, 0.275207728, 0.181198046, 0.844001532, 0.232292399, 0.276565462, 0.051094260, 0.275207728, 0.022567511, 0.096786246, 0.332901329, 0.096786246, 0.332901329, 0.407120079, 0.022567511, 0.096786246, 0.332901329, 0.407120079, 0.022567511, 0.407120079, 0.022567511, 0.096786246, 0.332901329, 0.096786246, 0.332901329, 0.407120079, 0.022567511, 0.096786246, 0.332901329, 0.407120079, 0.022567511, 0.407120079, 0.022567511, 0.096786246, 0.332901329, 0.096786246, 0.332901329, 0.407120079, 0.022567511, 0.096786246, 0.332901329, 0.407120079, 0.022567511, 0.407120079, 0.022567511, 0.096786246, 0.332901329, 0.096786246, 0.332901329, 0.407120079, 0.022567511, 0.096786246, 0.332901329, 0.407120079, 0.022567511, 0.407120079, 0.022567511, 0.096786246, 0.332901329, 0.096786246, 0.332901329, 0.407120079, 0.022567511, 0.096786246, 0.332901329, 0.407120079, 0.022567511, 0.407120079, 0.022567511, 0.096786246, 0.332901329, 0.096786246, 0.332901329, 0.407120079, 0.022567511, 0.096786246, 0.332901329, 0.407120079, 0.022567511, 0.407120079, 0.022567511, 0.096786246, 0.332901329, 0.096786246, 0.332901329, 0.407120079, 0.022567511, 0.096786246, 0.332901329, 0.407120079, 0.022567511, 0.407120079, 0.022567511, 0.096786246, 0.332901329, 0.096786246, 0.332901329, 0.407120079, 0.022567511, 0.096786246, 0.332901329, 0.407120079, 0.022567511, 0.407120079, 0.022567511, 0.096786246, 0.332901329, 0.096786246, 0.332901329, 0.407120079, 0.022567511, 0.096786246, 0.332901329, 0.407120079, 0.022567511, 0.407120079, 0.022567511, 0.096786246, 0.332901329, 0.096786246, 0.332901329, 0.407120079, 0.022567511, 0.096786246, 0.332901329, 0.407120079, 0.022567511, 0.407120079, 0.022567511, 0.096786246, 0.332901329, 0.096786246, 0.332901329, 0.407120079, 0.022567511, 0.096786246, 0.332901329, 0.407120079, 0.022567511, 0.407120079, 0.022567511, 0.096786246, 0.332901329, 0.096786246, 0.332901329, 0.407120079, 0.022567511, 0.096786246, 0.332901329, 0.407120079, 0.022567511, 0.407120079, 0.022567511, 0.096786246, 0.332901329, 0.096786246, 0.332901329, 0.407120079, 0.022567511, 0.096786246, 0.332901329, 0.407120079, 0.022567511, 0.407120079, 0.022567511, 0.096786246, 0.332901329, 0.096786246, 0.332901329, 0.407120079, 0.022567511, 0.096786246, 0.332901329, 0.407120079, 0.022567511, 0.407120079, 0.022567511, 0.096786246, 0.332901329, 0.096786246, 0.332901329, 0.407120079, 0.022567511, 0.096786246, 0.332901329, 0.407120079, 0.022567511, 0.407120079, 0.022567511, 0.096786246, 0.332901329, 0.096786246, 0.332901329, 0.407120079, 0.022567511, 0.096786246, 0.332901329, 0.407120079, 0.022567511, 0.407120079];
			
			
			
			meUvFix(meUv);
			meshZswapY(meVertices);
			meshFixer(meVertices);
			if (rotationMatrix != null) rotateByMatrix(meVertices,rotationMatrix);
			
			var mv:Array = [];
			var mUv:Array = [];
			var i:int;
			for (i = 0; i < meIndex.length; i++) {
				//mUv.push(meUv[meIndex[i] * 2 + 0], meUv[meIndex[i] * 2 + 1]);
				mUv.push(meUv[i * 2 + 0], meUv[i * 2 + 1]);
				mv.push(meVertices[meIndex[i] * 3 + 0], meVertices[meIndex[i] * 3 + 1], meVertices[meIndex[i] * 3 + 2]);
			}
			
			for (i = 0; i < mv.length; i+=3) {
				mv[i + 0] *= sx/2;
				mv[i + 1] *= sy/2;
				mv[i + 2] *= sz/2;
			}
			
			var indexData:Vector.<uint> = new Vector.<uint>();
			for (i = 0; i < meIndex.length; i += 3) {
				if (sx < 0) {
					indexData.push(i + 2);
					indexData.push(i + 1);
					indexData.push(i + 0);
				}
				if (sx > 0) {
					indexData.push(i + 0);
					indexData.push(i + 1);
					indexData.push(i + 2);
				}
			}
			
			var vertices:Vector.<Number> = Vector.<Number>(mv);
			var indexes:Vector.<uint> = indexData;
			var uvs:Vector.<Number> = Vector.<Number>(mUv);
			
			
			//trace(vertices.length + " " + segments * 3)
			mesh.geometry = new Geometry();
			mesh.geometry.numVertices = vertices.length/3;
			mesh.geometry.indices = indexes;
			mesh.geometry.addVertexStream(attributes);
			mesh.geometry.setAttributeValues(VertexAttributes.POSITION, vertices);
			mesh.geometry.setAttributeValues(VertexAttributes.TEXCOORDS[0], uvs);
			//mesh.geometry.setAttributeValues(VertexAttributes.TANGENT4, tangent);
			//mesh.geometry.setAttributeValues(VertexAttributes.NORMAL, normals);
			mesh.geometry.calculateTangents(0);
			mesh.geometry.calculateNormals();
			
			mesh.addSurface(blaMaterial, 0, indexes.length / 3);
			
			mesh.geometry.upload(stage3D.context3D);
			
			
			mesh.calculateBoundBox();
			//mesh.setMaterialToAllSurfaces(material);
			//stage3D.context3D.setCulling(Context3DTriangleFace.FRONT_AND_BACK);
			//cameraContainer.rotationZ = -Math.PI/2;
			
			shadow.addCaster(mesh);
			mesh.setMaterialToAllSurfaces(blaMaterial);
			return mesh;
		}

		private static function meUvFix(uvar:Array):void {
			var i:int;
			var leng:int = uvar.length;
			
			for (i = 0; i < leng; i+=2) {
				uvar[i + 1] *= -1;
			}
		}

		private static function meshMin(vert:Array, p:int=0):Number {
			var i:int;
			var leng:int = vert.length;
			var min:Number = Number.MAX_VALUE;
			for (i = 0; i < leng; i+=3) {
				if (min > vert[i + p]) min = vert[i + p];
			}
			return min;
		}

		private static function rotateByMatrix(vert:Array,rMatrix:Matrix3D):void {
			var i:int;
			var leng:int = vert.length;
			for (i = 0; i < leng; i+=3) {
				var v:Vector3D = new Vector3D(vert[i], vert[i + 1], vert[i + 2]);
				v = rMatrix.transformVector(v);
				vert[i + 0] = v.x;
				vert[i + 1] = v.y;
				vert[i + 2] = v.z;
			}
		}

		private static function meshZswapY(vert:Array):void {
			var i:int;
			var leng:int = vert.length;
			var z:Number;
			var y:Number;
			for (i = 0; i < leng; i+=3) {
				z = vert[i + 2];
				y = vert[i + 1];
				
				vert[i + 2] = -y;
				vert[i + 1] = z;
			}
		}

		private static function meshMax(vert:Array, p:int=0):Number {
			var i:int;
			var leng:int = vert.length;
			var max:Number = Number.MIN_VALUE;
			for (i = 0; i < leng; i+=3) {
				if (max < vert[i + p]) max = vert[i + p];
			}
			return max;
		}

		private static function meshPos(vert:Array, p:int=0, pos:Number = 0):void {
			var i:int;
			var leng:int = vert.length;
			for (i = 0; i < leng; i+=3) {
				vert[i + p] = vert[i + p] + pos;
			}
			
		}


		private static function meshScale(vert:Array, p:int=0, scale:Number = 0):void {
			var i:int;
			var leng:int = vert.length;
			for (i = 0; i < leng; i+=3) {
				vert[i + p] = vert[i + p] * scale;
			}
			
		}

		private static function meshFixer(vert:Array):void {
			var minX:Number = meshMin(vert, 0);
			var maxX:Number = meshMax(vert, 0);
			meshPos(vert, 0, -minX);
			meshScale(vert, 0, 2 / (maxX - minX));
			meshPos(vert, 0, -1);
			//meshMerge(vert, 0, 0.7);
			
			var minY:Number = meshMin(vert, 1);
			var maxY:Number = meshMax(vert, 1);
			meshPos(vert, 1, -minY);
			meshScale(vert, 1, 2 / (maxY - minY));
			meshPos(vert, 1, -1);
			
			var minZ:Number = meshMin(vert, 2);
			var maxZ:Number = meshMax(vert, 2);
			meshPos(vert, 2, -minZ);
			meshScale(vert, 2, 2 / (maxZ - minZ));
			meshPos(vert, 2, -1);
		}

	}

}