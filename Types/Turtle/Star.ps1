<#
.SYNOPSIS
    Draws a star pattern
.DESCRIPTION
    Draws a star pattern with turtle graphics.
.EXAMPLE
    turtle star 42 
.EXAMPLE
    turtle star 42 20
.EXAMPLE
    turtle star 42 20 @('rotate', (360/20*2), 'star', 42, 20 * 10) save ./StarFlower20.svg
.EXAMPLE
    turtle star 42 20 @('rotate', (360/20*2), 'star', 42, 20 * 10) morph @(
        turtle star 42 20 @('rotate', (360/20*2), 'star', 42, 20 * 10)
        turtle star 42 20 @('rotate', (360/20*26), 'star', 42, 20 * 10)
        turtle star 42 20 @('rotate', (360/20*2), 'star', 42, 20 * 10)        
    ) save ./StarFlower20Morph.svg
.EXAMPLE
    turtle star 42 20 @('rotate', (360/20*18), 'star', 42, 20 * 10) save ./StarFlower-20-18.svg
#>
param(
    # The approximate size of the star
    [double]$Size = $(Get-Random -Min 21 -Max 42),
    # The number of points in the star
    [int]$Points = $(Get-Random -Min 5 -Max 7)
)

# To determine the angle, divide 360 by the number of points
$angle = 360 / $Points

$SegmentLength = ($Size*2)/$Points
# Each 'point' in the star actually consists of two points, an inward and outward point.
# Imagine we start an an outward point
$null = foreach ($n in 1..([Math]::Abs($Points))) {
    $this. # We rotate by the angle and move forward one segment
        Rotate($Angle).Forward($SegmentLength).
        # The rotate back and move forward another segment
        Rotate(-$angle).Forward($SegmentLength).
        # then rotate once more so we continue moving around the circle
        Rotate($angle)
} # we repeat this up to the number of points in order to draw a star with no crossings.

return $this
