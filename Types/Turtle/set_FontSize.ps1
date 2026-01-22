<#
.SYNOPSIS
    Sets the font size
.DESCRIPTION
    Sets the font size of the Turtle.

    Any input is acceptable, but it may not be valid.
    
    Invalid input will be ignored.
.LINK
    https://developer.mozilla.org/en-US/docs/Web/SVG/Reference/Attribute/font-size
.EXAMPLE
    turtle fontsize 12 fontsize


#>
$this.TextAttribute = @{'font-size'=$args }
