#!/bin/bash

pkg="h5py"
pkgopts=$@
cleanup=""

hdf5pref='--hdf5="@AUX_PREFIX@"'
if [ "x$pkgopts" != "x" ]; then
    if [ "x$pkgopts" = "xpkg-config" ]; then
        hdf5pref=""
    else
        hdf5pref="$pkgopts"
    fi
fi

# Note- the download URL includes a checksum and will need to
# be updated when you change this version string.
version=3.1.0

pfile=h5py-${version}.tar.gz
src=$(eval "@TOP_DIR@/tools/fetch_check.sh" https://files.pythonhosted.org/packages/a7/81/20d5d994c91ed8347efda90d32c396ea28254fd8eb9e071e28ee5700ffd5/${pfile} ${pfile})

if [ "x${src}" = "x" ]; then
    echo "Failed to fetch ${pkg}" >&2
    exit 1
fi
cleanup="${src}"

log="../log_${pkg}"

echo "Building ${pkg}..." >&2

rm -rf h5py-${version}
tar xzf ${src} \
    && cd h5py-${version} \
    && cleanup="${cleanup} $(pwd)" \
    && python3 setup.py configure ${hdf5pref} > ${log} \
    && CC="@CC@" python3 setup.py install --prefix "@AUX_PREFIX@" >> ${log} 2>&1

if [ $? -ne 0 ]; then
    echo "Failed to build ${pkg}" >&2
    exit 1
fi

echo "Finished building ${pkg}" >&2
echo "${cleanup}"
exit 0
