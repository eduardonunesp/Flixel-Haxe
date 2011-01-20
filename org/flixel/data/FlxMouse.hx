package org.flixel.data;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	
	#if (ressy || flixelAssets)
	import ressy.Ressy;
	#end
	
	/**
	 * This class helps contain and track the mouse pointer in your game.
	 * Automatically accounts for parallax scrolling, etc.
	 */
	class FlxMouse
	 {
		
		/*[Embed(source="cursor.png")]*/ //var ImgDefaultCursor:Class<Bitmap>;
		
		/**
		 * Current X position of the mouse pointer in the game world.
		 */
		public var x:Int;
		/**
		 * Current Y position of the mouse pointer in the game world.
		 */
		public var y:Int;
		/**
		 * Current X position of the mouse pointer on the screen.
		 */
		public var screenX:Int;
		/**
		 * Current Y position of the mouse pointer on the screen.
		 */
		public var screenY:Int;
		/**
		 * Graphical representation of the mouse pointer.
		 */
		public var cursor:FlxSprite;
		/**
		 * Helper variable for tracking whether the mouse was just pressed or just released.
		 */
		var _current:Int;
		/**
		 * Helper variable for tracking whether the mouse was just pressed or just released.
		 */
		var _last:Int;
		/**
		 * Helper for mouse visibility.
		 */
		var _out:Bool;

		#if flixelAssets
		var _defaultCursor:BitmapData;
		#end
		
		/**
		 * Constructor.
		 */
		public function new()
		{
			x = 0;
			y = 0;
			screenX = 0;
			screenY = 0;
			_current = 0;
			_last = 0;
			cursor = null;
			_out = false;

			#if flixelAssets
			_defaultCursor = ressy.Ressy.instance.getStr("flixel.cursor").bitmapData;
			#end
		}
		
		/**
		 * Either show an existing cursor or load a new one.
		 * 
		 * @param	Graphic		The image you want to use for the cursor.
		 * @param	XOffset		The number of pixels between the mouse's screen position and the graphic's top left corner.
		 * * @param	YOffset		The number of pixels between the mouse's screen position and the graphic's top left corner. 
		 */
		public function show(?Graphic:Class<Bitmap>=null,?XOffset:Int=0,?YOffset:Int=0):Void
		{
			_out = true;
			if(Graphic != null)
				load(Graphic,XOffset,YOffset);
			else if(cursor != null)
				cursor.visible = true;
			else
				load(null);
		}

		#if (ressy || flixelAssets)
		/**
		 * Either show an existing cursor or load a new one.
		 * 
		 * @param	GraphicIns	The image you want to use for the cursor.
		 * @param	XOffset		The number of pixels between the mouse's screen position and the graphic's top left corner.
		 * * @param	YOffset		The number of pixels between the mouse's screen position and the graphic's top left corner. 
		 */
		public function showIns(?GraphicIns:BitmapData=null,?XOffset:Int=0,?YOffset:Int=0):Void
		{
			_out = true;
			if(GraphicIns != null)
				loadIns(GraphicIns,XOffset,YOffset);
			else if(cursor != null)
				cursor.visible = true;
			else
				loadIns(null);
		}
		
		/**
		 * Either show an existing cursor or load a new one.
		 * 
		 * @param	Graphic		The image you want to use for the cursor.
		 * @param	XOffset		The number of pixels between the mouse's screen position and the graphic's top left corner.
		 * @param	YOffset		The number of pixels between the mouse's screen position and the graphic's top left corner. 
		 */
		public function showRessy(?Graphic:String=null,?XOffset:Int=0,?YOffset:Int=0):Void
		{
			showIns((Graphic==null)? null : Ressy.instance.getStr(Graphic).bitmapData, XOffset, YOffset);
		}
		#end
		
		/**
		 * Hides the mouse cursor
		 */
		public function hide():Void
		{
			if(cursor != null)
			{
				cursor.visible = false;
				_out = false;
			}
		}
		
		/**
		 * Load a new mouse cursor graphic
		 * 
		 * @param	Graphic		The image you want to use for the cursor.
		 * @param	XOffset		The number of pixels between the mouse's screen position and the graphic's top left corner.
		 * * @param	YOffset		The number of pixels between the mouse's screen position and the graphic's top left corner. 
		 */
		public function load(Graphic:Class<Bitmap>,?XOffset:Int=0,?YOffset:Int=0):Void
		{
			if(Graphic == null)
			{
				#if flixelAssets
					loadIns(null, XOffset, YOffset);
					return;
				#else
					cursor = new FlxSprite(screenX, screenY);
					cursor.createGraphic(10, 10, 0xffffffff);
					var bm : BitmapData = new BitmapData(10, 10, false, 0xffffff);
					bm.setPixel(0, 0, 0x000000);
					bm.setPixel(1, 0, 0x000000);
					bm.setPixel(0, 1, 0x000000);
					bm.setPixel(2, 1, 0x000000);
					bm.setPixel(0, 2, 0x000000);
					bm.setPixel(3, 2, 0x000000);
					bm.setPixel(0, 3, 0x000000);
					bm.setPixel(4, 3, 0x000000);
					bm.setPixel(0, 4, 0x000000);
					bm.setPixel(5, 4, 0x000000);
					bm.setPixel(0, 5, 0x000000);
					bm.setPixel(6, 5, 0x000000);
					bm.setPixel(0, 6, 0x000000);
					bm.setPixel(7, 6, 0x000000);
					bm.setPixel(0, 7, 0x000000);
					bm.setPixel(3, 7, 0x000000);
					bm.setPixel(4, 7, 0x000000);
					bm.setPixel(5, 7, 0x000000);
					bm.setPixel(6, 7, 0x000000);
					bm.setPixel(0, 8, 0x000000);
					bm.setPixel(2, 8, 0x000000);
					bm.setPixel(0, 9, 0x000000);
					bm.setPixel(1, 9, 0x000000);
					cursor.pixels = bm;
				#end
			}
			else {
				cursor = new FlxSprite(screenX,screenY,Graphic);
			}
			cursor.offset.x = XOffset;
			cursor.offset.y = YOffset;
		}

		#if (ressy || flixelAssets)
		/**
		 * Load a new mouse cursor graphic
		 * 
		 * @param	GraphicIns	The image you want to use for the cursor.
		 * @param	XOffset		The number of pixels between the mouse's screen position and the graphic's top left corner.
		 * * @param	YOffset		The number of pixels between the mouse's screen position and the graphic's top left corner. 
		 */
		public function loadIns(GraphicIns:BitmapData,?XOffset:Int=0,?YOffset:Int=0):Void
		{
			#if flixelAssets
			if(GraphicIns == null)
				GraphicIns = _defaultCursor;
			#end
			cursor = new FlxSprite(screenX,screenY);
			cursor.loadGraphicIns(GraphicIns);
			cursor.offset.x = XOffset;
			cursor.offset.y = YOffset;
		}
		
		/**
		 * Load a new mouse cursor graphic
		 * 
		 * @param	Graphic		The image you want to use for the cursor.
		 * @param	XOffset		The number of pixels between the mouse's screen position and the graphic's top left corner.
		 * * @param	YOffset		The number of pixels between the mouse's screen position and the graphic's top left corner. 
		 */
		public function loadRessy(Graphic:String,?XOffset:Int=0,?YOffset:Int=0):Void
		{
			loadIns(Ressy.instance.getStr(Graphic).bitmapData, XOffset, YOffset);
		}
		#end
		
		/**
		 * Unload the current cursor graphic.  If the current cursor is visible,
		 * then the default system cursor is loaded up to replace the old one.
		 */
		public function unload():Void
		{
			if(cursor != null)
			{
				if(cursor.visible)
					load(null);
				else
					cursor = null;
			}
		}

		/**
		 * Called by the internal game loop to update the mouse pointer's position in the game world.
		 * Also updates the just pressed/just released flags.
		 * 
		 * @param	X			The current X position of the mouse in the window.
		 * @param	Y			The current Y position of the mouse in the window.
		 * @param	XScroll		The amount the game world has scrolled horizontally.
		 * @param	YScroll		The amount the game world has scrolled vertically.
		 */
		public function update(X:Int,Y:Int,XScroll:Float,YScroll:Float):Void
		{
			screenX = X;
			screenY = Y;
			x = Math.floor(screenX-FlxU.floor(XScroll));
			y = Math.floor(screenY-FlxU.floor(YScroll));
			if(cursor != null)
			{
				cursor.x = x;
				cursor.y = y;
			}
			if((_last == -1) && (_current == -1))
				_current = 0;
			else if((_last == 2) && (_current == 2))
				_current = 1;
			_last = _current;
		}
		
		/**
		 * Resets the just pressed/just released flags and sets mouse to not pressed.
		 */
		public function reset():Void
		{
			_current = 0;
			_last = 0;
		}
		
		/**
		 * Check to see if the mouse is pressed.
		 * 
		 * @return	Whether the mouse is pressed.
		 */
		public function pressed():Bool { return _current > 0; }
		
		/**
		 * Check to see if the mouse was just pressed.
		 * 
		 * @return Whether the mouse was just pressed.
		 */
		public function justPressed():Bool { return _current == 2; }
		
		/**
		 * Check to see if the mouse was just released.
		 * 
		 * @return	Whether the mouse was just released.
		 */
		public function justReleased():Bool { return _current == -1; }
		
		/**
		 * Event handler so FlxGame can toggle the mouse.
		 * 
		 * @param	event	A <code>MouseEvent</code> object.
		 */
		public function handleMouseDown(event:MouseEvent):Void
		{
			if(_current > 0) _current = 1;
			else _current = 2;
		}
		
		/**
		 * Event handler so FlxGame can toggle the mouse.
		 * 
		 * @param	event	A <code>MouseEvent</code> object.
		 */
		public function handleMouseUp(event:MouseEvent):Void
		{
			if(_current > 0) _current = -1;
			else _current = 0;
		}
		
		/**
		 * Event handler so FlxGame can toggle the mouse.
		 * 
		 * @param	event	A <code>MouseEvent</code> object.
		 */
		public function handleMouseOut(event:MouseEvent):Void
		{
			if(cursor != null)
			{
				_out = cursor.visible;
				cursor.visible = false;
			}
		}
		
		/**
		 * Event handler so FlxGame can toggle the mouse.
		 * 
		 * @param	event	A <code>MouseEvent</code> object.
		 */
		public function handleMouseOver(event:MouseEvent):Void
		{
			if(cursor != null)
				cursor.visible = _out;
		}
	}
