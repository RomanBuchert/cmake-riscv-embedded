##
## Author: Roman Buchert
## License: See LICENSE.TXT file included in the project
##
##
## CMake settings for gd32vf103 family
##

include("${CMAKE_CURRENT_LIST_DIR}/properties.cmake")

# Set the family name of the RISC-V controller
set_property(GLOBAL PROPERTY PROP_SOC_NAME gd32vf103)

# Set the architeture and ABI of the GD32VF103 controller
set_property(GLOBAL PROPERTY PROP_ARCH rv32imac)
set_property(GLOBAL PROPERTY PROP_ABI ilp32)

# Memory settings
set_property(GLOBAL PROPERTY PROP_FLASH_START 0x08000000)
set_property(GLOBAL PROPERTY PROP_RAM_START 0x20000000)

set(LINKER_SCRIPT "${CMAKE_CURRENT_BINARY_DIR}/gcc_link.ld")
