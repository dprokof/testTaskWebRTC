# - Try to find KmsJsonRpc library

#=============================================================================
# Copyright 2014 Kurento
#
#=============================================================================

set(PACKAGE_VERSION "7.1.2~35.g3dcbcd478")
set(KmsJsonRpc_VERSION ${PACKAGE_VERSION})



# Include directories
# ===================

find_package(PkgConfig)
pkg_check_modules(_JSONCPP REQUIRED jsoncpp>=1.7.2)

find_path(KmsJsonRpc_INCLUDE_DIR
  NAMES
    jsonrpc/JsonRpcHandler.hpp
    jsonrpc/JsonRpcException.hpp
    jsonrpc/JsonSerializer.hpp
    jsonrpc/JsonRpcUtils.hpp
    jsonrpc/JsonRpcConstants.hpp
  PATH_SUFFIXES
    src
    kurento
)

set(KmsJsonRpc_INCLUDE_DIRS
  ${KmsJsonRpc_INCLUDE_DIR}
  ${_JSONCPP_INCLUDE_DIRS}
  CACHE INTERNAL "Include directories for KmsJsonRpc library"
)



# Path to library
# ===============

set(JSON_CPP_BINARY_DIR_PREFIX "build" CACHE PATH "Path prefix used to look for binary files")

if(TARGET jsonrpc)
  #Just get the target for the library
  set(KmsJsonRpc_LIBRARY jsonrpc)
else()
  find_library(KmsJsonRpc_LIBRARY
    NAMES
      jsonrpc
    PATH_SUFFIXES
      ${JSON_CPP_BINARY_DIR_PREFIX}/src
  )
endif()

set(KmsJsonRpc_LIBRARIES
  ${KmsJsonRpc_LIBRARY}
  ${_JSONCPP_LIBRARIES}
  CACHE INTERNAL "Libraries for KmsJsonRpc"
)



# Output variables
# ================

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(KmsJsonRpc
  FOUND_VAR
    KmsJsonRpc_FOUND
  REQUIRED_VARS
    KmsJsonRpc_VERSION
    KmsJsonRpc_INCLUDE_DIR
    KmsJsonRpc_INCLUDE_DIRS
    KmsJsonRpc_LIBRARY
    KmsJsonRpc_LIBRARIES
  VERSION_VAR
    KmsJsonRpc_VERSION
)

mark_as_advanced(
  KmsJsonRpc_FOUND
  KmsJsonRpc_VERSION
  KmsJsonRpc_INCLUDE_DIR
  KmsJsonRpc_INCLUDE_DIRS
  KmsJsonRpc_LIBRARY
  KmsJsonRpc_LIBRARIES
)



# Log lookup result
# =================

get_filename_component(CURRENT_FILE ${CMAKE_CURRENT_LIST_FILE} NAME)

if(KmsJsonRpc_FOUND)
  message(STATUS "[${CURRENT_FILE}] Found: ${KmsJsonRpc_LIBRARY}")
else()
  message(STATUS "[${CURRENT_FILE}] Not found")
endif()
