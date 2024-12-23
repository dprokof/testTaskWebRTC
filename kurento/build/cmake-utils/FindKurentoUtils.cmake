# - Try to find KurentoUtils

#=============================================================================
# Copyright 2014 Kurento
#
#=============================================================================

set(PACKAGE_VERSION "7.1.2~35.g3dcbcd478")
set(KurentoUtils_VERSION ${PACKAGE_VERSION})



# Output variables
# ================

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(KurentoUtils
  FOUND_VAR
    KurentoUtils_FOUND
  REQUIRED_VARS
    KurentoUtils_VERSION
  VERSION_VAR
    KurentoUtils_VERSION
)

mark_as_advanced(
  KurentoUtils_FOUND
  KurentoUtils_VERSION
)



# Log lookup result
# =================

get_filename_component(CURRENT_FILE ${CMAKE_CURRENT_LIST_FILE} NAME)

if(KurentoUtils_FOUND)
  message(STATUS "[${CURRENT_FILE}] Found: ${CMAKE_CURRENT_LIST_DIR}")
else()
  message(STATUS "[${CURRENT_FILE}] Not found")
endif()
