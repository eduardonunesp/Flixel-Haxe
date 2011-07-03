#!/bin/bash
if [[ -z $1 ]]; then
    echo "First arg is resource dir"
    exit 1;
fi

if [[ -z $2 ]]; then
    echo "Second arg is output swf"
    exit 1;
fi

./swfml_gen.sh $1 > ${2}.xml
cat ${2}.xml | swfmill simple stdin $2
