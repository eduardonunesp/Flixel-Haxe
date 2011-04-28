package org.flixel;

/**
 * This is an organizational class that can update and render a bunch of <code>FlxObject</code>s.
 * NOTE: Although <code>FlxGroup</code> extends <code>FlxObject</code>, it will not automatically
 * add itself to the global collisions quad tree, it will only add its members.
 */
class FlxGroup extends FlxObject {
    /**
     * Array of all the <code>FlxObject</code>s that exist in this layer.
     */

    /**
     * Array of all the <code>FlxObject</code>s that exist in this layer.
     */
    public var members:Array<Dynamic>;  //NOTE: This array must be Dynamic to function correctly in cpp (I wish I knew why)
    /**
     * Helpers for moving/updating group members.
     */
    var _last:FlxPoint;
    var _first:Bool;

    /**
     * Constructor
     */
    public function new()
    {
        super();
        _group = true;
        solid = false;
        members = new Array<FlxObject>();
        _last = new FlxPoint();
        _first = true;
    }

    /**
     * Adds a new <code>FlxObject</code> subclass (FlxSprite, FlxBlock, etc) to the list of children
     *
     * @param Object   The object you want to add
     * @param ShareScroll  Whether or not this FlxCore should sync up with this layer's scrollFactor
     *
     * @return The same <code>FlxCore</code> object that was passed in.
     */
    public function add(Object:FlxObject,?ShareScroll:Bool=false):FlxObject
    {
        members.push(Object);
        if(ShareScroll)
            Object.scrollFactor = scrollFactor;
        return Object;
    }

    /**
     * Replaces an existing <code>FlxObject</code> with a new one.
     * 
     * @param OldObject The object you want to replace.
     * @param NewObject The new object you want to use instead.
     * 
     * @return The new object.
     */
    public function replace(OldObject:FlxObject,NewObject:FlxObject):FlxObject
    {
        var index:Int = -1;
        for (i in 0 ... members.length) {
            if (members[i] == OldObject) {
                index = i;
                break;
            }
        }
        if((index < 0) || (index >= members.length))
            return null;
        members[index] = NewObject;
        return NewObject;
    }

    /**
     * Removes an object from the group.
     * 
     * @param Object The <code>FlxObject</code> you want to remove.
     * @param Splice Whether the object should be cut from the array entirely or not.
     * 
     * @return The removed object.
     */
    public function remove(Object:FlxObject,?Splice:Bool=false):FlxObject
    {
        var index:Int = -1;
        for (i in 0 ... members.length) {
            if (members[i] == Object) {
                index = i;
                break;
            }
        }
        if((index < 0) || (index >= members.length))
            return null;
        if(Splice)
            members.splice(index,1);
        else
            members[index] = null;
        return Object;
    }

    /**
     * Call this function to retrieve the first object with exists == false in the group.
     * This is handy for recycling in general, e.g. respawning enemies.
     * 
     * @return A <code>FlxObject</code> currently flagged as not existing.
     */
    public function getFirstAvail():FlxObject
    {
        var o:FlxObject;
        var ml:Int = members.length;
        for(i in 0...ml)
        {
            o = cast( members[i], FlxObject);
            if((o != null) && !o.exists)
                return o;
        }
        return null;
    }

    /**
     * Call this function to retrieve the first index set to 'null'.
     * Returns -1 if no index stores a null object.
     * 
     * @return An <code>int</code> indicating the first null slot in the group.
     */
    public function getFirstNull():Int
    {
        var ml:Int = members.length;
        for(i in 0...ml)
        {
            if(members[i] == null)
                return i;
        }
        return -1;
    }

    /**
     * Finds the first object with exists == false and calls reset on it.
     * 
     * @param X The new X position of this object.
     * @param Y The new Y position of this object.
     * 
     * @return Whether a suitable <code>FlxObject</code> was found and reset.
     */
    public function resetFirstAvail(?X:Int=0, ?Y:Int=0):Bool
    {
        var o:FlxObject = getFirstAvail();
        if(o == null)
            return false;
        o.reset(X,Y);
        return true;
    }

    /**
     * Call this function to retrieve the first object with exists == true in the group.
     * This is handy for checking if everything's wiped out, or choosing a squad leader, etc.
     * 
     * @return A <code>FlxObject</code> currently flagged as existing.
     */
    public function getFirstExtant():FlxObject
    {
        var o:FlxObject;
        var ml:Int = members.length;
        for(i in 0...ml)
        {
            o = cast( members[i], FlxObject);
            if((o != null) && o.exists)
                return o;
        }
        return null;
    }

    /**
     * Call this function to retrieve the first object with dead == false in the group.
     * This is handy for checking if everything's wiped out, or choosing a squad leader, etc.
     * 
     * @return A <code>FlxObject</code> currently flagged as not dead.
     */
    public function getFirstAlive():FlxObject
    {
        var o:FlxObject;
        var ml:Int = members.length;
        for(i in 0...ml)
        {
            o = cast( members[i], FlxObject);
            if((o != null) && o.exists && !o.dead)
                return o;
        }
        return null;
    }

    /**
     * Call this function to retrieve the first object with dead == true in the group.
     * This is handy for checking if everything's wiped out, or choosing a squad leader, etc.
     * 
     * @return A <code>FlxObject</code> currently flagged as dead.
     */
    public function getFirstDead():FlxObject
    {
        var o:FlxObject;
        var ml:Int = members.length;
        for(i in 0...ml)
        {
            o = cast( members[i], FlxObject);
            if((o != null) && o.dead)
                return o;
        }
        return null;
    }

    /**
     * Call this function to find out how many members of the group are not dead.
     * 
     * @return The number of <code>FlxObject</code>s flagged as not dead.  Returns -1 if group is empty.
     */
    public function countLiving():Int
    {
        var o:FlxObject;
        var count:Int = -1;
        var ml:Int = members.length;
        for(i in 0...ml)
        {
            o = cast( members[i], FlxObject);
            if(o != null)
            {
                if(count < 0)
                    count = 0;
                if(o.exists && !o.dead)
                    count++;
            }
        }
        return count;
    }

    /**
     * Call this function to find out how many members of the group are dead.
     * 
     * @return The number of <code>FlxObject</code>s flagged as dead.  Returns -1 if group is empty.
     */
    public function countDead():Int
    {
        var o:FlxObject;
        var count:Int = -1;
        var ml:Int = members.length;
        for(i in 0...ml)
        {
            o = cast( members[i], FlxObject);
            if(o != null)
            {
                if(count < 0)
                    count = 0;
                if(o.dead)
                    count++;
            }
        }
        return count;
    }

    /**
     * Returns a count of how many objects in this group are on-screen right now.
     * 
     * @return The number of <code>FlxObject</code>s that are on screen.  Returns -1 if group is empty.
     */
    public function countOnScreen():Int
    {
        var o:FlxObject;
        var count:Int = -1;
        var ml:Int = members.length;
        for(i in 0...ml)
        {
            o = cast( members[i], FlxObject);
            if(o != null)
            {
                if(count < 0)
                    count = 0;
                if(o.onScreen())
                    count++;
            }
        }
        return count;
    }  

    /**
     * Returns a member at random from the group.
     * 
     * @return A <code>FlxObject</code> from the members list.
     */
    public function getRandom():FlxObject
    {
        var c:Int = 0;
        var o:FlxObject = null;
        var l:Int = members.length;
        var i:Int = Math.floor(FlxU.random()*l);
        while((o == null) && (c < members.length))
        {
            o = cast(members[Math.floor((++i)%l)], FlxObject);
            c++;
        }
        return o;
    }

    /**
     * Internal function, helps with the moving/updating of group members.
     */
    function saveOldPosition():Void
    {
        if(_first)
        {
            _first = false;
            _last.x = 0;
            _last.y = 0;
            return;
        }
        _last.x = x;
        _last.y = y;
    }

    /**
     * Internal function that actually goes through and updates all the group members.
     * Depends on <code>saveOldPosition()</code> to set up the correct values in <code>_last</code> in order to work properly.
     */
    function updateMembers():Void
    {
        var mx:Float = Math.NaN;
        var my:Float = Math.NaN;
        var moved:Bool = false;
        if((x != _last.x) || (y != _last.y))
        {
            moved = true;
            mx = x - _last.x;
            my = y - _last.y;
        }
        var o:FlxObject;
        var l:Int = members.length;
        for(i in 0...l)
        {
            o = cast( members[i], FlxObject);
            if((o != null) && o.exists)
            {
                if(moved)
                {
                    if(o._group)
                        o.reset(o.x+mx,o.y+my);
                    else
                    {
                        o.x += mx;
                        o.y += my;
                    }
                }
                if(o.active)
                    o.update();
                if(moved && o.solid)
                {
                    o.colHullX.width += ((mx>0)?mx:-mx);
                    if(mx < 0)
                        o.colHullX.x += mx;
                    o.colHullY.x = x;
                    o.colHullY.height += ((my>0)?my:-my);
                    if(my < 0)
                        o.colHullY.y += my;
                    o.colVector.x += mx;
                    o.colVector.y += my;
                }
            }
        }
    }

    /**
     * Automatically goes through and calls update on everything you added,
     * override this function to handle custom input and perform collisions.
     */
    public override function update():Void
    {
        saveOldPosition();
        updateMotion();
        updateMembers();
        updateFlickering();
    }

    /**
     * Internal function that actually loops through and renders all the group members.
     */
    function renderMembers():Void
    {
        var o:FlxObject;
        var l:Int = members.length;
        for(i in 0...l)
        {
            o = cast( members[i], FlxObject);
            if((o != null) && o.exists && o.visible)
                o.render();
        }
    }

    /**
     * Automatically goes through and calls render on everything you added,
     * override this loop to control render order manually.
     */
    public override function render():Void
    {
        renderMembers();
    }

    /**
     * Internal function that calls kill on all members.
     */
    function killMembers():Void
    {
        var o:FlxObject;
        var l:Int = members.length;
        for(i in 0...l)
        {
            o = cast( members[i], FlxObject);
            if(o != null)
                o.kill();
        }
    }

    /**
     * Calls kill on the group and all its members.
     */
    public override function kill():Void
    {
        killMembers();
        super.kill();
    }

    /**
     * Internal function that actually loops through and destroys each member.
     */
    function destroyMembers():Void
    {
        trace("destroyMembers called!");
        var o:FlxObject;
        var l:Int = members.length;
        for(i in 0...l)
        {
            o = cast( members[i], FlxObject);
            if(o != null)
                o.destroy();
        }
        members = new Array();
    }

    /**
     * Override this function to handle any deleting or "shutdown" type operations you might need,
     * such as removing traditional Flash children like Sprite objects.
     */
    public override function destroy():Void
    {
        destroyMembers();
        super.destroy();
    }

    /**
     * If the group's position is reset, we want to reset all its members too.
     * 
     * @param X The new X position of this object.
     * @param Y The new Y position of this object.
     */
    public override function reset(X:Float,Y:Float):Void
    {
        saveOldPosition();
        super.reset(X,Y);
        var mx:Float = Math.NaN;
        var my:Float = Math.NaN;
        var moved:Bool = false;
        if((x != _last.x) || (y != _last.y))
        {
            moved = true;
            mx = x - _last.x;
            my = y - _last.y;
        }
        var o:FlxObject;
        var l:Int = members.length;
        for(i in 0...l)
        {
            o = cast( members[i], FlxObject);
            if((o != null) && o.exists)
            {
                if(moved)
                {
                    if(o._group)
                        o.reset(o.x+mx,o.y+my);
                    else
                    {
                        o.x += mx;
                        o.y += my;
                        if(solid)
                        {
                            o.colHullX.width += ((mx>0)?mx:-mx);
                            if(mx < 0)
                                o.colHullX.x += mx;
                            o.colHullY.x = x;
                            o.colHullY.height += ((my>0)?my:-my);
                            if(my < 0)
                                o.colHullY.y += my;
                            o.colVector.x += mx;
                            o.colVector.y += my;
                        }
                    }
                }
            }
        }
    }
}
