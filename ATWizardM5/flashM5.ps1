
$COMPORT="COM7:"
$ESPTOOL="./esptool.exe"
$FLASHMAP="0x1000 ./firmware/bootloader_dio_40m.bin 0x8000 ./firmware/partitions.bin 0xe000 ./firmware/boot_app0.bin 0x10000 ./firmware/firmware_m5stick-c.bin"

$MAC=Invoke-Expression "$ESPTOOL --port $COMPORT read_flash_status" | Select-String -pattern "MAC: " 
$MAC = $MAC -replace "MAC: ","" -replace ":",""
$LICFILE=-join("./activation/atw-",$MAC ,".bin")
Invoke-Expression "$ESPTOOL --port $COMPORT --chip esp32 --baud 1500000 --before default_reset --after hard_reset write_flash -z --flash_mode dio --flash_freq 40m --flash_size detect $FLASHMAP"
if (Test-Path $LICFILE -PathType leaf)
{
    Invoke-Expression "$ESPTOOL --port $COMPORT --chip esp32 --baud 1500000 --before default_reset --after hard_reset write_flash -z --flash_mode dio --flash_freq 40m --flash_size detect 0x3FB000 $LICFILE"
} else{
	Write-Output "Licence file $LICFILE not found"
}
