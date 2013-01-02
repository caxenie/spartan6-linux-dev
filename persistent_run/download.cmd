setMode -bscan
setcable -p auto
identify -inferir
identifyMPM
attachflash -position 1 -spi "N25Q128" 
assignfiletoattachedflash -position 1 -file "s6lx9_configuration_uboot_spi_prom.mcs" 
program -p 1 -dataWidth 4 -spionly -e -v -loadfpga
quit
