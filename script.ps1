$ImageUrl = "https://raw.githubusercontent.com/crlosvelasquez/mm_image/refs/heads/main/fondo.jpg"
$DestinationPath = "C:\Windows\Web\Wallpaper\mainmemory\background.jpg"
Invoke-WebRequest -Uri $ImageUrl -OutFile $DestinationPath
