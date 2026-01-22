<#
.SYNOPSIS
    Sets the font family
.DESCRIPTION
    Sets the font family of the Turtle.

    Any input is acceptable, but it may not be valid.
    
    Invalid input will be ignored.
.LINK
    https://developer.mozilla.org/en-US/docs/Web/SVG/Reference/Attribute/font-family
.EXAMPLE
    turtle fontfamily sans-serif fontfamily
#>
$this.TextAttribute = @{'font-family'= $args }
