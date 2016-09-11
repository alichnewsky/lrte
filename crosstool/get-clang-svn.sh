#!/bin/bash -e

# Get clang's source code from svn
SVN_TOP=${SVN_TOP:-upstream}
BRANCH=branches/google/stable
# no 4.0, no google branch
OPENMP_BRANCH=branches/release_39
cd ${SVN_TOP}
svn co http://llvm.org/svn/llvm-project/llvm/${BRANCH} llvm
svn co http://llvm.org/svn/llvm-project/compiler-rt/${BRANCH} llvm/projects/compiler-rt
# if I don't add this, we have clang with OPENMP support but no libomp. it has to use libgomp from GCC
svn co http://llvm.org/svn/llvm-project/openmp/${OPENMP_BRANCH} llvm/projects/openmp
svn co http://llvm.org/svn/llvm-project/cfe/${BRANCH} llvm/tools/clang
svn co http://llvm.org/svn/llvm-project/lldb/${BRANCH} llvm/tools/lldb
svn co http://llvm.org/svn/llvm-project/polly/${BRANCH} llvm/tools/polly
svn co http://llvm.org/svn/llvm-project/clang-tools-extra/${BRANCH} llvm/tools/clang/tools/extra
