<#
.SYNOPSIS
    Moves the turtle forward
.DESCRIPTION
    Moves the turtle forward along the current heading
.EXAMPLE
    turtle forward rotate 90 forward rotate 90 forward rotate 90 forward rotate 90
#>
param(
# The distance to move forward
[double]
$Distance = $(Get-Random -Min 1 -Max 100)
)

$heading = $this.Heading
$x = $Distance * [math]::cos($heading * [Math]::PI / 180)
$y = $Distance * [math]::sin($heading * [Math]::PI / 180)
return $this.Step($x, $y)
