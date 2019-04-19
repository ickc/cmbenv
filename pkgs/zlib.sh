#!/bin/bash

pkg="zlib"
pkgopts=$@
cleanup=""

pfile=zlib-1.2.11.tar.gz
src=$(eval "@TOP_DIR@/tools/fetch_check.sh" http://zlib.net/${pfile} ${pfile})

if [ "x${src}" = "x" ]; then
    echo "Failed to fetch ${pkg}" >&2
    exit 1
fi
cleanup="${src}"

log="../log_${pkg}"

echo "Building ${pkg}..." >&2

rm -rf zlib-1.2.11
tar xzf ${src} \
    && cd zlib-1.2.11 \
    && CC="@BUILD_CC@" ./configure \
    --shared --prefix="@AUX_PREFIX@" > ${log} 2>&1 \
    && make -j @MAKEJ@ >> ${log} 2>&1 \
    && make install >> ${log} 2>&1

if [ $? -ne 0 ]; then
    echo "Failed to build ${pkg}" >&2
    exit 1
fi

echo "Finished building ${pkg}" >&2
echo "${cleanup}"
exit 0