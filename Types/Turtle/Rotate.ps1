<#
.SYNOPSIS
    Rotates the turtle.
.DESCRIPTION
    Rotates the turtle by the specified angle.
#>
param(
[double]$Angle = (Get-Random -Min -360.0 -Max 360.0)
)
$this.Heading += $Angle
return $this