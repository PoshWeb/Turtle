<#
.SYNOPSIS
    Equilateral Triangle
.DESCRIPTION
    Draws an equilateral triangle with Turtle.
.LINK
    https://logothings.github.io/logothings/logo/Tri-agons.html
#>
param(
# The length of each side
[double]
$Side = (
    Get-Random -Minimum 1 -Maximum 42
) * (
    1, -1 | Get-Random
)
)

if (-not $this) {$this = turtle}
$turtle = $this
foreach ($n in 1..3) {
    $turtle = $turtle.Forward($Step).Rotate(360/3)    
}
return $turtle
