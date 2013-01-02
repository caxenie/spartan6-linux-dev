## Script to flash the uboot bootloader in the board flash and get the kernel using tftp  
## when loading and probing the PetaLogix Linux image 
# Cristian Axenie - TUM 2012 

#!/bin/sh  
echo -e " \n" 
echo -e "PetaLogix Linux demo using Spartan6-LX9 MicroBoard " 
echo -e " \n" 
sleep 3 
echo -e "Setting the Xilinx ISE environment variables ...\n" 
echo -e " \n" 
source /media/data_warehouse/software/Xilinx-install/ISE_DS/settings32.sh
sleep 2
if [ -f download.cmd ] ; then
rm -fr download.cmd 
fi
echo -e "Setting the binaries download parameters for impact tool ...\n" 
sleep 3
echo -e " \n" 
echo -e "setMode -bscan"                      >>  download.cmd 
echo -e "setcable -p auto"                    >> download.cmd 
echo -e "identify"                            >> download.cmd 
echo -e "assignfile -p 1 -file download.bit"  >> download.cmd 
echo -e "program -p 1"                        >> download.cmd 
echo -e "quit"                                >> download.cmd 
echo -e "Calling the impact tool for boundry scan, chain verification and bitstream download.\n" 
echo -e " \n" 
impact -batch download.cmd 
sleep 4 
if [ -f xmd.ini ] ; then
rm -fr xmd.ini 
fi
echo -e "Creating xmd ini file for loading u-boot bootloader ...\n" 
sleep 3
echo -e "\n" 
echo -e "connect mb mdm"                     >>  xmd.ini 
echo -e "rst"                                >> xmd.ini 
echo -e "dow u-boot.elf"                     >> xmd.ini 
echo -e "run"                                >> xmd.ini 
echo -e "exit"                               >> xmd.ini 
echo -e "Calling the xmd tool to download binaries...\n" 
sleep 3
echo -e "\n" 
echo -e "Downloading Program -- u-boot.elf\n 
	section, .text: 0x83f00000-0x83f2567b\n 
	section, .rodata: 0x83f2567c-0x83f2fb17\n 
	section, .data: 0x83f2fb18-0x83f3137b\n 
	section, .u_boot_cmd: 0x83f3137c-0x83f3188b\n 
	section, .bss: 0x83f3188c-0x83f3839b\n" 
xmd 
sleep 2 
echo -e "\n" 
echo -e "\n"
echo -e "Kernel will be loaded using ftp.\n"
echo -e "\n"
rm _impactbatch.log