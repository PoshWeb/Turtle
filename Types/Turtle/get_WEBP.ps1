<#
.SYNOPSIS
    Gets the Turtle as a WEBP
.DESCRIPTION
    Gets the Turtle as a WEBP.

    This will only rasterize the Turtle's SVG.
.NOTES
    This will not work if `$env:TURTLE_BOT` is set.
#>
if ($env:TURTLE_BOT) {
    return 
}

$chromiumNames = 'chromium','chrome'
foreach ($browserName in $chromiumNames) {
    $chromiumCommand = 
        $ExecutionContext.SessionState.InvokeCommand.GetCommand($browserName,'Application')
    if (-not $chromiumCommand) { 
        $chromiumCommand = 
            Get-Process -Name $browserName -ErrorAction Ignore | 
            Select-Object -First 1 -ExpandProperty Path
    }
    if ($chromiumCommand) { break }
}
if (-not $chromiumCommand) {
    Write-Error "No Chromium-based browser found. Please install one of: $($chromiumNames -join ', ')"
    return
}

$pngRasterizer = $this.Canvas -replace '/\*Insert-Post-Processing-Here\*/', @'
    const dataUrl = await canvas.toDataURL('image/webp')
    console.log(dataUrl)
  
    const newImage = document.createElement('img')
    newImage.src = dataUrl
    document.body.appendChild(newImage)
'@


$appDataRoot = [Environment]::GetFolderPath("ApplicationData")
$appDataPath = Join-Path $appDataRoot 'Turtle'
$filePath   = Join-Path $appDataPath 'Turtle.raster.html'
$null = New-Item -ItemType File -Force -Path $filePath -Value (
    $pngRasterizer -join [Environment]::NewLine
)
# $pngRasterizer > $filePath

$headlessArguments = @(
    '--headless', # run in headless mode
    '--dump-dom', # dump the DOM to stdout
    '--disable-gpu', # disable GPU acceleration
    '--no-sandbox' # disable the sandbox if running in CI/CD            
)

$chromeOutput = & $chromiumCommand @headlessArguments "$filePath" | Out-String 
if ($chromeOutput -match '<img\ssrc="data:image/\w+;base64,(?<b64>[^"]+)') {
    ,[Convert]::FromBase64String($matches.b64)
}
