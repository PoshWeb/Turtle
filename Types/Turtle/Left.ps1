<#
.SYNOPSIS
    Turns the turtle left
.DESCRIPTION
    Turns the turtle left (counter-clockwise) by the specified angle.
#>
param(
[double]$Angle = $(Get-Random -Minimum 0.0 -Maximum 360.0)
)

$this.Rotate($Angle * -1)