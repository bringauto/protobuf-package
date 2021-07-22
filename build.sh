#!/bin/bash

set -e

VERSION=3.17.3
REPO_PATH=repo
BUILD_PATH="${REPO_PATH}/_build"

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
	local build_path="${source_path}/"
	local install_path="$(pwd)/INSTALL"
	if [ "${build_type}" == "Debug" ]; then
		debug_suffix="d"
	fi

	if ! [ -d "${install_path}" ]; then
		pushd "${build_path}"
			git checkout v${version}
			git submodule update --init --recursive
			./autogen.sh
			./configure --disable-maintainer-mode --disable-shared --prefix="${install_path}"
			make -j 10
			make install
		popd
	fi

	pushd "${install_path}"
		rm -rf lib/pkgconfig
		zip -r libprotobuf${debug_suffix}-dev_v${version}_${SUFFIX_NAME}.zip ./*
	popd
	mv ${install_path}/*.zip ./
}


if ! [ -d "${REPO_PATH}" ]; then
	git clone https://github.com/protocolbuffers/protobuf.git "${REPO_PATH}"
fi

build "${REPO_PATH}" "${VERSION}" Release
build "${REPO_PATH}" "${VERSION}" Debug

