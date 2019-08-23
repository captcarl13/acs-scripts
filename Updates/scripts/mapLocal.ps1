# Map the local drive as L:
$serverName = "Localimgsrv"
$imageFolder= "images"
New-PSDrive –Name “L” –PSProvider FileSystem –Root “\\$serverName\$imageFolder” –Persist