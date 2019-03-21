##############################################
# HowTo 
##############################################
For getting USB3.0 & 2.0 working, you need to copy

copy BCT/tegra186-mb1-bct-pmic-quill-p3310-1000-c01.cfg -> to 64_TX2/Linux_for_tx2/bootloader/t186ref/BCT
copy BCT/tegra186-mb1-bct-pmic-quill-p3310-1000-c02.cfg -> to 64_TX2/Linux_for_tx2/bootloader/t186ref/BCT
copy BCT/tegra186-mb1-bct-pmic-quill-p3310-1000-c03.cfg -> to 64_TX2/Linux_for_tx2/bootloader/t186ref/BCT
copy BCT/tegra186-mb1-bct-pmic-quill-p3310-1000-c04.cfg -> to 64_TX2/Linux_for_tx2/bootloader/t186ref/BCT


From the source/ folder:
1. Ignore the BCT/ folder, and the cfg files.
2. Copy the other dts(i) files to the appropriate locations, as mentioned in the building kernel document.


****IGNORE FROM HERE*****
then bring Jetson TX2 into recovery mode and execute this
sudo ./flash.sh jetson-tx2 mmcblk0p1
or
you flash this via JetPack.




For updateing device Tree you need to...

copy dtb/tegra186-quill-p3310-1000-a00-00-base.dtb -> 64_TX2/Linux_for_tx2/kernel/dtb
copy dtb/tegra186-quill-p3310-1000-c03-00-base.dtb -> 64_TX2/Linux_for_tx2/kernel/dtb
copy dtb/tegra186-quill-p3310-1000-c03-00-dsi-hdmi-dp.dtb -> 64_TX2/Linux_for_tx2/kernel/dtb

then bring Jetson TX2 into recovery mode and execute this
sudo ./flash.sh -r -k kernel-dtb jetson-tx2 mmcblk0p1

Copy the Image and zImage into the boot folder from the TX2.
Copy the kernel-modules into the folder from the TX2


