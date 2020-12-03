##
## Author: Roman Buchert
## License: See LICENSE.TXT file included in the project
##
##
## CMake properties for RISC-V
##

# -------------------------------------------------------------------------------------------------
# Architecture and ABI
define_property(VARIABLE PROPERTY PROP_SOC_NAME
	BRIEF_DOCS "Name of the used controller"
	FULL_DOCS  "Name of the used controller"
)

define_property(VARIABLE PROPERTY PROP_ARCH
	BRIEF_DOCS "Architecture of the RISC-V core"
	FULL_DOCS  "Architecture of the RISC-V core"
)

define_property(VARIABLE PROPERTY PROP_ABI
	BRIEF_DOCS "ABI of the RISC-V core"
	FULL_DOCS  "ABI of the RISC-V core"
)
# -------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------
# Memory
define_property(VARIABLE PROPERTY PROP_FLASH_START
	BRIEF_DOCS "Flash start address"
	FULL_DOCS  "Flash start address"
)
	
define_property(VARIABLE PROPERTY PROP_RAM_START
	BRIEF_DOCS "RAM start address"
	FULL_DOCS  "RAM start address"
)

define_property(VARIABLE PROPERTY PROP_FLASH_SIZE
	BRIEF_DOCS "Flash size in bytes"
	FULL_DOCS  "Flash size in bytes"
)

define_property(VARIABLE PROPERTY PROP_RAM_SIZE
	BRIEF_DOCS "RAM size in bytes"
	FULL_DOCS  "RAM size in bytes"
)
# -------------------------------------------------------------------------------------------------
