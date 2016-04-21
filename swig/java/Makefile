CFLAGS := -g -Wall -DPIC -fPIC
CPPFLAGS := -I$(JAVA_HOME)/include -I$(JAVA_HOME)/include/darwin -I$(JAVA_HOME)/include/linux -Wno-unused-function -I../../../../lib/ps/include/ -I../../../../lib/ps/include/sphinxbase/ -I../../../../lib/ps/include/pocketsphinx/

all: libpocketsphinx_jni.so

libpocketsphinx_jni.so: pocketsphinx_wrap.o sphinxbase_wrap.o
	cp src/main/c/* .
	$(CC) -shared -o $@ pocketsphinx_wrap.o sphinxbase_wrap.o -L../../../../lib/ps/lib/ -Wl,-rpath,bundles/io/org.eclipse.smarthome.io.voice/lib/ps/lib -lpocketsphinx -lsphinxbase
#	cp libpocketsphinx_jni.so libpocketsphinx_jni.dylib
pocketsphinx_wrap.c: ../pocketsphinx.i
	mkdir -p edu/cmu/pocketsphinx
	mkdir -p src/main/c
	swig -Imain/c -I.. -I../../../sphinxbase/swig -I../include -I../../sphinxbase/include \
		-java -package edu.cmu.pocketsphinx \
		-outdir edu/cmu/pocketsphinx -o src/main/c/$@ $<
	cp src/main/c/* .

sphinxbase_wrap.c: ../../../sphinxbase/swig/sphinxbase.i
	mkdir -p edu/cmu/pocketsphinx
	mkdir -p src/main/c
	swig -Imain/c-I.. -I../../../sphinxbase/swig -I../include -I../../sphinxbase/include \
		-java -package edu.cmu.pocketsphinx \
		-outdir edu/cmu/pocketsphinx -o src/main/c/$@ $<
	cp src/main/c/* .

clean:
	$(RM) *.so *.dylib *_wrap.c *_wrap.o test/*.class
	$(RM) -r edu
	$(RM) -r src
	$(RM) -rf target

run:
	javac test/src/test/*.java test/src/edu/cmu/pocketsphinx/*.java
	java -Djava.library.path=. -cp test/src/ test.DecoderTest
