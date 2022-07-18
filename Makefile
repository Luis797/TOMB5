#---------------------------------------------------------------------------------
# Lameguy's general-purpose makefile for PSX development
# (for official PlayStation SDK)
# 2017 Meido-Tek Productions
#
# Use mingw32-make (included with MinGW GCC compiler) to run this makefile. You may
# also need to setup msys and assign it to your PATH environment to get the clean
# and cleanall rules to work as make cannot execute del and rm is used instead.
#
# Download msys here:
# https://sourceforge.net/projects/devkitpro/files/tools/msys%201.0.17/msys-1.0.17-1.exe/download
#
# NOTE: Do not use msys' make program! Its bugged in Win9x and may delete your souce
# files when you clean and some programs such as asmpsx cannot read the arguments
# when run by it.
#
# For ISO build to work, you will need mkpsxiso and Orion's Win32 version of cpe2x.
# mkpsxiso: https://github.com/Lameguy64/mkpsxiso
# cpe2x: http://onorisoft.free.fr/rdl.php?url=psx/cpe2x.zip
#---------------------------------------------------------------------------------

#---------------------------------------------------------------------------------
# TARGET	- Name of the output
# PROGADDR	- Program load address (0x80010000 is the default)
# SOURCES	- Source directories (. for current directory)
# INCLUDES	- Include search directories
# ISOXML	- Name of mkpsxiso ISO project script
#---------------------------------------------------------------------------------
TARGET      = MAIN
PROGADDR	= 0x00010000
SOURCES		= SPEC_PSX/ GAME/
INCLUDES	= SPEC_PSX/ GAME/
DEFS		= PSX_VERSION DISC_VERSION NTSC_VERSION USE_ASM RELOC
ISOXML		= TOMB5US.XML
DISC_ROOTFD	= DISC/

#---------------------------------------------------------------------------------
# USE_SLINK	- Flag to use SLINK, otherwise PSYLINK is used
#---------------------------------------------------------------------------------
USE_SLINK = FALSE

#---------------------------------------------------------------------------------
# LIBDIRS	- Library search directories
# LIBS		- Libraries to link during linking stage
#---------------------------------------------------------------------------------
LIBDIRS		=
LIBS		= LIBETC.LIB LIBPAD.LIB LIBGTE.LIB LIBMCRD.LIB LIBCD.LIB LIBSN.LIB LIBSPU.LIB LIBAPI.LIB

#---------------------------------------------------------------------------------
# CFLAGS	- Base C compiler options
# AFLAGS	- Base assembler options
#---------------------------------------------------------------------------------
CFLAGS		= -Xm -comments-c++ -g -Wall -O2 -G256
AFLAGS		= /g /l /zd /oat+,w-,c+ /q

#---------------------------------------------------------------------------------
# Specific options to debug capable environments (debug options are only usable with
# SN Debugger and a DTL-H2000, 2500 or the Parallel Port based PsyQ/SN Blue Dongle)
# (you must set an H2000 environment variable with TRUE to compile with debug options)
#---------------------------------------------------------------------------------
ifeq "$(H2000)" "TRUE"
CFLAGS		+= -g -DH2000
AFLAGS		+= /zd
endif

#---------------------------------------------------------------------------------
## CC		- C compiler (usually ccpsx)
## AS		- Assembler (usually asmpsx)
#---------------------------------------------------------------------------------
CC			= ccpsx
AS			= asmpsx

#---------------------------------------------------------------------------------
# Parse source directories for source files
#---------------------------------------------------------------------------------
#CFILES		= $(foreach dir,$(SOURCES),$(wildcard $(dir)/*.C))
AFILES		= $(foreach dir,$(SOURCES),$(wildcard $(dir)/*.MIP))

#CFILES =   GAME/CAMERA.C GAME/OBJLIGHT.C SPEC_PSX/SPUSOUND.C SPEC_PSX/LOAD_LEV.C SPEC_PSX/GPU.C SPEC_PSX/PSXMAIN.C SPEC_PSX/LOADSAVE.C SPEC_PSX/PROFILE.C SPEC_PSX/MEMCARD.C SPEC_PSX/REQUEST.C SPEC_PSX/SPECIFIC.C SPEC_PSX/MALLOC.C SPEC_PSX/3D_GEN.C SPEC_PSX/DRAWSPKS.C SPEC_PSX/MOVIE.C SPEC_PSX/CD.C SPEC_PSX/3D_OBJ.C SPEC_PSX/ROOMLOAD.C SPEC_PSX/PSXINPUT.C SPEC_PSX/DRAWPHAS.C SPEC_PSX/PSOUTPUT.C SPEC_PSX/FILE.C SPEC_PSX/SETUP.C GAME/ROPE.C GAME/DELSTUFF.C GAME/SAVEGAME.C GAME/SOUND.C GAME/JOBY5.C GAME/MISSILE.C GAME/TOWER2.C GAME/RICH2.C GAME/OBJECTS.C GAME/EFFECTS.C GAME/LARACLMB.C GAME/SPHERE.C GAME/TOMB4FX.C GAME/RAT.C GAME/RICH3.C GAME/ANDREA1.C GAME/ITEMS.C GAME/ANDY1.C GAME/FLMTORCH.C GAME/MAFIA2.C GAME/ANDY3.C GAME/FOOTPRNT.C GAME/TOWER3.C GAME/CODEWAD.C GAME/SWITCH.C GAME/HAIR.C GAME/JOBY1.C GAME/ANDREA2.C GAME/ANDREA3.C GAME/LARASWIM.C GAME/RICHCUT2.C GAME/JOBY4.C GAME/TEXT.C GAME/FONT.C GAME/DEBRIS.C GAME/SPOTCAM.C GAME/GAMEFLOW.C GAME/LOT.C GAME/DELTAPAK.C GAME/JOBY2.C GAME/PICKUP.C GAME/ANIM.C GAME/ANDY2.C GAME/BOX.C GAME/JOBY3.C GAME/TWOGUN.C GAME/TRAPS.C GAME/COLLIDE.C GAME/PEOPLE.C GAME/NEWINV2.C GAME/LARAFLAR.C GAME/LARAMISC.C GAME/LARA1GUN.C GAME/LARA2GUN.C GAME/LARASURF.C GAME/GUARDIAN.C GAME/TOWER1.C GAME/CONTROL.C GAME/DRAW.C GAME/EFFECT2.C GAME/DOOR.C GAME/RICH1.C GAME/LARA.C GAME/HYDRA.C GAME/LARAFIRE.C GAME/HEALTH.C

##Same as original
CFILES =    SPEC_PSX/PSXMAIN.C GAME/LARA.C SPEC_PSX/SPUSOUND.C GAME/OBJLIGHT.C SPEC_PSX/GPU.C SPEC_PSX/LOAD_LEV.C GAME/GAMEFLOW.C GAME/CONTROL.C GAME/TEXT.C GAME/DELSTUFF.C GAME/DELTAPAK.C GAME/DOOR.C GAME/DRAW.C GAME/BOX.C GAME/CAMERA.C GAME/COLLIDE.C GAME/ITEMS.C GAME/DEBRIS.C GAME/SPOTCAM.C GAME/EFFECT2.C GAME/TOMB4FX.C GAME/EFFECTS.C GAME/FLMTORCH.C GAME/HAIR.C GAME/HEALTH.C GAME/NEWINV2.C GAME/LARAFIRE.C GAME/LARAFLAR.C GAME/LARA1GUN.C GAME/LARA2GUN.C GAME/LARACLMB.C GAME/LARASWIM.C GAME/LARASURF.C GAME/LOT.C GAME/LARAMISC.C GAME/MISSILE.C GAME/OBJECTS.C GAME/PEOPLE.C GAME/SAVEGAME.C GAME/SOUND.C GAME/SPHERE.C GAME/SWITCH.C GAME/PICKUP.C SPEC_PSX/3D_GEN.C SPEC_PSX/CD.C GAME/TRAPS.C SPEC_PSX/FILE.C SPEC_PSX/MALLOC.C SPEC_PSX/3D_OBJ.C SPEC_PSX/PSXINPUT.C SPEC_PSX/ROOMLOAD.C SPEC_PSX/DRAWSPKS.C SPEC_PSX/PSOUTPUT.C SPEC_PSX/SPECIFIC.C SPEC_PSX/PROFILE.C SPEC_PSX/MEMCARD.C SPEC_PSX/LOADSAVE.C SPEC_PSX/REQUEST.C SPEC_PSX/DRAWPHAS.C SPEC_PSX/MOVIE.C GAME/CODEWAD.C GAME/LION.C
#CFILES =   SPEC_PSX/PSXMAIN.C GAME/GAMEFLOW.C GAME/CONTROL.C GAME/TEXT.C GAME/LARA.C GAME/DELSTUFF.C GAME/DELTAPAK.C GAME/DOOR.C GAME/DRAW.C GAME/BOX.C GAME/CAMERA.C GAME/COLLIDE.C GAME/ITEMS.C GAME/DEBRIS.C GAME/SPOTCAM.C GAME/EFFECT2.C GAME/TOMB4FX.C GAME/EFFECTS.C GAME/FLMTORCH.C GAME/HAIR.C GAME/HEALTH.C GAME/NEWINV2.C GAME/LARAFIRE.C GAME/LARAFLAR.C GAME/LARA1GUN.C GAME/LARA2GUN.C GAME/LARACLMB.C GAME/LARASWIM.C GAME/LARASURF.C GAME/LOT.C GAME/LARAMISC.C GAME/MISSILE.C GAME/OBJECTS.C GAME/PEOPLE.C GAME/SAVEGAME.C GAME/SOUND.C GAME/SPHERE.C GAME/SWITCH.C GAME/PICKUP.C GAME/OBJLIGHT.C SPEC_PSX/3D_GEN.C SPEC_PSX/CD.C GAME/TRAPS.C SPEC_PSX/GPU.C SPEC_PSX/FILE.C SPEC_PSX/MALLOC.C SPEC_PSX/3D_OBJ.C SPEC_PSX/PSXINPUT.C SPEC_PSX/ROOMLOAD.C SPEC_PSX/LOAD_LEV.C SPEC_PSX/DRAWSPKS.C SPEC_PSX/PSOUTPUT.C SPEC_PSX/SPECIFIC.C SPEC_PSX/PROFILE.C SPEC_PSX/MEMCARD.C SPEC_PSX/SPUSOUND.C SPEC_PSX/LOADSAVE.C SPEC_PSX/REQUEST.C SPEC_PSX/DRAWPHAS.C SPEC_PSX/SETUP.C SPEC_PSX/MOVIE.C GAME/CODEWAD.C GAME/ROPE.C   GAME/JOBY5.C  GAME/TOWER2.C GAME/RICH2.C      GAME/RAT.C GAME/RICH3.C GAME/ANDREA1.C  GAME/ANDY1.C  GAME/MAFIA2.C GAME/ANDY3.C GAME/FOOTPRNT.C GAME/TOWER3.C    GAME/JOBY1.C GAME/ANDREA2.C GAME/ANDREA3.C  GAME/RICHCUT2.C GAME/JOBY4.C  GAME/FONT.C    GAME/JOBY2.C  GAME/ANIM.C GAME/ANDY2.C  GAME/JOBY3.C GAME/TWOGUN.C          GAME/GUARDIAN.C GAME/TOWER1.C   GAME/RICH1.C GAME/HYDRA.C
RFILES = GAME/JOBY5.C GAME/SETUP.C GAME/ANDY3.C SPEC_PSX/TITSEQ.C
RFILESA = SPEC_PSX/LARA1.MIP

#---------------------------------------------------------------------------------
# Generate file names for object binaries
#---------------------------------------------------------------------------------
OFILES		= $(AFILES:.MIP=.obj) $(CFILES:.C=.obj) $(RFILES:.C=.obj) $(RFILESA:.MIP=.obj)

#---------------------------------------------------------------------------------
# Default rule, compiles all source files
#---------------------------------------------------------------------------------
all: $(OFILES)
	$(CC) -Xo$(PROGADDR) $(CFLAGS) $(addprefix -L,$(LIBDIRS)) $(addprefix -l,$(LIBS)) $(OFILES) $(ROFILES)
ifeq "$(USE_SLINK)" "TRUE"
	PSX_SLINK.BAT
else
	PSX_LINK.BAT
endif
#---------------------------------------------------------------------------------
# Clean-up rule
#---------------------------------------------------------------------------------
clean: cleanall

#---------------------------------------------------------------------------------
# ISO build rule (requires MKPSXISO)
#---------------------------------------------------------------------------------
iso:
	cpe2x $(DISC_ROOTFD)$(TARGET).CPE
	cd DISC
	mkpsxisox.exe $(ISOXML)

#---------------------------------------------------------------------------------
# Rule for compiling C source
#---------------------------------------------------------------------------------
%.obj: %.C
	$(CC) $(addprefix -D,$(DEFS)) $(CFLAGS) $(addprefix -I,$(INCLUDES)) -c $< -o $@

#---------------------------------------------------------------------------------
# Rule for assembling assembly source
#---------------------------------------------------------------------------------
%.obj: %.MIP
	$(AS) $(AFLAGS) $<,$@