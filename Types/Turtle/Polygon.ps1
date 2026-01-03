<#
.SYNOPSIS
    Draws a polygon
.DESCRIPTION
    Draws a regular polygon with N sides.

    To draw a closed polygon, provide a whole number of sides.

    To draw an open polygon, provide a fractial number of sides.
.EXAMPLE
    turtle polygon 42 3
.EXAMPLE
    turtle polygon 42 4
.EXAMPLE
    turtle polygon 42 6
.EXAMPLE
    turtle polygon 42 8
.EXAMPLE
    turtle polygon 42 3.75
.EXAMPLE
    turtle polygon 42 3.001 morph @(
        turtle polygon 42 3.001
        turtle polygon 42 4
        turtle polygon 42 3.001
    )
#>
param(
# The default size of each segment of the polygon
[double]$Size = $(Get-Random -Min 42 -Max 84),
# The number of sides in the polygon.  
# If this is not a whole number, the polygon will not be closed.
[double]$SideCount = (Get-Random -Min 3 -Max 12)
)

# Determine the absolute side count
$absSideCount = [Math]::Abs($SideCount)
# and, for each whole number between 1 and that side count
$null = foreach ($n in 1..([Math]::Floor($absSideCount))) {
    # Rotate and move forward
    $this.Rotate(360 / $SideCount).Forward($Size)    
}
# Determine if there was a remainder
$remainder = $SideCount - [Math]::Floor($SideCount)
# If there was not, return this polygon
if (-not $remainder) { return $this }
# Otherwise, we do one more partial rotation (multiplied by the remainder)
# and draw one more line segment (multiplied by the remainder)
# (the effect will be like watching a polygon close)
return $this.Rotate((360 / $SideCount) * $remainder).Forward($remainder * $Size)

