# Definir la URL de la imagen y la ruta de destino
$ImageUrl = "https://raw.githubusercontent.com/crlosvelasquez/mm_image/refs/heads/main/fondo.jpg"
$DestinationPath = "C:\mainmemory\Wallpaper\background.jpg"
$DestinationFolder = Split-Path -Path $DestinationPath -Parent
$registryPath = "HKCU:\Control Panel\Desktop"

# Verificar si la carpeta de destino existe, si no, crearla
if (!(Test-Path $DestinationFolder)) {
    Write-Output "Creando carpeta: $DestinationFolder"
    New-Item -ItemType Directory -Path $DestinationFolder -Force | Out-Null
}

# Si la imagen ya existe, eliminarla para permitir la sobrescritura
if (Test-Path $DestinationPath) {
    Write-Output "Eliminando imagen anterior: $DestinationPath"
    Remove-Item -Path $DestinationPath -Force
}

# Descargar la imagen con manejo de errores
try {
    Invoke-WebRequest -Uri $ImageUrl -OutFile $DestinationPath -UseBasicParsing
    Write-Output "Descarga completada: $DestinationPath"
}
catch {
    Write-Output "Error al descargar la imagen: $_"
    exit
}

# Verificar que el archivo existe antes de aplicarlo
if (!(Test-Path $DestinationPath)) {
    Write-Output "Error: La imagen no se descargó correctamente."
    exit
}

# Aplicar el fondo de pantalla
Write-Output "Aplicando fondo de pantalla..."
try {
    Set-ItemProperty -Path $registryPath -Name Wallpaper -Value $DestinationPath
    Write-Output "Fondo de pantalla aplicado: $DestinationPath"
}
catch {
    Write-Error "Error al aplicar el fondo de pantalla: $_"
    exit
}

# Configurar el estilo del fondo a "Ajustar" (Fill)
try {
    Set-ItemProperty -Path $registryPath -Name WallpaperStyle -Value 10  # 2 = Ajustar
    Write-Output "Estilo de fondo de pantalla configurado (Ajustar)"
}
catch {
    Write-Error "Error al configurar el estilo del fondo: $_"
    exit
}

# Deshabilitar el azulejo de la imagen de fondo
try {
    Set-ItemProperty -Path $registryPath -Name WallpaperTile -Value 0  # 0 = Desactivar azulejos
    Write-Output "Azulejos desactivados"
}
catch {
    Write-Error "Error al desactivar azulejos: $_"
    exit
}

# Modificar el registro para bloquear el cambio de fondo (si es necesario)
try {
    Set-ItemProperty -Path $registryPath -Name NoChangingWallPaper -Value 1 -Type DWord
    Write-Output "Política de no cambiar fondo aplicada."
}
catch {
    Write-Error "Error al modificar el registro de políticas: $_"
    exit
}

# Agregar un pequeño retraso para permitir que Windows procese el cambio
Start-Sleep -Seconds 2

# Refrescar el fondo de pantalla sin reiniciar
try {
    Write-Output "Refrescando fondo..."
    RUNDLL32.EXE user32.dll, UpdatePerUserSystemParameters
    Write-Output "Fondo de pantalla refrescado."
}
catch {
    Write-Error "Error al refrescar el fondo de pantalla: $_"
    exit
}

Write-Output "Fondo de pantalla aplicado exitosamente."
