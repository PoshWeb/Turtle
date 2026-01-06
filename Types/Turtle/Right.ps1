<#
.SYNOPSIS
    Turns the turtle right 
.DESCRIPTION
    Turns the turtle right (clockwise) by the specified angle.
#>
param(
[double]$Angle = (Get-Random -Min 0.0 -Max 360.0)
)

$this.Rotate($Angle)