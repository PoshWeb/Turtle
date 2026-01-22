<#
.SYNOPSIS
    Draws an arcygon
.DESCRIPTION
    Draws an arcygon.  
    
    An arcygon is a polygon with N sides, and an arc at each corner.

    To draw a closed arcygon, provide a whole number of sides.

    To draw an open arcygon, provide a fractial number of sides.

    To draw a negative arcygon, provide a negative angle.
.EXAMPLE
    # Arcygons have a side length, radius, and number of sides.
    turtle arcygon 42 21 3
.EXAMPLE    
    turtle arcygon 42 21 4
.EXAMPLE    
    turtle arcygon 21 42 4
.EXAMPLE
    turtle arcygon 42 -21 4
.EXAMPLE
    turtle arcygon -42 -21 4
.EXAMPLE
    # we can make partial acygons
    turtle arcygon 42 42 4.2
.EXAMPLE
    # we can morph partial acygons
    turtle arcygon 42 42 4.2 morph @(
        turtle arcygon 42 42 4.2
        turtle arcygon 42 42 4.999999
    )
.EXAMPLE
    turtle arcygon 42 42 8
.EXAMPLE
    turtle arcygon 42 3.001 morph @(
        turtle arcygon 42 42 3.001
        turtle arcygon 42 42 3.999
        turtle arcygon 42 42 3.001
    )
.EXAMPLE
    turtle arcygon 42 4 morph @(
        turtle arcygon 42 42 4
        turtle arcygon 42 -42 4
        turtle arcygon 42 42 4
    )
#>
param(
# The default size of each segment of the polygon
[double]$Size = $(Get-Random -Min -42 -Max 42),

[double]$Radius = $(Get-Random -Min -42 -Max 42),
# The number of sides in the polygon.  
# If this is not a whole number, the polygon will not be closed.
[double]$SideCount = (Get-Random -Min 3 -Max 12)
)

# Determine the absolute side count
$absSideCount = [Math]::Abs($SideCount)
# and, for each whole number between 1 and that side count
$null = foreach ($n in 1..([Math]::Floor($absSideCount))) {
    # Rotate and move forward
    $this.
        CircleArc($radius, (360 / $SideCount)).
        Forward($Size).
        Rotate(360 / $SideCount)
}
# Determine if there was a remainder
$remainder = $SideCount - [Math]::Floor($SideCount)
# If there was not, return this polygon
if (-not $remainder) { return $this }
# Otherwise, we do one more partial rotation (multiplied by the remainder)
# and draw one more line segment (multiplied by the remainder)
# (the effect will be like watching a polygon close)
$remainingAngle = (360 / $SideCount) * $remainder
return $this.
    CircleArc($remainder * $Radius, $remainingAngle)
    Forward($remainder * $Size).
    Rotate($remainingAngle)
# @('CircleArc',$radius, $angle, 'Forward', $length, 'Rotate', $angle * $n)

