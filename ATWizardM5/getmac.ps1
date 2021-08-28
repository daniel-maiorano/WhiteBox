$COMPORT="COM7:"
$ESPTOOL="./esptool.exe"

$MAC=Invoke-Expression "$ESPTOOL --port $COMPORT read_flash_status" | Select-String -pattern "MAC: " 
$MAC = $MAC -replace "MAC: ",""
Add-Content -Path 'maclist.txt'  -Value $MAC