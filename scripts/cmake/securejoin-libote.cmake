# Included at the end of SecureJoin's project() via
# CMAKE_PROJECT_secureJoin_INCLUDE. SecureJoin is configured with --noauto,
# so it finds the libOTe we already installed instead of compiling another one.
#
# That install exports oc::libOTe and oc::tests_cryptoTools. SecureJoin's
# CMakeLists links the names add_subdirectory() would have created. Alias
# those names to the imported targets. Do not make a new library: install(EXPORT)
# accepts an imported target, and the alias is resolved to it.

if(NOT TARGET oc::libOTe)
    # The prefix from --noauto. Do not accept a libOTe installed under /usr/local.
    find_package(libOTe CONFIG REQUIRED NO_DEFAULT_PATH PATHS ${CMAKE_PREFIX_PATH})
endif()

message(STATUS "SecureJoin using installed libOTe from ${libOTe_DIR}")

if(NOT TARGET libOTe)
    add_library(libOTe ALIAS oc::libOTe)
endif()

if(NOT TARGET oc::tests_cryptoTools)
    find_package(cryptoTools CONFIG REQUIRED NO_DEFAULT_PATH PATHS ${CMAKE_PREFIX_PATH})
endif()

if(NOT TARGET tests_cryptoTools)
    add_library(tests_cryptoTools ALIAS oc::tests_cryptoTools)
endif()
