<#
.SYNOPSIS
    Draws a polygon made of Scissors    
.DESCRIPTION
    Draws a polygon made up of a series of Scissor shapes, followed by a rotation.
    
    This countiues until the total angle is approximately 360.
.EXAMPLE
    # When the angles are even divisors of 360, we get stars
    Turtle ScissorPoly 84 60 72 save ./ScissorPolyStar.svg 
.EXAMPLE    
    Turtle ScissorPoly 23 60 72 save ./ScissorPolyStar2.svg 
.EXAMPLE
    Turtle ScissorPoly 23 60 40 save ./ScissorPolyStar3.svg 
.EXAMPLE
    # When both angles exceed 180, the star starts to overlap
    Turtle ScissorPoly 23 90 120 save ./ScissorPoly.svg 
.EXAMPLE
    # When the angle is _not_ an even multiple of 360, there is much more overlap    
    Turtle ScissorPoly 16 42 42 save ./ScissorPoly.svg
.EXAMPLE
    # This can get very chaotic, if it takes a while to reach a multiple of 360
    # Build N scissor polygons
    foreach ($n in 60..72) {
        Turtle ScissorPoly 16 $n $n save ./ScissorPoly-$n.svg
    }        
.EXAMPLE
    Turtle ScissorPoly 16 69 69 save ./ScissorPoly-69.svg
.EXAMPLE
    Turtle ScissorPoly 15 72 90 save ./ScissorPoly.svg 
.EXAMPLE
    # And angle of exactly 90 will produce a series of spokes
    Turtle ScissorPoly 23 45 90 save ./Compass.svg
.EXAMPLE
    # These spokes become pointy stars as we iterate past 90
    foreach ($n in 91..99) {
        Turtle ScissorPoly 23 45 $n save "./Scissor-45-$n.svg"
    }
.EXAMPLE
    Turtle ScissorPoly 23 45 98 save ./ScissorPoly-45-98.svg
.EXAMPLE
    Turtle ScissorPoly 23 45 99 save ./ScissorPoly-45-99.svg
#>
param(
# The distance of each side of the scissor
[double]
$Distance = (
    (Get-Random -Min 42 -Max 84) * (1,-1|Get-Random)
),

# The angle between each scissor
[double]
$Angle = (Get-Random -Min 30 -Max 90),

# The angle of each scissor, or the degree out of phase a regular N-gon would be.
[double]
$Phase = (Get-Random -Min 30 -Max 90)
)

$totalTurn = 0

if ($angle -eq 0) { return $this }

$totalTurn = $Angle
$rotations = 0
foreach ($n in 1..360) {
    $rotations = ($n * 360)/$totalTurn    
    if ([Math]::Floor($rotations) -eq $rotations) {
        break
    }
}

foreach ($n in 1..$rotations) {
    $this = $this.Scissor($Distance, $Phase).Left($angle)
}
return $this
