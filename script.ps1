$ImageUrl = "https://raw.githubusercontent.com/crlosvelasquez/mm_image/refs/heads/main/fondo.jpg"
$DestinationPath = "C:\Windows\Web\Wallpaper\mainmemory\background.jpg"
$DestinationFolder = Split-Path -Path $DestinationPath -Parent

# Verificar si la carpeta de destino existe, si no, crearla
if (!(Test-Path $DestinationFolder)) {
    New-Item -ItemType Directory -Path $DestinationFolder -Force | Out-Null
}

# Descargar la imagen con manejo de errores
try {
    Invoke-WebRequest -Uri $ImageUrl -OutFile $DestinationPath
    Write-Output "Descarga completada: $DestinationPath"
} catch {
    Write-Output "Error al descargar la imagen: $_"
}
