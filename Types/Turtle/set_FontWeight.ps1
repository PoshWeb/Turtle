<#
.SYNOPSIS
    Sets the font weight
.DESCRIPTION
    Sets the font weight of the Turtle.

    Any input is acceptable, but it may not be valid.
    
    Invalid input will be ignored.
.LINK
    https://developer.mozilla.org/en-US/docs/Web/SVG/Reference/Attribute/font-weight
.EXAMPLE
    turtle fontweight bold fontweight
#>
$this.TextAttribute = @{'font-weight'= $args }
