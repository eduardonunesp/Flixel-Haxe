package org.flixel;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.display.BlendMode;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.net.URLRequest;
//import flash.net.navigateToURL;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
//import flash.utils.getDefinitionByName;
import flash.errors.Error;
import flash.Lib;


/**
 * This class handles the 8-bit style preloader.
 */
class FlxPreloader extends MovieClip {

    /*[Embed(source="data/logo.png")]*/ var ImgLogo:Class<Bitmap>;
    /*[Embed(source="data/logo_corners.png")]*/ var ImgLogoCorners:Class<Bitmap>;
    /*[Embed(source="data/logo_light.png")]*/ var ImgLogoLight:Class<Bitmap>;

    /**
     * @private
     */
    var _init:Bool;
    /**
     * @private
     */
    var _buffer:Sprite;
    /**
     * @private
     */
    var _bmpBar:Bitmap;
    /**
     * @private
     */
    var _text:TextField;
    /**
     * Useful for storing "real" stage width if you're scaling your preloader graphics.
     */
    var _width:Int;
    /**
     * Useful for storing "real" stage height if you're scaling your preloader graphics.
     */
    var _height:Int;
    /**
     * @private
     */
    var _logo:Bitmap;
    /**
     * @private
     */
    var _logoGlow:Bitmap;
    /**
     * @private
     */
    var _min:Int;

    /**
     * This should always be the name of your main project/document class (e.g. GravityHook).
     */
    public var className:String;
    /**
     * Set this to your game's URL to use built-in site-locking.
     */
    public var myURL:String;
    /**
     * Change this if you want the flixel logo to show for more or less time.  Default value is 0 seconds.
     */
    public var minDisplayTime:Float;

    /**
     * Constructor
     */
    public function new()
    {
        super();
        minDisplayTime = 0;

        stop();
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;

        //Check if we are on debug or release mode and set _DEBUG accordingly
        try
        {
            throw new Error("Setting global debug flag...");
        }
        catch(e:Error)
        {
            var re:EReg = ~/\[.*:[0-9]+\]/;
            FlxG.debug = re.match(e.getStackTrace());
        }

        var tmp:Bitmap;
        if(!FlxG.debug && (myURL != null) && (root.loaderInfo.url.indexOf(myURL) < 0))
        {
            tmp = new Bitmap(new BitmapData(stage.stageWidth,stage.stageHeight,true,0xFFFFFFFF));
            addChild(tmp);

            var fmt:TextFormat = new TextFormat();
            fmt.color = 0x000000;
            fmt.size = 16;
            fmt.align = TextFormatAlign.CENTER;
            fmt.bold = true;
            fmt.font = "Arial";

            var txt:TextField = new TextField();
            txt.width = tmp.width-16;
            txt.height = tmp.height-16;
            txt.y = 8;
            txt.multiline = true;
            txt.wordWrap = true;
            txt.embedFonts = false;
            txt.defaultTextFormat = fmt;
            txt.text = "Hi there!  It looks like somebody copied this game without my permission.  Just click anywhere, or copy-paste this URL into your browser.\n\n"+myURL+"\n\nto play the game at my site.  Thanks, and have fun!";
            addChild(txt);

            txt.addEventListener(MouseEvent.CLICK,goToMyURL);
            tmp.addEventListener(MouseEvent.CLICK,goToMyURL);
            return;
        }
        _init = false;
        addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }

    function goToMyURL(?event:MouseEvent=null):Void
    {
        Lib.getURL(new URLRequest("http://"+myURL));
    }

    function onEnterFrame(event:Event):Void
    {
        if(!_init)
        {
            if((stage.stageWidth <= 0) || (stage.stageHeight <= 0))
                return;
            create();
            _init = true;
        }
        var i:Int;
        graphics.clear();
        var time:Int = Lib.getTimer();
        if((framesLoaded >= totalFrames) && (time > _min))
        {
            removeEventListener(Event.ENTER_FRAME, onEnterFrame);
            nextFrame();
            var mainClass:Class<Dynamic> = Type.resolveClass(className);
            if(mainClass != null)
            {
                var app:Dynamic = Type.createInstance(mainClass, []);
                addChild(cast( app, DisplayObject));
            }
            removeChild(_buffer);
        }
        else
        {
            var percent:Int = Std.int(root.loaderInfo.bytesLoaded/root.loaderInfo.bytesTotal);
            if((_min > 0) && (percent > time/_min))
                percent = Std.int(time/_min);
            update(percent);
        }
    }

    /**
     * Override this to create your own preloader objects.
     * Highly recommended you also override update()!
     */
    function create():Void
    {
        _min = 0;
        if(!FlxG.debug)
            _min = Std.int(minDisplayTime*1000);
        _buffer = new Sprite();
        _buffer.scaleX = 2;
        _buffer.scaleY = 2;
        addChild(_buffer);
        _width = Std.int(stage.stageWidth/_buffer.scaleX);
        _height = Std.int(stage.stageHeight/_buffer.scaleY);
        _buffer.addChild(new Bitmap(new BitmapData(_width,_height,false,0x00345e)));
        var b:Bitmap = Type.createInstance(ImgLogoLight, []);
        b.smoothing = true;
        b.width = b.height = _height;
        b.x = (_width-b.width)/2;
        _buffer.addChild(b);
        _bmpBar = new Bitmap(new BitmapData(1,7,false,0x5f6aff));
        _bmpBar.x = 4;
        _bmpBar.y = _height-11;
        _buffer.addChild(_bmpBar);
        _text = new TextField();
        _text.defaultTextFormat = new TextFormat("Arial",8,0x5f6aff);
        _text.embedFonts = false;
        _text.selectable = false;
        _text.multiline = false;
        _text.x = 2;
        _text.y = _bmpBar.y - 11;
        _text.width = 80;
        _buffer.addChild(_text);
        _logo = Type.createInstance(ImgLogo, []);
        _logo.scaleX = _logo.scaleY = _height/8;
        _logo.x = (_width-_logo.width)/2;
        _logo.y = (_height-_logo.height)/2;
        _buffer.addChild(_logo);
        _logoGlow = Type.createInstance(ImgLogo, []);
        _logoGlow.smoothing = true;
        _logoGlow.blendMode = BlendMode.SCREEN;
        _logoGlow.scaleX = _logoGlow.scaleY = _height/8;
        _logoGlow.x = (_width-_logoGlow.width)/2;
        _logoGlow.y = (_height-_logoGlow.height)/2;
        _buffer.addChild(_logoGlow);
        b = Type.createInstance(ImgLogoCorners, []);
        b.smoothing = true;
        b.width = _width;
        b.height = _height;
        _buffer.addChild(b);
        b = new Bitmap(new BitmapData(_width,_height,false,0xffffff));
        var i:Int = 0;
        while(i < _height)
        {
            var j:Int = 0;
            while(j < _width)
            {
                b.bitmapData.setPixel(j,i,0);
                j++;
            }
            i += 2;
        }
        b.blendMode = BlendMode.OVERLAY;
        b.alpha = 0.25;
        _buffer.addChild(b);
    }

    /**
     * Override this function to manually update the preloader.
     * 
     * @param Percent  How much of the program has loaded.
     */
    function update(Percent:Float):Void
    {
        _bmpBar.scaleX = Percent*(_width-8);
        _text.text = "FLX v"+FlxG.LIBRARY_MAJOR_VERSION+"."+FlxG.LIBRARY_MINOR_VERSION+" "+FlxU.floor(Percent*100)+"%";
        _text.setTextFormat(_text.defaultTextFormat);
        if(Percent < 0.1)
        {
            _logoGlow.alpha = 0;
            _logo.alpha = 0;
        }
        else if(Percent < 0.15)
        {
            _logoGlow.alpha = FlxU.random(false);
            _logo.alpha = 0;
        }
        else if(Percent < 0.2)
        {
            _logoGlow.alpha = 0;
            _logo.alpha = 0;
        }
        else if(Percent < 0.25)
        {
            _logoGlow.alpha = 0;
            _logo.alpha = FlxU.random(false);
        }
        else if(Percent < 0.7)
        {
            _logoGlow.alpha = (Percent-0.45)/0.45;
            _logo.alpha = 1;
        }
        else if((Percent > 0.8) && (Percent < 0.9))
        {
            _logoGlow.alpha = 1-(Percent-0.8)/0.1;
            _logo.alpha = 0;
        }
        else if(Percent > 0.9)
        {
            _buffer.alpha = 1-(Percent-0.9)/0.1;
        }
    }
}
