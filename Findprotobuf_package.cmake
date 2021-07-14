##
#
# Download and initialize variable Protobuf_ROOT
#

IF(NOT CMAKE_BUILD_TYPE)
	MESSAGE(FATAL_ERROR "Protobuf package does not provide multi-conf support!")
ENDIF()

FIND_PACKAGE(CMLIB REQUIRED)
CMLIB_DEPENDENCY(
	URI "https://github.com/bringauto/cmake-package-tools.git"
	URI_TYPE GIT
	TYPE MODULE
)
FIND_PACKAGE(CMAKE_PACKAGE_TOOLS REQUIRED)

SET(platform_string)
CMAKE_PACKAGE_TOOLS_PLATFORM_STRING(platform_string)

SET(protobuf_url)
IF(CMAKE_BUILD_TYPE STREQUAL "Debug")
	SET(spdlog_url
		"https://github.com/bringauto/spdlog-package/releases/download/v1.8.5/libspdlogd-dev_v1.8.5_${platform_string}.zip"
	)
ELSE()
	SET(spdlog_url
		"https://github.com/bringauto/spdlog-package/releases/download/v1.8.5/libspdlog-dev_v1.8.5_${platform_string}.zip"
	)
ENDIF()

CMLIB_DEPENDENCY(
	URI "${protobuf_url}"
	TYPE ARCHIVE
	OUTPUT_PATH_VAR _protobuf_ROOT
)

SET(Protobuf_ROOT "${_protobuf_ROOT}"
	CACHE STRING
	"protobuf root directory"
	FORCE
)

UNSET(_protobuf_ROOT)
UNSET(protobuf_url)
UNSET(platform_string)
