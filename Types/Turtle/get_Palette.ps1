<#
.SYNOPSIS
    Gets a Turtle's Palette
.DESCRIPTION
    Gets a Turtle's Palette.

    A Palette is a custom list of properties that should describe colors.

    This will generate a CSS palette, available in the `.style` and `.css` properties.
    
    This will also allow the color names in the palette to be used in `.stroke` and `.fill` values.
#>
return $this.'#Palette'
