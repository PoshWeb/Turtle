<#
.SYNOPSIS
    Sets a Turtle's Palette
.DESCRIPTION
    Sets a Turtle's Palette.

    A Palette is a custom list of properties that should describe colors.

    This will generate a CSS palette, available in the `.style` and `.css` properties.
    
    This will also allow the color names in the palette to be used in `.stroke` and `.fill` values.
#>
param(
[Collections.IDictionary]
$Palette
)

if (-not $this.'#Palette') {
    $this | Add-Member NoteProperty '#Palette' ([Ordered]@{})    
}

foreach ($key in $Palette.Keys) {
    $this.'#Palette'[$key] = $Palette[$key]
}