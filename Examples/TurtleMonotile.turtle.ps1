<#
.SYNOPSIS
    Turtle Monotile Example
.DESCRIPTION
    Draws a Turtle Monotile and generates gradient variations
#>
#requires -Module Turtle
if ($PSScriptRoot) {
    Push-Location $PSScriptRoot
}

$monotile = turtle id [TurtleMonotile] rotate -90 TurtleMonotile 100

$monotile | Save-Turtle .\TurtleMonotile.svg

$monotile.Fill = '#4488ff','#224488', 'linear'
$monotile.Stroke = '#224488','#4488ff', 'linear'

$monotile | Save-Turtle .\TurtleMonotileGradient.svg
$monotile | Save-Turtle .\TurtleMonotileGradient.png

$monotile.Fill = '#448822','#228844', 'linear'
$monotile.Stroke = '#228844','#448822', 'linear'

$monotile | Save-Turtle .\TurtleMonotileGradientGreen.svg
$monotile | Save-Turtle .\TurtleMonotileGradientGreen.png

if ($PSScriptRoot) {
    Pop-Location
}

