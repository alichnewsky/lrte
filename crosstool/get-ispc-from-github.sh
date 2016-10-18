#!/bin/bash -e


# get the proper ispc commit

COMMIT="d4a8afd6e8fe04969a26f69bca7e0c4d6f3ecd99"
GIT_TOP=${GIT_TOP:-upstream}

cd ${GIT_TOP}
git clone https://github.com/ispc/ispc.git ispc
cd ispc
git reset --hard ${COMMIT}

# patches?
