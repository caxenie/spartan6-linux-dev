## Script to flash the uboot bootloader in the board flash and make it persistent 
## when loading and probing the PetaLogix Linux image
# Cristian Axenie - TUM 2012 

#!/bin/sh  
echo -e " \n" 
echo -e "PetaLogix Linux demo using Spartan6-LX9 uBoard Flash -- Flashing UBoot persistent in Flash Memory" 
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
###########################################################################
# This will create the download.cmd file                                  #
# and then start impact to program the PCIe IO_Control PROM file to       #
# the SPI flash memory on the Avnet S6LX9 board.                          #
###########################################################################
sleep 3
echo -e " \n" 
echo -e "setMode -bscan"                      >>  download.cmd 
echo -e "setcable -p auto"                    >> download.cmd 
echo -e "identify -inferir"                   >> download.cmd 
echo -e "identifyMPM"			      >> download.cmd
echo -e 'attachflash -position 1 -spi "N25Q128" '  >> download.cmd 
echo -e 'assignfiletoattachedflash -position 1 -file "s6lx9_configuration_uboot_spi_prom.mcs" ' >> download.cmd
echo -e "program -p 1 -dataWidth 4 -spionly -e -v -loadfpga"   >> download.cmd 
echo -e "quit"                                >> download.cmd 
echo -e "Calling the impact tool for boundry scan, chain verification and bitstream download.\n" 
echo -e " \n" 
impact -batch download.cmd 
sleep 4 
echo -e "In order to flash the kernel from the u-boot command line run:\n
		run update_kernel\n 
	This will copy the PetaLinux kernel (image.ub) to SPI flash.\n"
echo -e "Here are all the operations that will take place when we boot PetaLinux from the SPI flash.\n
	Power-up the board or press the PROG FPGA push button on the board, to start the boot-up.\n
        The Spartan-6 FPGA will automatically transfer the configuration image from the SPI flash to the FPGA configuration memory together with the first stage bootloader that will copied to the MicroBlaze local memory (BRAM). \n
        The FPGA is now configured and fully operating.The first stage bootloader will start to execute and copy the u-boot loader from the SPI flash to the system memory (LPDDR).\n
        The u-boot loader will execute and bring in the PetaLinux image to the system memory.\n
        The system will boot up.\n"


