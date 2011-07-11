package org.flixel;

import flash.net.URLRequest;
//import flash.net.navigateToURL;
//import flash.utils.getDefinitionByName;
//import flash.utils.getQualifiedClassName;
import flash.Lib;

class FlxU
{
    /**
     * Internal random number calculation helpers.
     */
    public function new() { }

    public static var seed(getSeed, setSeed) : Float;
    /**
     * Internal random number calculation helpers.
     */
    static var _seed:Float;
    /**
     * Internal random number calculation helpers.
     */
    static var _originalSeed:Float;
    /**
     * Helps to eliminate false collisions and/or rendering glitches caused by rounding errors
     */
    public static var roundingError:Float = 0.0000001;
    /**
     * The global quad tree (stored here since it is used primarily by FlxU functions).
     * Set this to null to force it to refresh on the next collide.
     */
    public static var quadTree:FlxQuadTree;
    /**
     * This variable stores the dimensions of the root of the quad tree.
     * This is the eligible game collision space.
     */
    public static var quadTreeBounds:FlxRect;
    /**
     * Controls the granularity of the quad tree.  Default is 3 (decent performance on large and small worlds).
     */
    public static var quadTreeDivisions:Int = 3;

    /**
     * Opens a web page in a new tab or window.
     * 
     * @param URL  The address of the web page.
     */
    public static function openURL(URL:String):Void
    {
        //flash.Lib.getURL(new URLRequest(URL), "_blank");
    }

    public static function abs(N:Float):Float
    {
        return (N>0)?N:-N;
    }

    public static function floor(N:Float):Int
    {
        var n:Int = Math.floor(N);
        return (N>0)?(n):((n!=N)?(n-1):(n));
    }

    public static function ceil(N:Float):Int
    {
        var n:Int = Math.floor(N);
        return (N>0)?((n!=N)?(n+1):(n)):(n);
    }

    /**
     * Generate a pseudo-random number.
     * 
     * @param UseGlobalSeed  Whether or not to use the stored FlxG.seed value to calculate it.
     * 
     * @return A pseudo-random Number object.
     */
    public static function random(?UseGlobalSeed:Bool=true):Float
    {
        if(UseGlobalSeed && !Math.isNaN(_seed))
        {
            var random:Float = randomize(_seed);
            _seed = mutate(_seed,random);
            return random;
        }
        else
            return Math.random();
    }

    /**
     * Generate a pseudo-random number.
     * 
     * @param Seed  The number to use to generate a new random value.
     * 
     * @return A pseudo-random Number object.
     */
    public static function randomize(Seed:Float):Float
    {
        return ((69621 * Math.floor(Seed * 0x7FFFFFFF)) % 0x7FFFFFFF) / 0x7FFFFFFF;
    }

    /**
     * Mutates a seed or other number, useful when combined with <code>randomize()</code>.
     * 
     * @param Seed  The number to mutate.
     * @param Mutator  The value to use in the mutation.
     * 
     * @return A predictably-altered version of the Seed.
     */
    public static function mutate(Seed:Float,Mutator:Float):Float
    {
        Seed += Mutator;
        if(Seed > 1) Seed -= Math.floor(Seed);
        return Seed;
    }

    /**
     * Set <code>seed</code> to a number between 0 and 1 if you want
     * <code>FlxG.random()</code> to generate a predictable series of numbers.
     * NOTE: reading the seed will return the original value passed in,
     * not the current mutation.
     */
    public static function getSeed():Float{
        return _originalSeed;
    }

    /**
     * @private
     */
    public static function setSeed(Seed:Float):Float{
        _seed = Seed;
        _originalSeed = _seed;
        return Seed;
    }

    /**
     * Useful for finding out how long it takes to execute specific blocks of code.
     * 
     * @return A <code>Int</code> to be passed to <code>FlxU.endProfile()</code>.
     */
    public static function startProfile():Int
    {
        return Lib.getTimer();
        //Is this just junk?
        //   retur
        //   _elapsed = (t-_total)/1000;
        //   if(_created)
        //    _console.lastElapsed = _elapsed;
        //   _total = t;
    }

    /**
     * Useful for finding out how long it takes to execute specific blocks of code.
     * 
     * @param Start A <code>Int</code> created by <code>FlxU.startProfile()</code>.
     * @param Name Optional tag (for debug console display).  Default value is "Profiler".
     * @param Log  Whether or not to log this elapsed time in the debug console.
     * 
     * @return A <code>Int</code> to be passed to <code>FlxU.endProfile()</code>.
     */
    public static function endProfile(Start:Int,?Name:String="Profiler",?Log:Bool=true):Int
    {
        var t:Int = Lib.getTimer();
        if(Log) 
        {
#if flash            
            FlxG.log(Name+": "+((t-Start)/1000)+"s");
#else
            //FlxG::log(Name+": "+((t-Start)/1000)+"s");
#end
        }

        return t;
    }

    /**
     * Rotates a point in 2D space around another point by the given angle.
     * 
     * @param X  The X coordinate of the point you want to rotate.
     * @param Y  The Y coordinate of the point you want to rotate.
     * @param PivotX The X coordinate of the point you want to rotate around.
     * @param PivotY The Y coordinate of the point you want to rotate around.
     * @param Angle Rotate the point by this many degrees.
     * @param P  Optional <code>FlxPoint</code> to store the results in.
     * 
     * @return A <code>FlxPoint</code> containing the coordinates of the rotated point.
     */
    public static function rotatePoint(X:Float, Y:Float, PivotX:Float, PivotY:Float, Angle:Float,?P:FlxPoint=null):FlxPoint
    {
        if(P == null) P = new FlxPoint();
        var radians:Float = -Angle / 180 * Math.PI;
        var dx:Float = X-PivotX;
        var dy:Float = PivotY-Y;
        P.x = PivotX + Math.cos(radians)*dx - Math.sin(radians)*dy;
        P.y = PivotY - (Math.sin(radians)*dx + Math.cos(radians)*dy);
        return P;
    }

    /**
     * Calculates the angle between a point and the origin (0,0).
     * 
     * @param X  The X coordinate of the point.
     * @param Y  The Y coordinate of the point.
     * 
     * @return The angle in degrees.
     */
    public static function getAngle(X:Float, Y:Float):Float
    {
        return Math.atan2(Y,X) * 180 / Math.PI;
    }

    /**
     * Get the <code>String</code> name of any <code>Object</code>.
     * 
     * @param Obj  The <code>Object</code> object in question.
     * @param Simple Returns only the class name, not the package or packages.
     * 
     * @return The name of the <code>Class</code> as a <code>String</code> object.
     */
    public static function getClassName(Obj:Dynamic,?Simple:Bool=false):String
    {
        var s:String = Type.getClassName(Obj);
        //trace("TODO: makes sure the class name is being parsed correctly.");
        s = StringTools.replace(s, "::", ".");
        if(Simple)
            s = s.substr(s.lastIndexOf(".")+1);
        return s;
    }

    /**
     * Look up a <code>Class</code> object by its string name.
     * 
     * @param Name The <code>String</code> name of the <code>Class</code> you are interested in.
     * 
     * @return A <code>Class</code> object.
     */
    public static function getClass(Name:String):Class<Dynamic>
    {
        return Type.resolveClass(Name);
    }

    /**
     * A tween-like function that takes a starting velocity
     * and some other factors and returns an altered velocity.
     * 
     * @param Velocity  Any component of velocity (e.g. 20).
     * @param Acceleration Rate at which the velocity is changing.
     * @param Drag   Really kind of a deceleration, this is how much the velocity changes if Acceleration is not set.
     * @param Max    An absolute value cap for the velocity.
     * 
     * @return The altered Velocity value.
     */
    public static function computeVelocity(Velocity:Float, ?Acceleration:Float=0, ?Drag:Float=0, ?Max:Float=10000):Float
    {
        if(Acceleration != 0)
        {
#if flash
            Velocity += Acceleration*FlxG.elapsed;
#else
            //Velocity += Acceleration*FlxG.elapsed;
#end
        }
        else if(Drag != 0)
        {
#if flash            
            var d:Float = Drag*FlxG.elapsed;
#else            
            var d:Float = 0; //Drag*FlxG.elapsed;
#end           
            if(Velocity - d > 0)
                Velocity -= d;
            else if(Velocity + d < 0)
                Velocity += d;
            else
                Velocity = 0;
        }
        if((Velocity != 0) && (Max != 10000))
        {
            if(Velocity > Max)
                Velocity = Max;
            else if(Velocity < -Max)
                Velocity = -Max;
        }
        return Velocity;
    }

    /**
     * Call this function to specify a more efficient boundary for your game world.
     * This boundary is used by <code>overlap()</code> and <code>collide()</code>, so it
     * can't hurt to have it be the right size!  Flixel will invent a size for you, but
     * it's pretty huge - 256x the size of the screen, whatever that may be.
     * Leave width and height empty if you want to just update the game world's position.
     * 
     * @param X   The X-coordinate of the left side of the game world.
     * @param Y   The Y-coordinate of the top of the game world.
     * @param Width  Desired width of the game world.
     * @param Height  Desired height of the game world.
     * @param Divisions Pass a non-zero value to set <code>quadTreeDivisions</code>.  Default value is 3.
     */
    public static function setWorldBounds(?X:Float=0, ?Y:Float=0, ?Width:Float=0, ?Height:Float=0, ?Divisions:Int=3):Void
    {
        if(quadTreeBounds == null)
            quadTreeBounds = new FlxRect();
        quadTreeBounds.x = X;
        quadTreeBounds.y = Y;
        if(Width > 0)
            quadTreeBounds.width = Width;
        if(Height > 0)
            quadTreeBounds.height = Height;
        if(Divisions > 0)
            quadTreeDivisions = Divisions;
    }

    /**
     * Call this function to see if one <code>FlxObject</code> overlaps another.
     * Can be called with one object and one group, or two groups, or two objects,
     * whatever floats your boat!  It will put everything into a quad tree and then
     * check for overlaps.  For maximum performance try bundling a lot of objects
     * together using a <code>FlxGroup</code> (even bundling groups together!)
     * NOTE: does NOT take objects' scrollfactor into account.
     * 
     * @param Object1  The first object or group you want to check.
     * @param Object2  The second object or group you want to check.  If it is the same as the first, flixel knows to just do a comparison within that group.
     * @param Callback A function with two <code>FlxObject</code> parameters - e.g. <code>myOverlapFunction(Object1:FlxObject,Object2:FlxObject);</code>  If no function is provided, <code>FlxQuadTree</code> will call <code>kill()</code> on both objects.
     */
    public static function overlap(Object1:FlxObject,Object2:FlxObject,?Callback:Dynamic=null):Bool
    {
        if( (Object1 == null) || !Object1.exists ||
                (Object2 == null) || !Object2.exists )
            return false;
        quadTree = new FlxQuadTree(quadTreeBounds.x,quadTreeBounds.y,quadTreeBounds.width,quadTreeBounds.height);
        quadTree.add(Object1,FlxQuadTree.A_LIST);
        if(Object1 == Object2)
            return quadTree.overlap(false,Callback);
        quadTree.add(Object2,FlxQuadTree.B_LIST);
        return quadTree.overlap(true,Callback);
    }

    /**
     * Call this function to see if one <code>FlxObject</code> collides with another.
     * Can be called with one object and one group, or two groups, or two objects,
     * whatever floats your boat!  It will put everything into a quad tree and then
     * check for collisions.  For maximum performance try bundling a lot of objects
     * together using a <code>FlxGroup</code> (even bundling groups together!)
     * NOTE: does NOT take objects' scrollfactor into account.
     * 
     * @param Object1  The first object or group you want to check.
     * @param Object2  The second object or group you want to check.  If it is the same as the first, flixel knows to just do a comparison within that group.
     */
    public static function collide(Object1:FlxObject,Object2:FlxObject):Bool
    {
        if( (Object1 == null) || !Object1.exists ||
                (Object2 == null) || !Object2.exists )
            return false;
        quadTree = new FlxQuadTree(quadTreeBounds.x,quadTreeBounds.y,quadTreeBounds.width,quadTreeBounds.height);
        quadTree.add(Object1,FlxQuadTree.A_LIST);
        var match:Bool = Object1 == Object2;
        if(!match)
            quadTree.add(Object2,FlxQuadTree.B_LIST);
        var cx:Bool = quadTree.overlap(!match,solveXCollision);
        var cy:Bool = quadTree.overlap(!match,solveYCollision);
        return cx || cy;   
    }

    /**
     * This quad tree callback function can be used externally as well.
     * Takes two objects and separates them along their X axis (if possible/reasonable).
     * 
     * @param Object1  The first object or group you want to check.
     * @param Object2  The second object or group you want to check.
     */
    public static function solveXCollision(Object1:FlxObject, Object2:FlxObject):Bool
    {
        //Avoid messed up collisions ahead of time
        var o1:Float = Object1.colVector.x;
        var o2:Float = Object2.colVector.x;
        if(o1 == o2)
            return false;

        //Give the objects a heads up that we're about to resolve some collisions
        Object1.preCollide(Object2);
        Object2.preCollide(Object1);

        //Basic resolution variables
        var f1:Bool;
        var f2:Bool;
        var overlap:Float;
        var hit:Bool = false;
        var p1hn2:Bool;

        //Directional variables
        var obj1Stopped:Bool = o1 == 0;
        var obj1MoveNeg:Bool = o1 < 0;
        var obj1MovePos:Bool = o1 > 0;
        var obj2Stopped:Bool = o2 == 0;
        var obj2MoveNeg:Bool = o2 < 0;
        var obj2MovePos:Bool = o2 > 0;

        //Offset loop variables
        var i1:Int;
        var i2:Int;
        var obj1Hull:FlxRect = Object1.colHullX;
        var obj2Hull:FlxRect = Object2.colHullX;
        var co1:Array<FlxPoint> = Object1.colOffsets;
        var co2:Array<FlxPoint> = Object2.colOffsets;
        var l1:Int = co1.length;
        var l2:Int = co2.length;
        var ox1:Float;
        var oy1:Float;
        var ox2:Float;
        var oy2:Float;
        var r1:Float;
        var r2:Float;
        var sv1:Float;
        var sv2:Float;

        //Decide based on object's movement patterns if it was a right-side or left-side collision
        p1hn2 = ((obj1Stopped && obj2MoveNeg) || (obj1MovePos && obj2Stopped) || (obj1MovePos && obj2MoveNeg) || //the obvious cases
                (obj1MoveNeg && obj2MoveNeg && (((o1>0)?o1:-o1) < ((o2>0)?o2:-o2))) || //both moving left, obj2 overtakes obj1
                (obj1MovePos && obj2MovePos && (((o1>0)?o1:-o1) > ((o2>0)?o2:-o2))) ); //both moving right, obj1 overtakes obj2

        //Check to see if these objects allow these collisions
        if(p1hn2?(!Object1.collideRight || !Object2.collideLeft):(!Object1.collideLeft || !Object2.collideRight))
            return false;

        //this looks insane, but we're just looping through collision offsets on each object
        for(i1 in 0...l1)
        {
            ox1 = co1[i1].x;
            oy1 = co1[i1].y;
            obj1Hull.x += ox1;
            obj1Hull.y += oy1;
            for(i2 in 0...l2)
            {
                ox2 = co2[i2].x;
                oy2 = co2[i2].y;
                obj2Hull.x += ox2;
                obj2Hull.y += oy2;

                //See if it's a actually a valid collision
                if( (obj1Hull.x + obj1Hull.width  < obj2Hull.x + roundingError) ||
                        (obj1Hull.x + roundingError > obj2Hull.x + obj2Hull.width) ||
                        (obj1Hull.y + obj1Hull.height < obj2Hull.y + roundingError) ||
                        (obj1Hull.y + roundingError > obj2Hull.y + obj2Hull.height) )
                {
                    obj2Hull.x -= ox2;
                    obj2Hull.y -= oy2;
                    continue;
                }

                //Calculate the overlap between the objects
                if(p1hn2)
                {
                    if(obj1MoveNeg)
                        r1 = obj1Hull.x + Object1.colHullY.width;
                    else
                        r1 = obj1Hull.x + obj1Hull.width;
                    if(obj2MoveNeg)
                        r2 = obj2Hull.x;
                    else
                        r2 = obj2Hull.x + obj2Hull.width - Object2.colHullY.width;
                }
                else
                {
                    if(obj2MoveNeg)
                        r1 = -obj2Hull.x - Object2.colHullY.width;
                    else
                        r1 = -obj2Hull.x - obj2Hull.width;
                    if(obj1MoveNeg)
                        r2 = -obj1Hull.x;
                    else
                        r2 = -obj1Hull.x - obj1Hull.width + Object1.colHullY.width;
                }
                overlap = r1 - r2;

                //Last chance to skip out on a bogus collision resolution
                if( (overlap == 0) ||
                        ((!Object1.fixed && ((overlap>0)?overlap:-overlap) > obj1Hull.width*0.8)) ||
                        ((!Object2.fixed && ((overlap>0)?overlap:-overlap) > obj2Hull.width*0.8)) )
                {
                    obj2Hull.x -= ox2;
                    obj2Hull.y -= oy2;
                    continue;
                }
                hit = true;

                //Adjust the objects according to their flags and stuff
                sv1 = Object2.velocity.x;
                sv2 = Object1.velocity.x;
                if(!Object1.fixed && Object2.fixed)
                {
                    if(Object1._group)
                        Object1.reset(Object1.x - overlap,Object1.y);
                    else
                        Object1.x -= overlap;
                }
                else if(Object1.fixed && !Object2.fixed)
                {
                    if(Object2._group)
                        Object2.reset(Object2.x + overlap,Object2.y);
                    else
                        Object2.x += overlap;
                }
                else if(!Object1.fixed && !Object2.fixed)
                {
                    overlap /= 2;
                    if(Object1._group)
                        Object1.reset(Object1.x - overlap,Object1.y);
                    else
                        Object1.x -= overlap;
                    if(Object2._group)
                        Object2.reset(Object2.x + overlap,Object2.y);
                    else
                        Object2.x += overlap;
                    sv1 /= 2;
                    sv2 /= 2;
                }
                if(p1hn2)
                {
                    Object1.hitRight(Object2,sv1);
                    Object2.hitLeft(Object1,sv2);
                }
                else
                {
                    Object1.hitLeft(Object2,sv1);
                    Object2.hitRight(Object1,sv2);
                }

                //Adjust collision hulls if necessary
                if(!Object1.fixed && (overlap != 0))
                {
                    if(p1hn2)
                        obj1Hull.width -= overlap;
                    else
                    {
                        obj1Hull.x -= overlap;
                        obj1Hull.width += overlap;
                    }
                    Object1.colHullY.x -= overlap;
                }
                if(!Object2.fixed && (overlap != 0))
                {
                    if(p1hn2)
                    {
                        obj2Hull.x += overlap;
                        obj2Hull.width -= overlap;
                    }
                    else
                        obj2Hull.width += overlap;
                    Object2.colHullY.x += overlap;
                }
                obj2Hull.x -= ox2;
                obj2Hull.y -= oy2;
            }
            obj1Hull.x -= ox1;
            obj1Hull.y -= oy1;
        }

        return hit;
    }

    /**
     * This quad tree callback function can be used externally as well.
     * Takes two objects and separates them along their Y axis (if possible/reasonable).
     * 
     * @param Object1  The first object or group you want to check.
     * @param Object2  The second object or group you want to check.
     */
    public static function solveYCollision(Object1:FlxObject, Object2:FlxObject):Bool
    {
        //Avoid messed up collisions ahead of time
        var o1:Float = Object1.colVector.y;
        var o2:Float = Object2.colVector.y;
        if(o1 == o2)
            return false;

        //Give the objects a heads up that we're about to resolve some collisions
        Object1.preCollide(Object2);
        Object2.preCollide(Object1);

        //Basic resolution variables
        var overlap:Float;
        var hit:Bool = false;
        var p1hn2:Bool;

        //Directional variables
        var obj1Stopped:Bool = o1 == 0;
        var obj1MoveNeg:Bool = o1 < 0;
        var obj1MovePos:Bool = o1 > 0;
        var obj2Stopped:Bool = o2 == 0;
        var obj2MoveNeg:Bool = o2 < 0;
        var obj2MovePos:Bool = o2 > 0;

        //Offset loop variables
        var i1:Int;
        var i2:Int;
        var obj1Hull:FlxRect = Object1.colHullY;
        var obj2Hull:FlxRect = Object2.colHullY;
        var co1:Array<FlxPoint> = Object1.colOffsets;
        var co2:Array<FlxPoint> = Object2.colOffsets;
        var l1:Int = co1.length;
        var l2:Int = co2.length;
        var ox1:Float;
        var oy1:Float;
        var ox2:Float;
        var oy2:Float;
        var r1:Float;
        var r2:Float;
        var sv1:Float;
        var sv2:Float;

        //Decide based on object's movement patterns if it was a top or bottom collision
        p1hn2 = ((obj1Stopped && obj2MoveNeg) || (obj1MovePos && obj2Stopped) || (obj1MovePos && obj2MoveNeg) || //the obvious cases
                (obj1MoveNeg && obj2MoveNeg && (((o1>0)?o1:-o1) < ((o2>0)?o2:-o2))) || //both moving up, obj2 overtakes obj1
                (obj1MovePos && obj2MovePos && (((o1>0)?o1:-o1) > ((o2>0)?o2:-o2))) ); //both moving down, obj1 overtakes obj2

        //Check to see if these objects allow these collisions
        if(p1hn2?(!Object1.collideBottom || !Object2.collideTop):(!Object1.collideTop || !Object2.collideBottom))
            return false;

        //this looks insane, but we're just looping through collision offsets on each object
        for(i1 in 0...l1)
        {
            ox1 = co1[i1].x;
            oy1 = co1[i1].y;
            obj1Hull.x += ox1;
            obj1Hull.y += oy1;
            for(i2 in 0...l2)
            {
                ox2 = co2[i2].x;
                oy2 = co2[i2].y;
                obj2Hull.x += ox2;
                obj2Hull.y += oy2;

                //See if it's a actually a valid collision
                if( (obj1Hull.x + obj1Hull.width  < obj2Hull.x + roundingError) ||
                        (obj1Hull.x + roundingError > obj2Hull.x + obj2Hull.width) ||
                        (obj1Hull.y + obj1Hull.height < obj2Hull.y + roundingError) ||
                        (obj1Hull.y + roundingError > obj2Hull.y + obj2Hull.height) )
                {
                    obj2Hull.x -= ox2;
                    obj2Hull.y -= oy2;
                    continue;
                }

                //Calculate the overlap between the objects
                if(p1hn2)
                {
                    if(obj1MoveNeg)
                        r1 = obj1Hull.y + Object1.colHullX.height;
                    else
                        r1 = obj1Hull.y + obj1Hull.height;
                    if(obj2MoveNeg)
                        r2 = obj2Hull.y;
                    else
                        r2 = obj2Hull.y + obj2Hull.height - Object2.colHullX.height;
                }
                else
                {
                    if(obj2MoveNeg)
                        r1 = -obj2Hull.y - Object2.colHullX.height;
                    else
                        r1 = -obj2Hull.y - obj2Hull.height;
                    if(obj1MoveNeg)
                        r2 = -obj1Hull.y;
                    else
                        r2 = -obj1Hull.y - obj1Hull.height + Object1.colHullX.height;
                }
                overlap = r1 - r2;

                //Last chance to skip out on a bogus collision resolution
                if( (overlap == 0) ||
                        ((!Object1.fixed && ((overlap>0)?overlap:-overlap) > obj1Hull.height*0.8)) ||
                        ((!Object2.fixed && ((overlap>0)?overlap:-overlap) > obj2Hull.height*0.8)) )
                {
                    obj2Hull.x -= ox2;
                    obj2Hull.y -= oy2;
                    continue;
                }
                hit = true;

                //Adjust the objects according to their flags and stuff
                sv1 = Object2.velocity.y;
                sv2 = Object1.velocity.y;
                if(!Object1.fixed && Object2.fixed)
                {
                    if(Object1._group)
                        Object1.reset(Object1.x, Object1.y - overlap);
                    else
                        Object1.y -= overlap;
                }
                else if(Object1.fixed && !Object2.fixed)
                {
                    if(Object2._group)
                        Object2.reset(Object2.x, Object2.y + overlap);
                    else
                        Object2.y += overlap;
                }
                else if(!Object1.fixed && !Object2.fixed)
                {
                    overlap /= 2;
                    if(Object1._group)
                        Object1.reset(Object1.x, Object1.y - overlap);
                    else
                        Object1.y -= overlap;
                    if(Object2._group)
                        Object2.reset(Object2.x, Object2.y + overlap);
                    else
                        Object2.y += overlap;
                    sv1 /= 2;
                    sv2 /= 2;
                }
                if(p1hn2)
                {
                    Object1.hitBottom(Object2,sv1);
                    Object2.hitTop(Object1,sv2);
                }
                else
                {
                    Object1.hitTop(Object2,sv1);
                    Object2.hitBottom(Object1,sv2);
                }

                //Adjust collision hulls if necessary
                if(!Object1.fixed && (overlap != 0))
                {
                    if(p1hn2)
                    {
                        obj1Hull.y -= overlap;

                        //This code helps stuff ride horizontally moving platforms.
                        if(Object2.fixed && Object2.moves)
                        {
                            sv1 = Object2.colVector.x;
                            Object1.x += sv1;
                            obj1Hull.x += sv1;
                            Object1.colHullX.x += sv1;
                        }
                    }
                    else
                    {
                        obj1Hull.y -= overlap;
                        obj1Hull.height += overlap;
                    }
                }
                if(!Object2.fixed && (overlap != 0))
                {
                    if(p1hn2)
                    {
                        obj2Hull.y += overlap;
                        obj2Hull.height -= overlap;
                    }
                    else
                    {
                        obj2Hull.height += overlap;

                        //This code helps stuff ride horizontally moving platforms.
                        if(Object1.fixed && Object1.moves)
                        {
                            sv2 = Object1.colVector.x;
                            Object2.x += sv2;
                            obj2Hull.x += sv2;
                            Object2.colHullX.x += sv2;
                        }
                    }
                }
                obj2Hull.x -= ox2;
                obj2Hull.y -= oy2;
            }
            obj1Hull.x -= ox1;
            obj1Hull.y -= oy1;
        }

        return hit;
    }
}
