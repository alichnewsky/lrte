LRTE
====

Fork of https://code.google.com/p/google-search-appliance-mirror/downloads/detail?name=grte-1.2.2-src.tar.bz2&amp;can=2&amp;q=

Original source code downloaded from:

https://google-search-appliance-mirror.googlecode.com/files/grte-1.2.2-src.tar.bz2
https://google-search-appliance-mirror.googlecode.com/files/crosstoolv13-gcc-4.4.0-glibc-2.3.6-grte-1.0-36185.src.rpm
https://google-search-appliance-mirror.googlecode.com/files/grte-python2.4-2.4.6-7.src.tar.bz2

ChangeLog
=========

 - grte-1.2.2-src.tar.bz2 -> grte with sources stripped


Install and Usage
=================

It's recommended to just install the precomiled packages from release
page. For example, to install lrtev2 with crosstool v2:

```
apt-get update
apt-get install -y apt-transport-https
echo 'deb https://github.com/mzhaom/lrte/releases/download/v2.0_0 ./' >> /etc/apt/sources.list
apt-get update
apt-get install -y --force-yes lrtev2-crosstoolv2-gcc-4.9 lrtev2-crosstoolv2-clang-3.7

```

On the production machines, you should need to install
```lrtev2-runtime``` package, which contains the glibc and libstdc++
libraries.

Then gcc and clang under /usr/crosstool/v2/gcc-4.9.2-lrtev2/x86/bin
can be used to produce binaries that only work with LRTE, which means
these binaries only depend on glibc and libstdc++ coming from LRTE
runtime, so they can be shipped without worrying about the system's
glibc version.

Btw: the gcc and clang inside crosstool are linked against LRTE
runtime they can pretty much run on any release of ubuntu or redhat.

For example:

```
# /usr/lrte/v2/bin/ldd /usr/crosstool/v2/gcc-4.9.2-lrtev2/x86/bin/clang
        linux-vdso.so.1 (0x00007ffc388cf000)
        libdl.so.2 => /usr/lrte/v2/lib64/libdl.so.2 (0x00007f6e55453000)
        libpthread.so.0 => /usr/lrte/v2/lib64/libpthread.so.0 (0x00007f6e55236000)
        libz.so.1 => /usr/lrte/v2/lib64/libz.so.1 (0x00007f6e5501c000)
        libstdc++.so.6 => /usr/lrte/v2/lib64/libstdc++.so.6 (0x00007f6e54d12000)
        libm.so.6 => /usr/lrte/v2/lib64/libm.so.6 (0x00007f6e54a0a000)
        libgcc_s.so.1 => /usr/lrte/v2/lib64/libgcc_s.so.1 (0x00007f6e547f4000)
        libc.so.6 => /usr/lrte/v2/lib64/libc.so.6 (0x00007f6e54431000)
        /usr/lrte/v2/lib64/ld-linux-x86-64.so.2 (0x00007f6e55657000)
```

You can also refer to this *external* [build
guide](https://github.com/mzhaom/lrte/wiki/Build-Guide) if you prefer
building everything from source code for further customization.


Building ISPC from github.com
=============================
The version of clang-4.0 I use for now is Google's not trunk. *FOR NOW*.

And that is not clang 4.0 as ispc expects... Therefore it is useful to fool it into thinking it is using clang 3.9!
and therefore path `ispc_version.h`

In order to use a crosstool compiler to build it, we also need to patch the makefile.

There is still a bug in the ispc 32 bit build, I think.

```
diff --git a/Makefile b/Makefile
index e249a5e..7a41281 100644
--- a/Makefile
+++ b/Makefile
@@ -94,6 +94,9 @@ LLVM_CXXFLAGS=$(shell $(LLVM_CONFIG) --cppflags) $(DNDEBUG_FLAG)
 LLVM_VERSION=LLVM_$(shell $(LLVM_CONFIG) --version | sed -e 's/svn//' -e 's/\./_/' -e 's/\..*//')
 LLVM_VERSION_DEF=-D$(LLVM_VERSION)
 
+LLVM_CXXFLAGS += --sysroot=/usr/lrte/v2
+
+
 LLVM_COMPONENTS = engine ipo bitreader bitwriter instrumentation linker 
 # Component "option" was introduced in 3.3 and starting with 3.4 it is required for the link step.
 # We check if it's available before adding it (to not break 3.2 and earlier).
@@ -123,7 +126,7 @@ endif
 
 # There is no logical OR in GNU make. 
 # This 'ifneq' acts like if( !($(LLVM_VERSION) == LLVM_3_2 || $(LLVM_VERSION) == LLVM_3_3 || $(LLVM_VERSION) == LLVM_3_4))
-ifeq (,$(filter $(LLVM_VERSION), LLVM_3_2 LLVM_3_3 LLVM_3_4))
+ifeq (,$(filter $(LLVM_VERSION), LLVM_3_2 LLVM_3_3 LLVM_3_4 LLVM_4_0))
     ISPC_LIBS += -lcurses -lz
     # This is here because llvm-config fails to report dependency on tinfo library in some case.
     # This is described in LLVM bug 16902.
@@ -161,6 +164,10 @@ else
 endif
 
 CXX=clang++
+
+CC=clang
+CCFLAGS += --sysroot=/usr/lrte/v2
+
 OPT=-O2
 CXXFLAGS=$(OPT) $(LLVM_CXXFLAGS) -I. -Iobjs/ -I$(CLANG_INCLUDE)  \
        $(LLVM_VERSION_DEF) \
@@ -190,6 +197,8 @@ ifeq ($(ARCH_OS),Linux)
 #    LDFLAGS=-static-libgcc -static-libstdc++
 endif
 
+DYNAMIC_LINKER_FLAGS= -Wl,-dynamic-linker,/usr/lrte/v2/lib64/ld-linux-x86-64.so.2 
+
 LEX=flex
 YACC=bison -d -v -t
 
@@ -262,7 +271,7 @@ doxygen:
 
 ispc: print_llvm_src dirs $(OBJS)
        @echo Creating ispc executable
-       @$(CXX) $(OPT) $(LDFLAGS) -o $@ $(OBJS) $(ISPC_LIBS)
+       @$(CXX) $(OPT) $(DYNAMIC_LINKER_FLAGS) $(LDFLAGS) -o $@ $(OBJS) $(ISPC_LIBS)
 
 # Use clang as a default compiler, instead of gcc
 # This is default now.
diff --git a/ispc_version.h b/ispc_version.h
index 7122d55..fdb192f 100644
--- a/ispc_version.h
+++ b/ispc_version.h
@@ -41,7 +41,9 @@
 #define ISPC_VERSION "1.9.2dev"
 #include "llvm/Config/llvm-config.h"
 
-#define ISPC_LLVM_VERSION ( LLVM_VERSION_MAJOR * 10000 + LLVM_VERSION_MINOR * 100 )
+// AL : this is not quite ready for the LLVM 4.0 google version I built.
+//#define ISPC_LLVM_VERSION ( LLVM_VERSION_MAJOR * 10000 + LLVM_VERSION_MINOR * 100 )
+#define ISPC_LLVM_VERSION ( 3 * 10000 + 9 * 100)
 
 #define ISPC_LLVM_3_2 30200
 #define ISPC_LLVM_3_3 30300
```
