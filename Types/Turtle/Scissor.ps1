<#
.SYNOPSIS
    Draws a Scissor
.DESCRIPTION
    Draws a Scissor in turtle.

    A Scissor is a pair of intersecting lines, drawn at an angle.
.EXAMPLE
    Turtle Scissor Save ./Scissor.svg
#>
param(
# The distance to travel
[double]
$Distance = $(Get-Random -Min 21 -Max 42),

# The interior angle of the scissors
[double]
$Angle = $(Get-Random -Min 15 -Max 75)
)


$this.
    Rotate($angle). # Rotate 
    Forward($distance). # Move Forward
    Rotate($angle * -2). # Rotate Back
    Forward($Distance). # Move Forward
    Rotate($Angle) # Rotate
