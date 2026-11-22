# coproto's AsioSocket.h defines COPROTO_ASIO_LOG and COPROTO_ASIO_DEBUG
# outside its NDEBUG guard, so they are on in every build. The log vector
# is written from Asio's io threads and eventually throws
# std::length_error ("vector"). Included via CMAKE_PROJECT_coproto_INCLUDE,
# which runs at the end of project(coproto), before that project compiles.
if(NOT DEFINED COPROTO_SOURCE_DIR)
    set(COPROTO_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}")
endif()

set(_asio "${COPROTO_SOURCE_DIR}/coproto/Socket/AsioSocket.h")
if(NOT EXISTS "${_asio}")
    message(FATAL_ERROR "coproto AsioSocket.h not found at ${_asio}")
endif()
file(READ "${_asio}" _hdr)
string(REGEX REPLACE
    "#define COPROTO_ASIO_LOG"
    "#undef COPROTO_ASIO_LOG"
    _hdr "${_hdr}")
string(REGEX REPLACE
    "#define COPROTO_ASIO_DEBUG"
    "#undef COPROTO_ASIO_DEBUG"
    _hdr "${_hdr}")
file(WRITE "${_asio}" "${_hdr}")
message(STATUS "coproto: COPROTO_ASIO_LOG and COPROTO_ASIO_DEBUG disabled")
