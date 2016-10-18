LRTE
====

Fork of https://github.com/mzhaom/lrte

ChangeLog
=========

 - still using Google's GCC 4.9.2 branch and Clang 4.0 dev branches
 - clang includes openmp and polly
 - added a build of Intel's [https://github.com/ispc/ispc/][ispc]


Install
=======

install precompiled lrtev2 package. On production machine, lrtev2-runtime is all you need.
Debug symbols, includes, etc are all optional

to install crosstools v2 on debian :
```
sudo dpkg -i output/lrte/results/debs/lrtev2-runtime*.deb

sudo dpkg -i output/lrte/results/debs/lrtev2-crosstoolv2-gcc-4.9*.deb
sudo dpkg -i output/lrte/results/debs/lrtev2-crosstoolv2-clang-4.0*.deb
sudo dpkg -i output/lrte/results/debs/lrtev2-crosstoolv2-ispc-1.9.2dev*.deb

```
the same thing can indeed be done with RPMs

Build:
======
I build all of this with a GCE VM using debian:jessie docker images. ubuntu:14.04 should work as well. and may have more reliable APT mirrors.

Install LRTE
```
git clone https://github.com/alichnewsky/lrte.git
cd lrte
TAR_DIR=upstream ./grte/downloads.sh

./release.py  --no_build_crosstool --email alichnewsky@gmail.com --docker_image=debian:jessie
```

Download gcc, clang and ispc crosstool source code

```
bash crosstool/get-gcc-svn.sh
bash crosstool/get-clang-svn.sh
bash crosstool/get-ispc-from-github.sh
```

Build and install crosstools
```
./release.py  --no_build_lrte --email alichnewsky@gmail.com --docker_image=debian:jessie

```

Only building ispc when lrte, `gcc` and `clang` crosstools have already been built
```

./release.py  --no_build_lrte --crosstool_skip gcc clang --email alichnewsky@gmail.com --docker_image=debian:jessie

```

The following part contain SVN or git version numbers and care should be taken when doing updates:
-
- 

Releasing to GitHub
===================
AFAIK releases still have to be created manually from the github website
I could not get them created programmatically

Assuming you have an un-encrypted .netrc, and that release v2.2_0 has been created in github, and that you have installed github-release tool(https://github.com/aktau/github-release) in you rpath:

```
export GITHUB_USER=username GITHUB_TOKEN=$(cat ~/.netrc  |egrep "^password" | awk '{print $2}' | uniq) RELEASE_TAG=v2.2_0
bash upload-github-release.sh $(find output/lrte/results/ -type f)
```

Original Install and Usage notes
================================

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

You can also refer to [build
guide](https://github.com/mzhaom/lrte/wiki/Build-Guide) if you prefer
building everything from source code for further customization.


From a GCE machine, using a Debian VM
=====================================
```


```
