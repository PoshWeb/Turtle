<#
.SYNOPSIS
    Sets the font style
.DESCRIPTION
    Sets the font style of the Turtle.

    Any input is acceptable, but it may not be valid.
    
    Invalid input will be ignored.
.LINK
    https://developer.mozilla.org/en-US/docs/Web/SVG/Reference/Attribute/font-style
.EXAMPLE
    turtle fontstyle italic fontstyle
#>
$this.TextAttribute = @{'font-style'= $args }
