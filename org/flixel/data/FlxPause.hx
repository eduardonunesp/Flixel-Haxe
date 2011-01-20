package org.flixel.data;

	import flash.display.Bitmap;
	import flash.display.BitmapData;

	import org.flixel.FlxGroup;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;

	/**
	 * This is the default flixel pause screen.
	 * It can be overridden with your own <code>FlxLayer</code> object.
	 */
	class FlxPause extends FlxGroup {
		
		/*[Embed(source="key_minus.png")]*/ //var ImgKeyMinus:Class<Bitmap>;
		/*[Embed(source="key_plus.png")]*/ //var ImgKeyPlus:Class<Bitmap>;
		/*[Embed(source="key_0.png")]*/ //var ImgKey0:Class<Bitmap>;
		/*[Embed(source="key_p.png")]*/ //var ImgKeyP:Class<Bitmap>;

		/**
		 * Constructor.
		 */
		public function new()
		{
			super();
			#if (flixelAssets || ressy)
			var r = ressy.Ressy.instance;
			#end
			scrollFactor.x = 0;
			scrollFactor.y = 0;
			var w:Int = 80;
			var h:Int = 92;
			x = (FlxG.width-w)/2;
			y = (FlxG.height-h)/2;
			add((new FlxSprite()).createGraphic(w,h,0xaa000000,true),true);			
			(cast( add(new FlxText(0,0,w,"this game is"),true), FlxText)).alignment = "center";
			add((new FlxText(0,10,w,"PAUSED")).setFormat(null,16,0xffffff,"center"),true);
			
			var s = new FlxSprite(4, 36);
			#if !flixelAssets
				var bm : BitmapData;
			#end
			
			#if flixelAssets
				s.loadGraphicIns(r.getStr("flixel.key_p").bitmapData);
			#else
				s.createGraphic(10, 11, 0xffffffff);
				bm = new BitmapData(10, 11, false, 0xffffff);
				bm.setPixel32(0, 0, 0x00000000);
				bm.setPixel32(9, 0, 0x00000000);
				bm.setPixel32(2, 2, 0x00000000);
				bm.setPixel32(3, 2, 0x00000000);
				bm.setPixel32(4, 2, 0x00000000);
				bm.setPixel32(5, 2, 0x00000000);
				bm.setPixel32(6, 2, 0x00000000);
				bm.setPixel32(2, 3, 0x00000000);
				bm.setPixel32(3, 3, 0x00000000);
				bm.setPixel32(6, 3, 0x00000000);
				bm.setPixel32(7, 3, 0x00000000);
				bm.setPixel32(2, 4, 0x00000000);
				bm.setPixel32(3, 4, 0x00000000);
				bm.setPixel32(6, 4, 0x00000000);
				bm.setPixel32(7, 4, 0x00000000);
				bm.setPixel32(2, 5, 0x00000000);
				bm.setPixel32(3, 5, 0x00000000);
				bm.setPixel32(6, 5, 0x00000000);
				bm.setPixel32(7, 5, 0x00000000);
				bm.setPixel32(2, 6, 0x00000000);
				bm.setPixel32(3, 6, 0x00000000);
				bm.setPixel32(4, 6, 0x00000000);
				bm.setPixel32(5, 6, 0x00000000);
				bm.setPixel32(6, 6, 0x00000000);
				bm.setPixel32(2, 7, 0x00000000);
				bm.setPixel32(3, 7, 0x00000000);
				bm.setPixel32(2, 8, 0x00000000);
				bm.setPixel32(3, 8, 0x00000000);
				bm.setPixel32(0, 10, 0x00000000);
				bm.setPixel32(9, 10, 0x00000000);
				s.pixels = bm;
			#end
			add(s,true);
			add(new FlxText(16,36,w-16,"Pause Game"),true);
			
			s = new FlxSprite(4, 50);
			#if flixelAssets
				s.loadGraphicIns(r.getStr("flixel.key_0").bitmapData);
			#else
				s.createGraphic(10, 11, 0xffffffff);
				bm = new BitmapData(10, 11, false, 0xffffff);
				bm.setPixel32(0, 0, 0x00000000);
				bm.setPixel32(9, 0, 0x00000000);
				bm.setPixel32(3, 2, 0x00000000);
				bm.setPixel32(4, 2, 0x00000000);
				bm.setPixel32(5, 2, 0x00000000);
				bm.setPixel32(6, 2, 0x00000000);
				bm.setPixel32(2, 3, 0x00000000);
				bm.setPixel32(3, 3, 0x00000000);
				bm.setPixel32(6, 3, 0x00000000);
				bm.setPixel32(7, 3, 0x00000000);
				bm.setPixel32(2, 4, 0x00000000);
				bm.setPixel32(3, 4, 0x00000000);
				bm.setPixel32(5, 4, 0x00000000);
				bm.setPixel32(6, 4, 0x00000000);
				bm.setPixel32(7, 4, 0x00000000);
				bm.setPixel32(2, 5, 0x00000000);
				bm.setPixel32(3, 5, 0x00000000);
				bm.setPixel32(4, 5, 0x00000000);
				bm.setPixel32(6, 5, 0x00000000);
				bm.setPixel32(7, 5, 0x00000000);
				bm.setPixel32(2, 6, 0x00000000);
				bm.setPixel32(3, 6, 0x00000000);
				bm.setPixel32(6, 6, 0x00000000);
				bm.setPixel32(7, 6, 0x00000000);
				bm.setPixel32(2, 7, 0x00000000);
				bm.setPixel32(3, 7, 0x00000000);
				bm.setPixel32(6, 7, 0x00000000);
				bm.setPixel32(7, 7, 0x00000000);
				bm.setPixel32(3, 8, 0x00000000);
				bm.setPixel32(4, 8, 0x00000000);
				bm.setPixel32(5, 8, 0x00000000);
				bm.setPixel32(6, 8, 0x00000000);
				bm.setPixel32(0, 10, 0x00000000);
				bm.setPixel32(9, 10, 0x00000000);
				s.pixels = bm;
			#end
			add(s,true);
			add(new FlxText(16,50,w-16,"Mute Sound"),true);
			
			s = new FlxSprite(4, 64);
			#if flixelAssets
				s.loadGraphicIns(r.getStr("flixel.key_minus").bitmapData);
			#else
				s.createGraphic(10, 11, 0xffffffff);
				bm = new BitmapData(10, 11, false, 0xffffff);
				bm.setPixel32(0, 0, 0x00000000);
				bm.setPixel32(9, 0, 0x00000000);
				bm.setPixel32(3, 5, 0x00000000);
				bm.setPixel32(4, 5, 0x00000000);
				bm.setPixel32(5, 5, 0x00000000);
				bm.setPixel32(6, 5, 0x00000000);
				bm.setPixel32(0, 10, 0x00000000);
				bm.setPixel32(9, 10, 0x00000000);
				s.pixels = bm;
			#end
			add(s,true);
			add(new FlxText(16,64,w-16,"Sound Down"),true);
			
			s = new FlxSprite(4, 78);
			#if flixelAssets
			s.loadGraphicIns(r.getStr("flixel.key_plus").bitmapData);
			#else
				s.createGraphic(10, 11, 0xffffffff);
				bm = new BitmapData(10, 11, false, 0xffffff);
				bm.setPixel32(0, 0, 0x00000000);
				bm.setPixel32(9, 0, 0x00000000);
				bm.setPixel32(4, 3, 0x00000000);
				bm.setPixel32(5, 3, 0x00000000);
				bm.setPixel32(4, 4, 0x00000000);
				bm.setPixel32(5, 4, 0x00000000);
				bm.setPixel32(2, 5, 0x00000000);
				bm.setPixel32(3, 5, 0x00000000);
				bm.setPixel32(4, 5, 0x00000000);
				bm.setPixel32(5, 5, 0x00000000);
				bm.setPixel32(6, 5, 0x00000000);
				bm.setPixel32(7, 5, 0x00000000);
				bm.setPixel32(4, 6, 0x00000000);
				bm.setPixel32(5, 6, 0x00000000);
				bm.setPixel32(4, 7, 0x00000000);
				bm.setPixel32(5, 7, 0x00000000);
				bm.setPixel32(0, 10, 0x00000000);
				bm.setPixel32(9, 10, 0x00000000);
				s.pixels = bm;
			#end
			add(s,true);
			add(new FlxText(16,78,w-16,"Sound Up"),true);
		}
	}
