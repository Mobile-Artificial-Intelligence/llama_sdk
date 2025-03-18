.PHONY: all clean

all:
	mkdir -p build
	cd build && emcmake cmake ..
	cd build && emake make lcpp -j

clean:
	rm -rf build
