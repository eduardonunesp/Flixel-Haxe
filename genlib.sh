#!/bin/bash
if [[ -z $1 ]]; then
    echo "First arg is resource dir"
    exit 1;
fi

if [[ -z $2 ]]; then
    echo "Second arg is output swf"
    exit 1;
fi

genxml() {
    #escape * so it doesn't try to sub with file names in local dir
    gfx=`find $1 -name [^~.]\*.png`
    swfs=`find $1 -name [^~.]\*.swf`
    fonts=`find $1 -name [^~.]\*.ttf`
    mp3=`find $1 -name [^~.]\*.mp3`

    if [[ -z $gfx && -z $fonts && -z $swfs ]]; then
        echo "no matching files found in $1"
        exit 1
    fi

    #function to upcase first letter
    function up_first
    {
        #TODO: take an arg instead of only reading from pipe
        while read line; do
            first=`echo $line | sed -e 's/^\(.\).*$/\1/'`
            first_up=`echo $first | tr '[a-z]' '[A-Z]'`
            echo `echo $line | sed -e "s/^$first/$first_up/"`
        done
    }

    # escape slashes is dir paths for use in regexes
    function escape_dir
    {
        if [[ -z $1 ]]; then
            while read line; do
                echo `echo $line | sed -e 's/\//\\\\\//g'`
            done;
        else
            echo `echo $1 | sed -e 's/\//\\\\\//g'`
        fi
    }

    # generate unique id by replace / and . in filenames with _
    # it's unique because it's namespaced with directory names
    function make_id
    {
        #replace / with _ in file names so i can use base as regex
        #this will still have the trailing / from find, so get rid of it
        base_name=`echo "$1/" | sed -e "s/\//\_/g"`
        file_name=`echo "$2" | sed -e "s/\//\_/g"`
        
        #always upcase the first char of the file name
        echo "$file_name" | sed -e "s/$base_name//" | sed -e "s/\./\_/g" | up_first 
    }

    #get a file path with the extra / removed after the dir that we did find on
    function clean_base_dir
    {
        #remove trailing / and escape for use in regex
        clean_base=`echo "$1" | sed -e "s/\/$//" | escape_dir`
        #escape original for use in regex
        old_base=`escape_dir $1`
        echo "$2" | sed -e "s/$old_base/$clean_base/"
    }

    #make .hx class file for each resource
    function write_class_file
    {
        # $1 is Class name (id) and $2 is file type and $3 is file name
        if [[ $2 == "swf" ]]; then
            echo "class $1 extends MovieClip { public function new() { super(); } }" >> $3
        fi 
        
        if [[ $2 == "bmp" ]]; then
            echo "class $1 extends Bitmap { public function new() { super(); } }" >> $3
        fi

        if [[ $2 == "snd" ]]; then
            echo "class $1 extends Sound { public function new() { super(); } }" >> $3
        fi

        if [[ $2 == "font" ]]; then
            echo "class $1 extends Font { public function new() { super(); } }" >> $3
        fi
    }

    echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
    echo "<movie version=\"9\">"
    echo -e "\t<background color=\"#ffffff\"/>"
    echo -e "\t<frame>"
    echo -e "\t\t<library>"
    
    #remove old class file
    class_file="assets/LibraryClasses.hx"
    if [[ -f $class_file ]]; then
        rm $class_file
    fi

    #put default info in class file
    if [[ ! -z $gfx ]]; then
        echo "import flash.display.Bitmap;" >> $class_file
    fi

    if [[ ! -z $swfs ]]; then
        echo "import flash.display.MovieClip;" >> $class_file
    fi

    if [[ ! -z $mp3 ]]; then
        echo "import flash.media.Sound;" >> $class_file
    fi

    if [[ ! -z $fonts ]]; then
        echo "import flash.text.Font;" >> $class_file
    fi

    #add a blank line after includes
    echo "" >> $class_file
    cl_path=`echo $1 | sed -e 's/\/$//'`
    for file in $gfx; do
        #remove the last / that find adds to the base dir
        path=`clean_base_dir $cl_path $file`
        id=`make_id $cl_path $file`
        write_class_file $id "bmp" $class_file
        echo -e "\t\t\t<bitmap id=\"$id\" name=\"$id\" class=\"$id\" import=\"$path\"/>"
    done

    for swf_file in $swfs; do
        path=`clean_base_dir $cl_path $swf`
        id=`make_id $cl_path $swf_file`
        write_class_file $id "swf" $class_file
        echo -e "\t\t\t<clip id=\"$id\" name=\"$id\" class=\"$id\" import=\"$path\"/>"
    done

    for font_file in $fonts; do
        path=`clean_base_dir $cl_path $font_file`
        id=`make_id $cl_path $font_file`
        write_class_file $id "font" $class_file
        echo -e "\t\t\t<font id=\"$id\" name=\"$id\" import=\"$path\" glyphs=\"abcdefghijklmnopqrstuvwxyz\"/>"
    done

    for mp3_file in $mp3; do
        path=`clean_base_dir $cl_path $mp3_file`
        id=`make_id $cl_path $mp3_file`
        write_class_file $id "snd" $class_file
        echo -e "\t\t\t<sound id=\"$id\" name=\"$id\" import=\"$path\"/>"
    done

    echo -e "\t\t</library>"
    echo -e "\t</frame>"
    echo "</movie>"
}

if [ ! -e 'assets' ]; then
    mkdir assets
genxml $1 > assets/${2}.xml
cat assets/${2}.xml | swfmill simple stdin assets/$2
else
    echo 'Assets dir already exists'  
fi
