CFLAGS := -g -Wall -DPIC -fPIC
CPPFLAGS := -Wno-unused-function
CPPFLAGS += -I$(JAVA_HOME)/include
CPPFLAGS += -I$(JAVA_HOME)/include/darwin
CPPFLAGS += -I$(JAVA_HOME)/include/linux
CPPFLAGS += -I../../target/include
CPPFLAGS += -I../../target/include/pocketsphinx
CPPFLAGS += -I../../target/include/sphinxbase

ALLLIBS := ../../target/lib/libsphinxbase.a
ALLLIBS += ../../target/lib/libsphinxad.a
ALLLIBS += ../../target/lib/libpocketsphinx.a

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

$(LIB_JNI): pocketsphinx_wrap.o sphinxbase_wrap.o
	$(CC) -shared -o $@ pocketsphinx_wrap.o sphinxbase_wrap.o $(ALLLIBS)

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
