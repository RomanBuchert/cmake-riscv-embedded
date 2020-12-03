##
## Author:  Johannes Bruder
## Author for RISC-V: Roman Buchert
## License: See LICENSE.TXT file included in the project
##
##
## CMake riscv-none-embed toolchain file
##

# Append current directory to CMAKE_MODULE_PATH for making device specific cmake modules visible
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})

# Target definition
set(CMAKE_SYSTEM_NAME  Generic)
set(CMAKE_SYSTEM_PROCESSOR riscv)

get_property(RISCV_SOC GLOBAL PROPERTY PROP_SOC_NAME)
message("")
message("-----------------------------------------------------------------------------------------------------------------------------------------------------")
message("Configuring toolchain...")
message("System name:          ${CMAKE_SYSTEM_NAME}")
message("System processor:     ${CMAKE_SYSTEM_PROCESSOR}")
message("RISC-V SoC:           ${RISCV_SOC}")
message("-----------------------------------------------------------------------------------------------------------------------------------------------------")

#---------------------------------------------------------------------------------------
# Set toolchain paths
#---------------------------------------------------------------------------------------
# Set system depended extensions
if(WIN32)
    set(TOOLCHAIN_EXT ".exe" )
else()
    set(TOOLCHAIN_EXT "" )
endif()

if (NOT DEFINED TOOLCHAIN)
	set(TOOLCHAIN riscv-none-embed)
	message("No Toolchain defined. Setting to: ${TOOLCHAIN}")
	message("If you want to use a special Toolchain, set -DTOOLCHAIN=<your-toolchain-prefix>")
else(NOT DEFINED TOOLCHAIN)
	message("Toolchain is defined to: ${TOOLCHAIN}")
endif (NOT DEFINED TOOLCHAIN)

message("\nSearching for ${TOOLCHAIN}-gcc${TOOLCHAIN_EXT}")
find_path(TOOLCHAIN_PATH ${TOOLCHAIN}-gcc${TOOLCHAIN_EXT})
if ("${TOOLCHAIN_PATH}" STREQUAL "TOOLCHAIN_PATH-NOTFOUND")
	message("No Toolchain found")
else ()
	message("Toolchain found in ${TOOLCHAIN_PATH}")
	get_filename_component(TOOLCHAIN_PREFIX ${TOOLCHAIN_PATH} DIRECTORY)
endif()

if(NOT DEFINED TOOLCHAIN_PREFIX)
    if(CMAKE_HOST_SYSTEM_NAME STREQUAL Linux)
        set(TOOLCHAIN_PREFIX "/usr")
    elseif(CMAKE_HOST_SYSTEM_NAME STREQUAL Darwin)
        set(TOOLCHAIN_PREFIX "/usr/local")
    elseif(CMAKE_HOST_SYSTEM_NAME STREQUAL Windows)
        message(STATUS "Please specify the TOOLCHAIN_PREFIX !\n For example: -DTOOLCHAIN_PREFIX=\"C:/Program Files/GNU Tools ARM Embedded\" ")
    else()
        set(TOOLCHAIN_PREFIX "/usr")
        message(STATUS "No TOOLCHAIN_PREFIX specified, using default: " ${TOOLCHAIN_PREFIX})
    endif()
endif()
message("-----------------------------------------------------------------------------------------------------------------------------------------------------")

set(TOOLCHAIN_BIN_DIR ${TOOLCHAIN_PREFIX}/bin)
set(TOOLCHAIN_INC_DIR ${TOOLCHAIN_PREFIX}/${TOOLCHAIN}/include)
set(TOOLCHAIN_LIB_DIR ${TOOLCHAIN_PREFIX}/${TOOLCHAIN}/lib)
message("")
message("-----------------------------------------------------------------------------------------------------------------------------------------------------")
message("Toolchain root    dir is: ${TOOLCHAIN_PREFIX}")
message("Toolchain binary  dir is: ${TOOLCHAIN_BIN_DIR}")
message("Toolchain include dir is: ${TOOLCHAIN_INC_DIR}")
message("Toolchain library dir is: ${TOOLCHAIN_LIB_DIR}")
message("-----------------------------------------------------------------------------------------------------------------------------------------------------")
# Perform compiler test with static library
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

#---------------------------------------------------------------------------------------
# Set compiler/linker flags
#---------------------------------------------------------------------------------------

# Object build options
# -O0                   No optimizations, reduce compilation time and make debugging produce the expected results.
# -fno-builtin          Do not use built-in functions provided by GCC.
# -Wall                 Print only standard warnings, for all use Wextra
# -ffunction-sections   Place each function item into its own section in the output file.
# -fdata-sections       Place each data item into its own section in the output file.
# -fomit-frame-pointer  Omit the frame pointer in functions that don’t need one.

#---------------------------------------------------------------------------------------
# Set architecture and abi flags
#---------------------------------------------------------------------------------------
get_property(RISCV_ARCH GLOBAL PROPERTY PROP_ARCH)
get_property(RISCV_ABI GLOBAL PROPERTY PROP_ABI)
if (NOT DEFINED RISCV_ARCH) 
	set(RISCV_ARCH rv32imac)
	message("RISC-V architecture not defined, set to ${RISCV_ARCH}")
endif()

if (NOT DEFINED RISCV_ABI)
	set(RISCV_ABI ilp32)
	message("RISC-V ABI not defined, set to ${RISCV_ABI}")
endif()

set(OBJECT_GEN_FLAGS "-O0 -fno-builtin -Wall -ffunction-sections -fdata-sections -fomit-frame-pointer -march=${RISCV_ARCH} -mabi=${RISCV_ABI} -mcmodel=medany  -fno-common")

set(CMAKE_C_FLAGS   "${OBJECT_GEN_FLAGS} -std=c17 " CACHE INTERNAL "C Compiler options")
set(CMAKE_CXX_FLAGS "${OBJECT_GEN_FLAGS} -std=c++17 " CACHE INTERNAL "C++ Compiler options")
set(CMAKE_ASM_FLAGS "${OBJECT_GEN_FLAGS} -x assembler-with-cpp " CACHE INTERNAL "ASM Compiler options")
message("")
message("-----------------------------------------------------------------------------------------------------------------------------------------------------")
message("Setting compiler flags")
message("General options:      ${OBJECT_GEN_FLAGS}")
message("C compiler options:   ${CMAKE_C_FLAGS}")
message("C++ compiler options: ${CMAKE_CXX_FLAGS}")
message("ASM compiler options: ${CMAKE_ASM_FLAGS}")
message("-----------------------------------------------------------------------------------------------------------------------------------------------------")


# -Wl,--gc-sections     Perform the dead code elimination.
# --specs=nano.specs    Link with newlib-nano.
# --specs=nosys.specs   No syscalls, provide empty implementations for the POSIX system calls.
set(CMAKE_EXE_LINKER_FLAGS "-Wl,--gc-sections --specs=nano.specs --specs=nosys.specs -march=${RISCV_ARCH} -mabi=${RISCV_ABI} -Wl,-Map=${CMAKE_PROJECT_NAME}.map" CACHE INTERNAL "Linker options")
message("Linker flags")
message("Linker options:       ${CMAKE_EXE_LINKER_FLAGS}")
message("-----------------------------------------------------------------------------------------------------------------------------------------------------")

#---------------------------------------------------------------------------------------
# Set debug/release build configuration Options
#---------------------------------------------------------------------------------------

# Options for DEBUG build
# -Og   Enables optimizations that do not interfere with debugging.
# -g    Produce debugging information in the operating system’s native format.
set(CMAKE_C_FLAGS_DEBUG "-Og -g" CACHE INTERNAL "C Compiler options for debug build type")
set(CMAKE_CXX_FLAGS_DEBUG "-Og -g" CACHE INTERNAL "C++ Compiler options for debug build type")
set(CMAKE_ASM_FLAGS_DEBUG "-g" CACHE INTERNAL "ASM Compiler options for debug build type")
set(CMAKE_EXE_LINKER_FLAGS_DEBUG "" CACHE INTERNAL "Linker options for debug build type")
#message("-----------------------------------------------------------------------------------------------------------------------------------------------------")
message("Options for DEBUG build")
message("C compiler options:   ${CMAKE_C_FLAGS_DEBUG}")
message("C++ compiler options: ${CMAKE_CXX_FLAGS_DEBUG}")
message("Linker options:       ${CMAKE_EXE_LINKER_FLAGS_DEBUG}")
message("-----------------------------------------------------------------------------------------------------------------------------------------------------")

# Options for RELEASE build
# -Os   Optimize for size. -Os enables all -O2 optimizations.
# -flto Runs the standard link-time optimizer.
set(CMAKE_C_FLAGS_RELEASE "-Os -flto" CACHE INTERNAL "C Compiler options for release build type")
set(CMAKE_CXX_FLAGS_RELEASE "-Os -flto" CACHE INTERNAL "C++ Compiler options for release build type")
set(CMAKE_ASM_FLAGS_RELEASE "" CACHE INTERNAL "ASM Compiler options for release build type")
set(CMAKE_EXE_LINKER_FLAGS_RELEASE "-flto" CACHE INTERNAL "Linker options for release build type")
#message("-----------------------------------------------------------------------------------------------------------------------------------------------------")
message("Options for RELEASE build")
message("C compiler options:   ${CMAKE_C_FLAGS_RELEASE}")
message("C++ compiler options: ${CMAKE_CXX_FLAGS_RELEASE}")
message("Linker options:       ${CMAKE_EXE_LINKER_FLAGS_RELEASE}")
message("-----------------------------------------------------------------------------------------------------------------------------------------------------")


#---------------------------------------------------------------------------------------
# Set compilers
#---------------------------------------------------------------------------------------
set(CMAKE_C_COMPILER ${TOOLCHAIN_BIN_DIR}/${TOOLCHAIN}-gcc${TOOLCHAIN_EXT} CACHE INTERNAL "C Compiler")
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_BIN_DIR}/${TOOLCHAIN}-g++${TOOLCHAIN_EXT} CACHE INTERNAL "C++ Compiler")
set(CMAKE_ASM_COMPILER ${TOOLCHAIN_BIN_DIR}/${TOOLCHAIN}-gcc${TOOLCHAIN_EXT} CACHE INTERNAL "ASM Compiler")
#message("-----------------------------------------------------------------------------------------------------------------------------------------------------")
message("Used compilers")
message("C compiler:           ${CMAKE_C_COMPILER}")
message("C++ compiler:         ${CMAKE_CXX_COMPILER}")
message("ASM compiler:         ${CMAKE_ASM_COMPILER}")
message("-----------------------------------------------------------------------------------------------------------------------------------------------------")
message("")
set(CMAKE_FIND_ROOT_PATH ${TOOLCHAIN_PREFIX}/${${TOOLCHAIN}} ${CMAKE_PREFIX_PATH})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
