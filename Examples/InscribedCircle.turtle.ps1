<#
.SYNOPSIS
    An inscribed circle
.DESCRIPTION
    A simple example of turtles containing turtles
#>
$inscribedCircle = 
    turtle id inscribedCircle width 42 height 42 turtles ([Ordered]@{
        'square' = turtle square 42 fill '#4488ff' stroke '#224488'
        'circle' = turtle circle 21 fill '#224488' stroke '#4488ff'
    })

$inscribedCircle | Save-Turtle ./InscribedCircle.svg
$inscribedCircle | Save-Turtle ./InscribedCirclePattern.svg Pattern
