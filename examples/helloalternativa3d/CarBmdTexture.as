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
	//import mx.graphics.codec.*;
	
	/**
	 * ...
	 * @author Lexcuk
	 */
	public class CarBmdTexture 
	{
		
		public function CarBmdTexture() 
		{
			
		}

		/*
		public static function saveBmdAsPngFile(bmd:BitmapData):void {
			var ba:ByteArray;
			var pngEncoder:PNGEncoder = new PNGEncoder()
			ba = pngEncoder.encode(bmd);
			var f:FileReference = new FileReference();
			f.save(ba,'bmd.png');
		}
		*/

		public static function makeCarTextureBitmap():BitmapData {
			var txt:TextField = makeText('LEXCUK RACE', 40, 0x0000FF);
			var sp:Sprite = new Sprite();
			sp.graphics.lineStyle(1);
			sp.graphics.beginFill(0xFF0000);
			sp.graphics.drawRect(0, 0, 512, 512);
			sp.addChild(txt);
			txt.x = txt.y = 50;
			txt.filters = [new GlowFilter(0xFFFF00,50,50)]
			
			sp.scaleX = sp.scaleY = 0.5;
			
			sp.graphics.lineStyle(10,0x800000);
			sp.graphics.beginFill(0x80FFFF);
			sp.graphics.drawRect(10, 150, 150, 150);
			
			sp.graphics.lineStyle(10,0x800000);
			sp.graphics.beginFill(0x800000);
			sp.graphics.drawRect(15+200, 150, 150, 150);
			
			sp.graphics.lineStyle(10,0x000000);
			sp.graphics.beginFill(0x2A2A2A);
			sp.graphics.drawRect(15, 150+160, 150, 150);
			
			sp.graphics.lineStyle(5,0x000000);
			sp.graphics.endFill();
			sp.graphics.drawRect(380, 150, 100, 100);
			
			sp.graphics.lineStyle(30,0x400000);
			sp.graphics.beginFill(0xD70000);
			sp.graphics.drawCircle(150 + 160, 400, 50);
			
			var bitmapData:BitmapData = new BitmapData(512, 512);
			bitmapData.draw(sp);
			
			//saveBmdAsPngFile(bitmapData);
			
			return bitmapData;
		}

		private static function makeText(str:String = 'A', letterSize:uint = 10, letterColor:uint = 0):TextField {
			var txt:TextField = new TextField();
			txt.autoSize = TextFieldAutoSize.LEFT;
			var stringColor:String = letterColor.toString(16);
			txt.htmlText = 
			'<FONT FACE="courier" SIZE="'+letterSize+'" COLOR="#'+stringColor+'" LETTERSPACING="0" KERNING="0"><b>' +
			str + '</b></FONT></P>';
			return txt;
		}

	}

}