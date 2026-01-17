<#
.SYNOPSIS
    Gets the font family
.DESCRIPTION
    Gets the font family of the Turtle, if one has been set.

    If no font family has been set, this returns nothing.
.EXAMPLE
    turtle fontfamily 12 fontfamily
.LINK
    https://developer.mozilla.org/en-US/docs/Web/SVG/Reference/Attribute/font-family
#>
$this.TextAttribute.'font-family'
