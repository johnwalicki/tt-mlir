include(ExternalProject)

set(TT_METAL_VERSION "82ba2cbad64d1e36cad446d1f2f9bd266883ae74")

if ("$ENV{ARCH_NAME}" STREQUAL "grayskull")
  set(ARCH_NAME "grayskull")
  set(ARCH_EXTRA_DIR "grayskull")
elseif ("$ENV{ARCH_NAME}" STREQUAL "wormhole_b0")
  set(ARCH_NAME "wormhole")
  set(ARCH_EXTRA_DIR "wormhole/wormhole_b0_defines")
elseif ("$ENV{ARCH_NAME}" STREQUAL "blackhole")
  set(ARCH_NAME "blackhole")
  set(ARCH_EXTRA_DIR "blackhole")
else()
  message(FATAL_ERROR "Unsupported ARCH_NAME: $ENV{ARCH_NAME}")
endif()

set(METAL_INSTALL_PREFIX "${PROJECT_SOURCE_DIR}/third_party/tt-metal/src/tt-metal-build/")
set(TTMETAL_INCLUDE_DIRS
  ${PROJECT_SOURCE_DIR}/third_party/tt-metal/src/tt-metal/ttnn/cpp
  ${PROJECT_SOURCE_DIR}/third_party/tt-metal/src/tt-metal/ttnn/cpp/ttnn/deprecated
  ${PROJECT_SOURCE_DIR}/third_party/tt-metal/src/tt-metal
  ${PROJECT_SOURCE_DIR}/third_party/tt-metal/src/tt-metal/tt_metal
  ${PROJECT_SOURCE_DIR}/third_party/tt-metal/src/tt-metal/tt_metal/third_party/umd
  ${PROJECT_SOURCE_DIR}/third_party/tt-metal/src/tt-metal/tt_metal/third_party/umd/device
  ${PROJECT_SOURCE_DIR}/third_party/tt-metal/src/tt-metal/tt_metal/hw/inc
  ${PROJECT_SOURCE_DIR}/third_party/tt-metal/src/tt-metal/tt_metal/hw/inc/${ARCH_NAME}
  ${PROJECT_SOURCE_DIR}/third_party/tt-metal/src/tt-metal/tt_metal/hw/inc/${ARCH_EXTRA_DIR}
  ${PROJECT_SOURCE_DIR}/third_party/tt-metal/src/tt-metal/tt_metal/third_party/umd/src/firmware/riscv/${ARCH_NAME}
  ${PROJECT_SOURCE_DIR}/third_party/tt-metal/src/tt-metal/tt_eager
  ${PROJECT_SOURCE_DIR}/third_party/tt-metal/src/tt-metal/.cpmcache/reflect/e75434c4c5f669e4a74e4d84e0a30d7249c1e66f
  ${PROJECT_SOURCE_DIR}/third_party/tt-metal/src/tt-metal/.cpmcache/nanomsg/28cc32d5bdb6a858fe53b3ccf7e923957e53eada/include
  ${PROJECT_SOURCE_DIR}/third_party/tt-metal/src/tt-metal/.cpmcache/fmt/73b5ec45edbd92babfd91c3777a9e1ab9cac8238/include
  ${PROJECT_SOURCE_DIR}/third_party/tt-metal/src/tt-metal/.cpmcache/magic_enum/1e1af177d4ab0ef660f105434fd1017c4d1f8c17/include/magic_enum
  ${PROJECT_SOURCE_DIR}/third_party/tt-metal/src/tt-metal/.cpmcache/boost_core/e679bef5c160cf29d0f37d549881dc5f5a58c332/include
  PARENT_SCOPE
)

set(TTMETAL_LIBRARY_DIR ${PROJECT_SOURCE_DIR}/third_party/tt-metal/src/tt-metal-build/lib)
set(TTNN_LIBRARY_PATH ${TTMETAL_LIBRARY_DIR}/_ttnn.so)
set(TTMETAL_LIBRARY_PATH ${TTMETAL_LIBRARY_DIR}/libtt_metal.so)
if (TT_RUNTIME_ENABLE_PERF_TRACE)
  set(TRACY_LIBRARY_PATH ${TTMETAL_LIBRARY_DIR}/libtracy.so)
else()
  set(TRACY_LIBRARY_PATH "")
endif()

set(TTMETAL_LIBRARY_DIR ${TTMETAL_LIBRARY_DIR} PARENT_SCOPE)
set(TTNN_LIBRARY_PATH ${TTNN_LIBRARY_PATH} PARENT_SCOPE)
set(TTMETAL_LIBRARY_PATH ${TTMETAL_LIBRARY_PATH} PARENT_SCOPE)
set(TRACY_LIBRARY_PATH ${TRACY_LIBRARY_PATH} PARENT_SCOPE)

ExternalProject_Add(
  tt-metal
  PREFIX ${TTMLIR_SOURCE_DIR}/third_party/tt-metal
  CMAKE_GENERATOR Ninja
  CMAKE_ARGS
    -DCMAKE_BUILD_TYPE=Release
    -DCMAKE_INSTALL_PREFIX=${METAL_INSTALL_PREFIX}
    -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
    -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
    -DCMAKE_CXX_COMPILER_LAUNCHER=${CMAKE_CXX_COMPILER_LAUNCHER}
    -DENABLE_TRACY=${TT_RUNTIME_ENABLE_PERF_TRACE}
    -DENABLE_LIBCXX=OFF
  GIT_REPOSITORY https://github.com/tenstorrent/tt-metal.git
  GIT_TAG ${TT_METAL_VERSION}
  GIT_PROGRESS ON
  BUILD_BYPRODUCTS ${TTNN_LIBRARY_PATH} ${TTMETAL_LIBRARY_PATH} ${TRACY_LIBRARY_PATH}
)

set_target_properties(tt-metal PROPERTIES EXCLUDE_FROM_ALL TRUE)

list(APPEND library_names TTNN_LIBRARY TTMETAL_LIBRARY)
list(APPEND library_paths ${TTNN_LIBRARY_PATH} ${TTMETAL_LIBRARY_PATH})

if (TT_RUNTIME_ENABLE_PERF_TRACE)
  list(APPEND library_names TRACY_LIBRARY)
  list(APPEND library_paths ${TRACY_LIBRARY_PATH})
endif()

foreach(lib_name lib_path IN ZIP_LISTS library_names library_paths)
  add_library(${lib_name} SHARED IMPORTED GLOBAL)
  set_target_properties(${lib_name} PROPERTIES EXCLUDE_FROM_ALL TRUE IMPORTED_LOCATION ${lib_path})
  add_dependencies(${lib_name} tt-metal)
endforeach()

install(FILES ${library_paths} DESTINATION ${CMAKE_INSTALL_LIBDIR} COMPONENT SharedLib)
