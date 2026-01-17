<#
.SYNOPSIS
    Sets the font variant
.DESCRIPTION
    Sets the font variant of the Turtle.

    Any input is acceptable, but it may not be valid.
    
    Invalid input will be ignored.
.LINK
    https://developer.mozilla.org/en-US/docs/Web/SVG/Reference/Attribute/font-variant
.EXAMPLE
    turtle fontvariant small-caps fontvariant
#>
$this.TextAttribute = @{'font-variant'= $args }
