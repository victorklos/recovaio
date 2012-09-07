#
# Recovery utility for SONY Vaio bundled software
#
# Author: Victor Klos
# Date: September 2012
#
# Based on the work of darxide_sorcerer as described at http://forum.notebookreview.com/sony/675143-how-recover-bundled-applications-like-adobe-suite-powerdvd-etc-sonys-hidden-recovery-partition.html
#
# This script helps you recover all installers of bundled applications that
# are present on the recovery partition of your Sony Vaio notebook. If your
# system looks enough like mine, that is. Use this at your own risk, as this
# script may wreck your new gadget or kill your cat. If you are unsure how
# to proceed, then don't.
#
# PREREQUISITES:
# 1) Boot a live CD of a Debian-like system (including Ubuntu or Mint; this
#    may require setting your bios boot option to 'legacy')
# 2) Mount recovery partition (by double-clicking from file browser)
# 3) Attach external disk with plenty of disk space (around 17GB required for
#    app installers plus another 20GB when extracting)
# 4) Open a terminal window, change directory to external disk, make sure
#    you have write access
# 5) get this Makefile; type
#    wget https://raw.github.com/victorklos/recovaio/master/Makefile
#
# TO BEGIN:
# 1) type 'make' to see this helpful help text
# 2) type 'make <keyword>' where <keyword> is one of:
#                all     to perform all steps until but excluding extract
#                copy    to copy the .mod files from the recovery partition
#                patch   to patch the .mod files (they become proper .wim)
#                rename  to rename the .wim files to helpful names
#                extract to extract all .wim files, renamed or not
#                purge   to delete everything
#
MOUNTDIR := $(shell mount | awk '{if (($$1 ~ /dev\/mapper/) && ($$4 ~ /type/) && ($$5 ~ /fuseblk/)) print $$3}')
HASDATA  := $(shell if test -d $(MOUNTDIR)/data ; then echo "YES" ; fi)
SEVENZIP := $(shell which 7z)
WHOAMI   := $(shell whoami)
MODDIR   := mods
WIMDIR   := apps

default:
	@head -32 Makefile

all: header copy patch rename next

header:
	@head -6 Makefile

copy-pre:
	@echo Mount dir: $(MOUNTDIR)
ifeq ($(MOUNTDIR),)
	$(error A Recovery partition does not seem to be mounted. Double-click on it in the file browser and try again.)
endif
ifneq ($(HASDATA), YES)
	$(error Recovery mountpoint <$(MOUNTDIR)> does not seem correct.)
endif

copy: copy-pre
	-@mkdir $(MODDIR)
	@echo Checking number of files to copy...
	@echo Copying $(shell find $(MOUNTDIR)/data -name \*.mod | wc -l) files. This may take a while...
	@find $(MOUNTDIR)/data -name \*.mod -exec cp {} $(MODDIR) \;
	@echo Done copying files from the recovery partition.

patch:
	@echo Generating proper .wim header...
	$(shell /bin/echo -ne '\x4d\x53\x57\x49\x4d\x00\x00\x00\xd0\x00\x00\x00\x00\x0d\x01\x00' > wim.header)
	@echo Patching files...
	@find ${MODDIR} -name \*.mod -exec dd if=wim.header of={} conv=notrunc \;
	@echo Done, removing tmp header file...
	-@rm wim.header
	@echo Done.

rename:
	@echo Renaming mods to wim...
	@find ${MODDIR} -name \*.mod -print0 | xargs -0 -i basename {} .mod | xargs -i mv $(MODDIR)/{}.mod $(MODDIR)/{}.wim
	@echo Done.
	@echo Renaming known files...
	-@mv $(MODDIR)/MODC-176140.wim $(MODDIR)/"puma.wim"
	-@mv $(MODDIR)/MODC-179214.wim $(MODDIR)/"VAIO First Logon Tool.wim"
	-@mv $(MODDIR)/MODC-182533.wim $(MODDIR)/"VAIO Boot Manager.wim"
	-@mv $(MODDIR)/MODC-182535.wim $(MODDIR)/"ISB Utility.wim"
	-@mv $(MODDIR)/MODC-182538.wim $(MODDIR)/"VAIO Startup Setting Tool.wim"
	-@mv $(MODDIR)/MODC-182542.wim $(MODDIR)/"CPU Fan Diagnostic.wim"
	-@mv $(MODDIR)/MODC-182544.wim $(MODDIR)/"VAIO 3D Portal.wim"
	-@mv $(MODDIR)/MODC-183363.wim $(MODDIR)/"VAIO Gesture Control.wim"
	-@mv $(MODDIR)/MODC-183541.wim $(MODDIR)/"Sony Shared Library.wim"
	-@mv $(MODDIR)/MODC-183561.wim $(MODDIR)/"Sony Firmware Extension Parser (driver).wim"
	-@mv $(MODDIR)/MODC-185942.wim $(MODDIR)/"VAIO Data Restore Tool.wim"
	-@mv $(MODDIR)/MODC-185950.wim $(MODDIR)/"VAIO Power Management.wim"
	-@mv $(MODDIR)/MODC-185952.wim $(MODDIR)/"VAIO Hardware Diagnostics.wim"
	-@mv $(MODDIR)/MODC-185961.wim $(MODDIR)/"VAIO Update 5.wim"
	-@mv $(MODDIR)/MODC-185962.wim $(MODDIR)/"Prepare Your VAIO.wim"
	-@mv $(MODDIR)/MODC-187011.wim $(MODDIR)/"VAIO Manual.wim"
	-@mv $(MODDIR)/MODC-187012.wim $(MODDIR)/"EP0000265887.exe.wim"
	-@mv $(MODDIR)/MODC-188769.wim $(MODDIR)/"VAIO Smart Network.wim"
	-@mv $(MODDIR)/MODC-189604.wim $(MODDIR)/"VAIO Control Center.wim"
	-@mv $(MODDIR)/MOD-CSUP.wim $(MODDIR)/"CSup.wim"
	-@mv $(MODDIR)/MODJ-144575.wim $(MODDIR)/"VAIO Location Utility.wim"
	-@mv $(MODDIR)/MODJ-145976.wim $(MODDIR)/"Registry patch - keyboard control panel.wim"
	-@mv $(MODDIR)/MODJ-147785.wim $(MODDIR)/"Registry patch - unattended setup.wim"
	-@mv $(MODDIR)/MODJ-147999.wim $(MODDIR)/"Registry patch - puma.wim"
	-@mv $(MODDIR)/MODJ-148355.wim $(MODDIR)/"Registry patch - shell setup WMI config.wim"
	-@mv $(MODDIR)/MODJ-153097.wim $(MODDIR)/"Registry patch - sysWOW oobe.wim"
	-@mv $(MODDIR)/MODJ-157042.wim $(MODDIR)/"Public desktop clear tool.wim"
	-@mv $(MODDIR)/MODJ-158713.wim $(MODDIR)/"Windows Localpack US Package.wim"
	-@mv $(MODDIR)/MODJ-158715.wim $(MODDIR)/"Restart driver removal tool.wim"
	-@mv $(MODDIR)/MODJ-158721.wim $(MODDIR)/"Windows Localpack AU Package.wim"
	-@mv $(MODDIR)/MODJ-158723.wim $(MODDIR)/"Windows Localpack CA Package.wim"
	-@mv $(MODDIR)/MODJ-158724.wim $(MODDIR)/"Windows Localpack GB Package.wim"
	-@mv $(MODDIR)/MODJ-158728.wim $(MODDIR)/"Windows Localpack ZA Package.wim"
	-@mv $(MODDIR)/MODJ-160112.wim $(MODDIR)/"SetupAPI Log Check.wim"
	-@mv $(MODDIR)/MODJ-164524.wim $(MODDIR)/"Windows Localpack PL Package.wim"
	-@mv $(MODDIR)/MODJ-164527.wim $(MODDIR)/"Windows Localpack TR Package.wim"
	-@mv $(MODDIR)/MODJ-168314.wim $(MODDIR)/"VAIO Peripherals Metadata.wim"
	-@mv $(MODDIR)/MODJ-169133.wim $(MODDIR)/"Registry patch - ReadyBoot.wim"
	-@mv $(MODDIR)/MODJ-170442.wim $(MODDIR)/"Verify File Extensions.wim"
	-@mv $(MODDIR)/MODJ-170454.wim $(MODDIR)/"Microsoft Office 2010 EN.wim"
	-@mv $(MODDIR)/MODJ-171894.wim $(MODDIR)/"Microsoft Office 2010 NL.wim"
	-@mv $(MODDIR)/MODJ-176072.wim $(MODDIR)/"VAIO Drivers lp.cap EN.wim"
	-@mv $(MODDIR)/MODJ-176177.wim $(MODDIR)/"Windows Live Essentials.wim"
	-@mv $(MODDIR)/MODJ-176509.wim $(MODDIR)/"VAIO Customer Experience Improvement Program.wim"
	-@mv $(MODDIR)/MODJ-176612.wim $(MODDIR)/"Microsoft .NET 4.0 NL.wim"
	-@mv $(MODDIR)/MODJ-176679.wim $(MODDIR)/"Microsft BingBar.wim"
	-@mv $(MODDIR)/MODJ-176890.wim $(MODDIR)/"Registry patch - run Prepare Your VAIO on first logon.wim"
	-@mv $(MODDIR)/MODJ-177244.wim $(MODDIR)/"Add Bing Search.wim"
	-@mv $(MODDIR)/MODJ-177324.wim $(MODDIR)/"Sony Verify Updates.wim"
	-@mv $(MODDIR)/MODJ-178185.wim $(MODDIR)/"Registry patch - MSIE something.wim"
	-@mv $(MODDIR)/MODJ-179400.wim $(MODDIR)/"Adobe Acrobat X Standard - EN FR DU.wim"
	-@mv $(MODDIR)/MODJ-179416.wim $(MODDIR)/"McAfee - 1.wim"
	-@mv $(MODDIR)/MODJ-179458.wim $(MODDIR)/"McAfee Integrated Security Platform.wim"
	-@mv $(MODDIR)/MODJ-179497.wim $(MODDIR)/"VAIO Drivers lp.cab NL.wim"
	-@mv $(MODDIR)/MODJ-179506.wim $(MODDIR)/"Adobe Air.wim"
	-@mv $(MODDIR)/MODJ-179564.wim $(MODDIR)/"MSIE Language Pack NL.wim"
	-@mv $(MODDIR)/MODJ-179597.wim $(MODDIR)/"Registry patch - Run kicktool on first logon.wim"
	-@mv $(MODDIR)/MODJ-179610.wim $(MODDIR)/"VAIO Support and VAIO Partners.wim"
	-@mv $(MODDIR)/MODJ-179688.wim $(MODDIR)/"Standalone Windows update KB982018.wim"
	-@mv $(MODDIR)/MODJ-179692.wim $(MODDIR)/"Standalone Windows update KB2492386.wim"
	-@mv $(MODDIR)/MODJ-179706.wim $(MODDIR)/"VAIO Gate default.wim"
	-@mv $(MODDIR)/MODJ-179707.wim $(MODDIR)/"VAIO Gate.wim"
	-@mv $(MODDIR)/MODJ-179817.wim $(MODDIR)/"Adobe Acrobate Reader.wim"
	-@mv $(MODDIR)/MODJ-179834.wim $(MODDIR)/"TriDef 3D Photo Viewer.wim"
	-@mv $(MODDIR)/MODJ-179909.wim $(MODDIR)/"McAfee - 2.wim"
	-@mv $(MODDIR)/MODJ-181438.wim $(MODDIR)/"VAIO Help Support.wim"
	-@mv $(MODDIR)/MODJ-184162.wim $(MODDIR)/"Skype.wim"
	-@mv $(MODDIR)/MODJ-184343.wim $(MODDIR)/"Standalone Windows update KB2570791.wim"
	-@mv $(MODDIR)/MODJ-184487.wim $(MODDIR)/"Sony Media Go.wim"
	-@mv $(MODDIR)/MODJ-185983.wim $(MODDIR)/"Registry patch - VAIO Boot Manager.wim"
	-@mv $(MODDIR)/MODJ-186471.wim $(MODDIR)/"Oracle Jave JRE 1.7.wim"
	-@mv $(MODDIR)/MODJ-186550.wim $(MODDIR)/"Evernote for VAIO.wim"
	-@mv $(MODDIR)/MODJ-186672.wim $(MODDIR)/"Abobe Flash Player 11.wim"
	-@mv $(MODDIR)/MODJ-186812.wim $(MODDIR)/"ArcSoft WebCam Companion 4.wim"
	-@mv $(MODDIR)/MODJ-186914.wim $(MODDIR)/"Sony Imagination Studio Music Content.wim"
	-@mv $(MODDIR)/MODJ-186934.wim $(MODDIR)/"Sony Imagination Studio Suite.wim"
	-@mv $(MODDIR)/MODJ-186956.wim $(MODDIR)/"Roxio Creator LJ.wim"
	-@mv $(MODDIR)/MODJ-186957.wim $(MODDIR)/"CLBD Region Tool.wim"
	-@mv $(MODDIR)/MODJ-186997.wim $(MODDIR)/"Sony SCS Key Injector.wim"
	-@mv $(MODDIR)/MODJ-186998.wim $(MODDIR)/"Sony VAIO Improvement.wim"
	-@mv $(MODDIR)/MODJ-187150.wim $(MODDIR)/"Sony VAIO Easy Connect.wim"
	-@mv $(MODDIR)/MODJ-187732.wim $(MODDIR)/"Intel USB 3.0 Driver.wim"
	-@mv $(MODDIR)/MODJ-187832.wim $(MODDIR)/"Sony VAIO Care.wim"
	-@mv $(MODDIR)/MODJ-187852.wim $(MODDIR)/"Infineon TMP Professional.wim"
	-@mv $(MODDIR)/MODJ-187912.wim $(MODDIR)/"WildTangent Game Suite.wim"
	-@mv $(MODDIR)/MODJ-187915.wim $(MODDIR)/"Adobe Photoshop Elements 10.wim"
	-@mv $(MODDIR)/MODJ-187932.wim $(MODDIR)/"Sony VAIO firstboot progs.wim"
	-@mv $(MODDIR)/MODJ-187933.wim $(MODDIR)/"MSIE Sony Branded.wim"
	-@mv $(MODDIR)/MODJ-187992.wim $(MODDIR)/"PEPE10 Uninstall Fix.wim"
	-@mv $(MODDIR)/MODJ-188072.wim $(MODDIR)/"Sony Music Unlimited URL installer.wim"
	-@mv $(MODDIR)/MODJ-188201.wim $(MODDIR)/"Microsoft Visual C++ 2010 SP1 Redistributable.wim"
	-@mv $(MODDIR)/MODJ-188213.wim $(MODDIR)/"Registry patch - game related.wim"
	-@mv $(MODDIR)/MODJ-188235.wim $(MODDIR)/"Intel WiDi.wim"
	-@mv $(MODDIR)/MODJ-188236.wim $(MODDIR)/"AuthenTec TrueSuite.wim"
	-@mv $(MODDIR)/MODJ-188238.wim $(MODDIR)/"Registry patch - Sony SysEffect.wim"
	-@mv $(MODDIR)/MODJ-188259.wim $(MODDIR)/"NVidia drivers.wim"
	-@mv $(MODDIR)/MODJ-188261.wim $(MODDIR)/"Intel HD Graphics drivers.wim"
	-@mv $(MODDIR)/MODJ-188263.wim $(MODDIR)/"Intel Rapid Storage.wim"
	-@mv $(MODDIR)/MODJ-188264.wim $(MODDIR)/"Fingerprint Sensor Driver (Athentec).wim"
	-@mv $(MODDIR)/MODJ-188265.wim $(MODDIR)/"RealTek Ethernet Controller driver.wim"
	-@mv $(MODDIR)/MODJ-188267.wim $(MODDIR)/"Synaptics Pointing driver.wim"
	-@mv $(MODDIR)/MODJ-188268.wim $(MODDIR)/"RealTek HD Audio driver.wim"
	-@mv $(MODDIR)/MODJ-188269.wim $(MODDIR)/"RealTek PCIE Cardreader driver.wim"
	-@mv $(MODDIR)/MODJ-188271.wim $(MODDIR)/"Intel Bluetooth driver.wim"
	-@mv $(MODDIR)/MODJ-188272.wim $(MODDIR)/"Intel Management Engine Commponents.wim"
	-@mv $(MODDIR)/MODJ-188273.wim $(MODDIR)/"Intel ProSet Wireless drivers.wim"
	-@mv $(MODDIR)/MODJ-188274.wim $(MODDIR)/"Intel Chipset drivers.wim"
	-@mv $(MODDIR)/MODJ-188297.wim $(MODDIR)/"Sony VAIO Transfer.wim"
	-@mv $(MODDIR)/MODJ-188547.wim $(MODDIR)/"ArcSoft restart something.wim"
	-@mv $(MODDIR)/MODJ-188596.wim $(MODDIR)/"Intel AntiTheft signup.wim"
	-@mv $(MODDIR)/MODJ-188759.wim $(MODDIR)/"Sony VAIO ICC Profile.wim"
	-@mv $(MODDIR)/MODJ-188777.wim $(MODDIR)/"Standalone Windows update KB2633952.wim"
	-@mv $(MODDIR)/MODJ-189243.wim $(MODDIR)/"Sony Vegas restart something.wim"
	-@mv $(MODDIR)/MODJ-189518.wim $(MODDIR)/"PowerDVD BD.wim"
	-@mv $(MODDIR)/MODJ-189716.wim $(MODDIR)/"Registry patch - seconds to zero.wim"
	-@mv $(MODDIR)/MOD-ShareMyConnection_HW_Support_Capable.wim $(MODDIR)/"Sony Share My Connection.wim"
	@echo Done.
	@echo Renaming MODDIR
	@mv $(MODDIR) $(WIMDIR)
	@echo Done.

next:
	@echo ========================================================================
	@echo
	@echo All done, please find your recovered apps in the $(WIMDIR) directory.
	@echo
	@echo If you want \(and you have plenty of disk space\) you can unzip
	@echo these installers by entering \'make extract\'.
	@echo


extract-pre:
ifeq (,$(findstring 7z,$(SEVENZIP)))
	$(error 7z seems to be missing. Install with 'sudo apt-get install p7zip-full' and try again.)
endif

extract: extract-pre
	@echo Extracting files...
	@find $(WIMDIR) -name \*.wim -print0 | xargs -0 -l -i basename {} .wim | xargs -i 7z x -y -o$(WIMDIR)/"{}" $(WIMDIR)/{}.wim

	@echo Done.

purge:
	-@rm -rf $(MODDIR) $(WIMDIR)

