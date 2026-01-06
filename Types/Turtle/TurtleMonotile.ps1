<#
.SYNOPSIS
    Draws a turtle aperiodic monotile.
.DESCRIPTION
    This function uses turtle graphics to draw an aperiodic monotile called a "Turtle"
.EXAMPLE
    turtle rotate -90 turtleMonotile 100 save ./turtleMonotile.svg
.LINK
    https://github.com/christianp/aperiodic-monotile/blob/main/turtle-monotile.logo
#>
param(
[double]
$A = $(Get-Random -Min 42 -Max 100),

[double]
$B = 0
)

if (-not $B) {
    $B = [Math]::Tan(60 * [Math]::PI / 180) * $A
}

return $this.
    Rotate(90).
    Forward($a).
    Rotate(60).
    Forward($a).
    Rotate(-90).
    Forward($b).
    Rotate(60).
    Forward($b).
    Forward($b).
    Rotate(60).
    Forward($b).
    Rotate(90).
    Forward($a).
    Rotate(-60).
    Forward($a).
    Rotate(90).
    Forward($b).
    Rotate(-60).
    Forward($b).
    Rotate(90).
    Forward($a).
    Rotate(60).
    Forward($a).
    Rotate(-90).
    Forward($b).
    Rotate(60).
    Forward($b)

return


