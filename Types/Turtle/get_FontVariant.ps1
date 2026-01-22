<#
.SYNOPSIS
    Gets the font variant
.DESCRIPTION
    Gets the font variant of the Turtle, if one has been set.

    If no font variant has been set, this returns nothing.
.EXAMPLE
    turtle fontvariant small-caps fontvariant
.LINK
    https://developer.mozilla.org/en-US/docs/Web/SVG/Reference/Attribute/font-variant
#>
$this.TextAttribute.'font-variant'
