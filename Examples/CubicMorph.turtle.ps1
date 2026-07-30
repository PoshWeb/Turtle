<#
.SYNOPSIS
    Cubic Morph Example
.DESCRIPTION
    A quick cool example of multiple cubic morphs
#>
$Colors = @('fill', '#4488ff','stroke','#224488','pathclass', 'brightBlue-fill','blue-stroke')
turtle id cubicMorph width 200 height 200 turtles @(
    turtle morph @(
        turtle c 0   0 0   0 200 200 
        turtle c 0 200 200 0 200 200 
        turtle c 0   0 0   0 200 200
        turtle c 200 0 0 200 200 200
        turtle c 0   0 0   0 200 200 
    ) @colors
    turtle morph @(
        turtle c 0    0 0    0 -200 200 
        turtle c 0  200 -200 0 -200 200 
        turtle c 0    0 0    0 -200 200
        turtle c -200 0 0  200 -200 200
        turtle c 0    0 0    0 -200 200 
    ) @colors
    turtle morph @(
        turtle teleport 100 0 c 0 0 0 0 0 200
        turtle teleport 100 0 c -100 0 100 200 0 200
        turtle teleport 100 0 c 0 0 0 0 0 200
    ) @colors
    turtle morph @(
        turtle teleport 0 100 c 0 0 0 0 200 0
        turtle teleport 0 100 c 0 -100 200 100 200 0
        turtle teleport 0 100 c 0 0 0 0 200 0
    ) @colors
) |
    Save-Turtle ./CubicMorph.svg
