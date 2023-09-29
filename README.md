# This project is archived

---

# recovaio

Recovery utility for SONY Vaio bundled software, based on the work of *darxide_sorcerer* as described at [forum.notebookreview.com](http://forum.notebookreview.com/sony/675143-how-recover-bundled-applications-like-adobe-suite-powerdvd-etc-sonys-hidden-recovery-partition.html).

This script helps you recover all installers of bundled applications that
are present on the recovery partition of your Sony Vaio notebook. If your
system looks enough like mine, that is. To use it, you need a Debian-based
linux live CD and an external hard disk with plenty of room.

> **This script requires booting a linux live CD and fiddling with the
recovery partition of your Sony Vaio. Use it at your OWN RISK! If you
are unsure how to proceed, then STOP NOW!**

## Usage
*   _Boot a live CD of a Debian-like system_

    including Ubuntu or Mint; this may require setting your bios boot option to *legacy* instead of EFI

*   _Mount the recovery partition_

    by double-clicking on 'Recovery' from the file browser

*   _Attach an external disk with plenty of disk space_

    around 17GB required for app installers plus another 20GB when extracting (optional)

*   _Open a terminal window_

    then change the working directory to your external disk and make sure you have write access, e.g.:
    <pre>
        cd /media/MyDisk
        mkdir recovery
        cd recovery
    </pre>

    Change 'MyDisk' to the label of your own external drive. Or simply type `cd /media/` followed by two TABs to see your options. Note that you can inspect the amount of free space on your drive with `df -h .`

*   _Get this [Makefile](https://raw.github.com/victorklos/recovaio/master/Makefile):_

    <pre>
        wget https://raw.github.com/victorklos/recovaio/master/Makefile
    </pre>

*   _Now type `make` for your options or simply type `make all` and watch._

## Updates

You are kindly invited to report unknown software. Please do so by providing the filename of the .wim file plus a short description stating what kind of software that particular installer provides. Also state if you want to remain anonymous as contributor. You can do this through mail, by issueing a pull request or through an issue.

