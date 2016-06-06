
ifeq ($(OS),Windows_NT)
    LIB_JNI = libpocketsphinx_jni.dll
	AOL_OS = windows
	ifeq ($(PROCESSOR_ARCHITECTURE),AMD64)
		AOL_AR = x86_64
	endif
	ifeq ($(PROCESSOR_ARCHITECTURE),x86)
		AOL_AR = x86
	endif
else
    UNAME_S := $(shell uname -s)
    ifeq ($(UNAME_S),Linux)
        LIB_JNI = libpocketsphinx_jni.so
		AOL_OS = linux
    endif
    ifeq ($(UNAME_S),Darwin)
        LIB_JNI = libpocketsphinx_jni.dylib
		AOL_OS = darwin
    endif
	UNAME_A := $(shell uname -a)
	UNAME_P := $(shell uname -p)
	ifneq ($(filter x86_64,$(UNAME_A)),)
		AOL_AR = x86_64
	else
		ifneq ($(filter %86,$(UNAME_P)),)
			AOL_AR = x86
		endif
		ifneq ($(filter arm%,$(UNAME_P)),)
			AOL_AR = armel
		endif
	endif
endif

PACKAGE = pocketsphinx-$(AOL_OS)-$(AOL_AR).zip

all: $(PACKAGE)

$(PACKAGE): pocketsphinx.jar $(LIB_JNI)
	zip $@ pocketsphinx.jar $(LIB_JNI)

$(LIB_JNI): pocketsphinx_wrap.c sphinxbase_wrap.c
	$(CC) -shared pocketsphinx_wrap.c sphinxbase_wrap.c -I$(JAVA_HOME)/include -I$(JAVA_HOME)/include/$(AOL_OS) -I../../sphinxbase/include -I../../include ../../target/lib/libpocketsphinx.a ../../target/lib/libsphinxbase.a ../../target/lib/libsphinxad.a -o $@ -DPIC -fPIC -lm -lpthread

pocketsphinx.jar: pocketsphinx_wrap.c sphinxbase_wrap.c
	javac edu/cmu/pocketsphinx/*.java
	jar cf $@ edu/cmu/pocketsphinx/*.class

pocketsphinx_wrap.c: ../pocketsphinx.i
	mkdir -p edu/cmu/pocketsphinx
	swig -I.. -I../../sphinxbase/swig -I../include -I../../sphinxbase/include \
		-java -package edu.cmu.pocketsphinx \
		-outdir edu/cmu/pocketsphinx -o $@ $<

sphinxbase_wrap.c: ../../sphinxbase/swig/sphinxbase.i
	mkdir -p edu/cmu/pocketsphinx
	swig -I.. -I../../sphinxbase/swig -I../include -I../../sphinxbase/include \
		-java -package edu.cmu.pocketsphinx \
		-outdir edu/cmu/pocketsphinx -o $@ $<

clean:
	$(RM) *.so *.dylib *.dll *_wrap.c *_wrap.o test/*.class *.jar *.zip
	$(RM) -r edu

run: pocketsphinx.jar $(LIB_JNI)
	javac -cp pocketsphinx.jar test/*.java
	java -Djava.library.path=. -cp . test.DecoderTest
