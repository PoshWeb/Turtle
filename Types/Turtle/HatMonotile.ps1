<#
.SYNOPSIS
    Draws a hat aperiodic monotile.
.DESCRIPTION
    This function uses turtle graphics to draw an aperiodic monotile called a "Hat"
.EXAMPLE
    turtle rotate -90 hatMonotile 100 save ./hatMonotile.svg
.LINK
    https://github.com/christianp/aperiodic-monotile/blob/main/hat-monotile.logo
#>
param(
[double]
$A = $(Get-Random -Min 100 -Max 200),

[double]
$B = 0
)

if (-not $B) {
    $B = [Math]::Tan(60 * [Math]::PI / 180) * $A
}


return $this.
    Forward($b).
    Rotate(90).
    Forward($a).
    Left(60).
    Forward($a).
    Rotate(90).
    Forward($b).
    Rotate(60).
    Forward($b).
    Left(90).
    Forward($a).
    Rotate(60).
    Forward($a).
    Rotate(90).
    Forward($b).
    Rotate(60).
    Forward($b).
    Left(90).
    Forward($a).
    Rotate(60).
    Forward($a).
    Forward($a).
    Rotate(60).
    Forward($a).
    Rotate(90).
    Forward($b).
    Left(60)
