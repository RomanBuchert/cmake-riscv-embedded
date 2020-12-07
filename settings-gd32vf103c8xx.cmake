##
## Author: Roman Buchert
## License: See LICENSE.TXT file included in the project
##
##
## CMake settings for gd32vf103 family
##

# Include the settings for the controller family
include("${CMAKE_CURRENT_LIST_DIR}/settings-gd32vf103-family.cmake")

# Append device specific configuration on controller name
set_property(GLOBAL APPEND_STRING PROPERTY PROP_SOC_NAME "cb")

# Memory settings
set_property(GLOBAL PROPERTY PROP_FLASH_SIZE 64k)
set_property(GLOBAL PROPERTY PROP_RAM_SIZE 20k)

get_property(FLASH_START
	GLOBAL
	PROPERTY PROP_FLASH_START
)

get_property(FLASH_SIZE
	GLOBAL
	PROPERTY PROP_FLASH_SIZE
)

get_property(RAM_START
	GLOBAL
	PROPERTY PROP_RAM_START
)

get_property(RAM_SIZE
	GLOBAL
	PROPERTY PROP_RAM_SIZE
)

configure_file(
	"${CMAKE_CURRENT_LIST_DIR}/linkerscripts/gcc_gd32vf103.ld.in"
	"${CMAKE_CURRENT_BINARY_DIR}/gcc_link.ld"
)
