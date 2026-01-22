<#
.SYNOPSIS
    Draws a petal
.DESCRIPTION
    Draws a petal.  
    
    This is a combination of two arcs and rotations.
.EXAMPLE
    turtle @('petal',100,60, 'rotate', 60 * 6)
#>
param(
[double]
$Radius = $(Get-Random -Min 21 -Max 42),

[double]
$Angle = $(Get-Random -Min 30 -Max 60)
)

$OppositeAngle = 180 - $Angle


$null = @(
    $this.ArcRight($Radius, $angle)
    $this.Rotate($OppositeAngle)
    $this.ArcRight($Radius, $angle)
    $this.Rotate($OppositeAngle)
)

return $this