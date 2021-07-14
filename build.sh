#!/bin/bash

set -e

VERSION=3.17.3
REPO_PATH=repo
BUILD_PATH="${REPO_PATH}/_build"

BUILD_PATH_RELEASE="${BUILD_PATH}/release"
BUILD_PATH_DEBUG="${BUILD_PATH}/debug"

get_suffix() {
	local system_version=$(lsb_release -sr | tr -d '.')
	local system_name=$(lsb_release -si | tr '[:upper:]' '[:lower:]')
	local system_machine=$(uname -m | tr '_' '-')
	echo "${system_machine}-${system_name}-${system_version}"
}

SUFFIX_NAME=$(get_suffix)
build() {
	local source_path="${1}"
	local version="${2}"
	local build_type="${3}"
	local debug_suffix=""
	local build_path="${source_path}/${build_type}"
	mkdir -p "${build_path}"
	if ! [ "${build_type}" == "Release" ]; then
		debug_suffix="d"
	fi
	pushd "${build_path}"
		git checkout v${version}
		./autogen.sh
		./configure --disable-maintainer-mode --disable-shared --prefix="$(pwd)/INSTALL"
		make -j 10
		make INSTALL
		pushd INSTALL
			rm -rf lib/pkgconfig
			zip -r libprotobuf${debug_suffix}-dev_v${version}_${SUFFIX_NAME}.zip ./*
		popd
	popd
	mv ${build_path}/*.zip ./
}



git clone git@github.com:gabime/spdlog.git "${REPO_PATH}"

build "${REPO_PATH}" "${VERSION}" Release
build "${REPO_PATH}" "${VERSION}" Debug

