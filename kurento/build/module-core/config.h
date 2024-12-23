#ifndef __KURENTO_MODULE_CORE_CONFIG_H__
#define __KURENTO_MODULE_CORE_CONFIG_H__

/* Version */
#define VERSION "7.1.2~35.g3dcbcd478"

/* Package name*/
#define PACKAGE "kurento-module-core"

/* The gettext domain name */
#define GETTEXT_PACKAGE "kurento-module-core"

/* Tests will generate files for manual check if this macro is defined */
/* #undef MANUAL_CHECK */

/* Library installation directory
 * This is set by CMake to the value of
 * CMAKE_INSTALL_PREFIX/CMAKE_INSTALL_LIBDIR/KURENTO_MODULES_DIR_INSTALL_PREFIX
 *
 * Debian packages have "/usr/lib/x86_64-linux-gnu/kurento/modules"
 * and local builds have "/usr/local/lib/kurento/modules"
 */
#define KURENTO_MODULES_DIR "/usr/local/lib/kurento/modules"

#define HAS_STD_REGEX_REPLACE 1

#endif /* __KURENTO_MODULE_CORE_CONFIG_H__ */
