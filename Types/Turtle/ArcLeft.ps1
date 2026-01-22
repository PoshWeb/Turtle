<#
.SYNOPSIS
    Arcs the turtle to the left
.DESCRIPTION
    Arcs the turtle to the left (counter-clockwise) a number of degrees.

    For each degree, the turtle will move forward and rotate.
.NOTES
    The amount moved forward will be the portion of the circumference.
#>
param(
# The radius of a the circle, were it to complete the arc.
[double]
$Radius = (Get-Random -Min 42 -Max 84),

# The angle of the arc
[double]
$Angle = (Get-Random -Min 30 -Max 90)
)

# Rather than duplicate logic, we will simply reverse the angle
$angle *= -1
# and arc to the "right".
return $this.ArcRight($Radius, $Angle)