//http://swf-flash.blogspot.com/2013/05/smoke-sprite3d-away3d-4.html
package helloalternativa3d 
{
	import alternativa.engine3d.controllers.*;
	import alternativa.engine3d.core.*;
	import alternativa.engine3d.lights.*;
	import alternativa.engine3d.materials.*;
	import alternativa.engine3d.primitives.*;
	import alternativa.engine3d.resources.*;
	import alternativa.engine3d.shadows.*;
	
	import alternativa.engine3d.loaders.*;
	import alternativa.engine3d.objects.*;

	import alternativa.engine3d.core.*;
	import alternativa.protocol.codec.primitive.*;
	
	import flash.display3D.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;
	/**
	 * ...
	 * @author Lexcuk
	 */
	public class Sprite3dSmoke
	{
		public var spriteArr:Array = [];
		public var speedZArr:Array = [];
		public var speedYArr:Array = [];
		
		public var spriteCount:int = 0;
		public var length:int = 10;
		public var  speedY:Number = 20;
		public var  speedZ:Number = 5;
		public var size:Number = 300;
		public var alpha:Number = 0.5;
		public var material:*;
		
		public function Sprite3dSmoke(objectContainer3D:Object3D, size:Number = 100, length:int = 10, speedY:Number = 20, speedZ:Number = 5, material:* = null ) 
		{
			
			this.size = size;
			this.speedY = speedY;
			this.speedZ = speedZ;
			
			this.length = length;
			this.material = material;
			var i:int;
			var sprite3D:Sprite3D;
			
			for (i = 0; i < length; i++) {
				objectContainer3D.addChild(sprite3D = new Sprite3D(size, size, material));
				spriteArr.push(sprite3D);
				speedZArr.push(-speedZ/2 + Math.random() * speedZ);
				speedYArr.push(speedY/2 + Math.random() * speedY);
			}
		}

		public function update(pos:Vector3D, container:Object3D):void {
			var i:int;
			var s:Sprite3D;
			for (i = 0; i < length; i++) {
				s = spriteArr[i];
				if (s.parent == null) continue;
				
				s.z += speedZArr[i];
				s.y += speedYArr[i];
				//s.x = pos.x+i / length;
			}
			s = spriteArr[spriteCount];
			container.addChild(s);
			speedZArr[spriteCount] = -speedZ / 2 + Math.random() * speedZ;
			speedYArr[spriteCount] = speedY / 2 + Math.random() * speedY;
			s.z += speedZArr[spriteCount];
			s.y += speedYArr[spriteCount];
			s.x = pos.x;
			s.y = pos.y;
			s.z = pos.z;
			spriteCount++; if (spriteCount >= length) spriteCount = 0;
		}

		public function updateAndDelete(pos:Vector3D):void {
			var i:int;
			var s:Sprite3D;
			for (i = 0; i < length; i++) {
				s = spriteArr[i];
				if (s.parent == null) {
					continue;
				}
				s.z += speedZArr[i];
				s.y += speedYArr[i];
				//s.x = pos.x+i / length;
			}
			s = spriteArr[spriteCount];
			if (s.parent != null) s.parent.removeChild(s); 
			s.x = 0;
			s.y = 0;
			s.z = 0;
			spriteCount++; if (spriteCount >= length) spriteCount = 0;
		}

		public static function makeSmokePuffBmd(color:uint):BitmapData {
			var bitMap:BitmapData = new BitmapData(64, 64, true, 0x00000000);
			var i:Number;var r:uint = color >> 16;var g:uint = color >> 8 & 0xFF;
			var b:uint = color & 0xFF;
			for (i = 0; i < 5000; i+=0.9) {
				var xi:int = i % 64; var yi:int = i / 64;
				var a:Number = Point.distance(new Point(32, 32), new Point(xi, yi));
				if (a < 1) a = 1; if (a > 32) a = 0;
				a = -a / 32 * 0xFF;
				bitMap.setPixel32(xi, yi,  a << 24 | r << 16 | g << 8 | b);
				if (i / 64 > 64) break ;
			}
			return bitMap;
		}

	}
	

}