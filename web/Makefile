.PHONY: all clean install

all:
	mkdir -p build
	cd build && emcmake cmake ..
	cd build && emmake make lcpp -j

install:
	cp build/web/* ./

clean:
	rm -rf build
