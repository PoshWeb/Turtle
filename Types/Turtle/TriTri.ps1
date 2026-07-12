<#
.SYNOPSIS
    Triagons
.DESCRIPTION

.NOTES
    This example was originally written by [Cynthia Solomon](https://en.wikipedia.org/wiki/Cynthia_Solomon)

    Cynthia Solomon is one of the remaining creators of Turtle Graphics.

    We all owe them a huge debt.    
.LINK
    https://logothings.github.io/logothings/logo/Tri-agons.html
#>
param(
[double]
$Step = (
    Get-Random -Minimum 1 -Maximum 42
) * (
    1, -1 | Get-Random
),

[int]
$StepCount = (
    Get-Random -Minimum 1 -Maximum 120
),

# The spread between triangles.
[double]
$Spread = $(Get-Random -Minimum -4.2 -Maximum 4.2)
)

if (-not $StepCount) { $StepCount = 1 }
if (-not $this) {$this = turtle}
$turtle = $this
foreach ($stepNumber in 1..$([Math]::Abs($StepCount))) {
    foreach ($n in 1..3) {
        $turtle = $turtle.Forward($Step).Rotate(360/3)
    }
    $turtle = $turtle.Rotate(360/$stepCount).Forward($Spread)
}

return $turtle

