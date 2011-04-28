FILE=Assets.xml
OUT=Assets.swf

all:
	swfmill simple ${FILE} ${OUT}

clean:
	rm -rf ${OUT}
