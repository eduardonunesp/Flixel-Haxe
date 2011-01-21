Flixel-Haxe
===========

Flixel-Haxe is a port of the Flixel flash engine (http://www.flixel.org).

Master branch
-------------

The branch "master" contain a version that can target both flash and cpp. In 
this branch, the assets need to be managed manually, as detailed in 
https://github.com/domrein/Flixel-Haxe/wiki/Asset-Management


RessySupport branch
-------------------

This branch adds some functions to manage ressy assets. Moreover, the flixel 
assets are included.

### Prerequisites ###
* ressy (https://github.com/alijaya/ressy)
* hxJson2 (`haxelib install hxJson2`)

### Usage ###

To activate the ressy support, you need to compile your Haxe application with 
the `-D ressy` option. You can then use the functions `load...Ressy` instead of 
the regular `load...` functions. Take a look at the "Getting started" page of 
ressy to know how to prepare and load the assets 
(https://github.com/alijaya/ressy/wiki/Getting-Started).

You can also use the option `-D flixelAssets` to activate the assets flixel uses
in FlxPause for example. Then you have to copy the `flixelAssets` folder and the 
`flixelAssets.json` into your `bin` directory. Or you can add the 
`-D embedFlixel -resource Flixel-Haxe/flixelAssets.swf@flixelSWF -resource Flixel-Haxe/flixelAssets.json@flixelJSON` 
options, and the assets will be embedded in the compiled swf. In both cases, you
have to call `FlxG.init(CallbackFunction)` before creating your FlxGame.

At the moment, ressy doesn't seem to be able to load all the assets if they're 
not embedded.