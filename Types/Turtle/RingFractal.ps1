<#
.SYNOPSIS
    Draws a Ring Fractal
.DESCRIPTION
    Draws a Ring Fractal, using an L-System
.LINK
    https://paulbourke.net/fractals/lsys/
.EXAMPLE
    turtle RingFractal 42 1
.EXAMPLE
    turtle RingFractal 42 2
.EXAMPLE
    turtle RingFractal 42 3
.EXAMPLE
    turtle RingFractal 42 4
#>
param(
# The size of each segment
[double]$Size = (Get-Random -Min 100 -Max 200),
# The order of magnitude (the number of expansions)
[int]$Order = (3,4| Get-Random),
# The default angle.
[double]$Angle = 90
)
return $this.LSystem('F+F+F+F',  [Ordered]@{
    F = 'FF+F+F+F+F+F-F'
}, $Order, [Ordered]@{
    '\+'    = { $this.Rotate($Angle) }
    '-'     = { $this.Rotate($Angle * -1)}
    'F'     = { $this.Forward($Size) }
})
