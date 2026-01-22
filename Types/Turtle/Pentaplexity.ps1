<#
.SYNOPSIS
    Draws a Pentaplexity
.DESCRIPTION
    Draws a Pentaplexity Fractal, using an L-System
.LINK
    https://paulbourke.net/fractals/lsys/
.EXAMPLE
    turtle Pentaplexity 42 1
.EXAMPLE
    turtle Pentaplexity 42 2
.EXAMPLE
    turtle Pentaplexity 42 3
.EXAMPLE
    turtle Pentaplexity 42 4
#>
param(
# The size of each segment
[double]$Size = $(Get-Random -Min 42 -Max 84),
# The order of magnitude (the number of expansions)
[int]$Order = (3,4 | Get-Random),
# The default angle.
[double]$Angle = 36
)
return $this.LSystem('F++F++F++F++F',  [Ordered]@{
    F = 'F++F++F+++++F-F++F'
}, $Order, [Ordered]@{
    '\+'    = { $this.Rotate($Angle) }
    '-'     = { $this.Rotate($Angle*-1)}
    'F'     = { $this.Forward($Size) }
})
