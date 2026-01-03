<#
.SYNOPSIS
    Draws a Tile Fractal
.DESCRIPTION
    Draws a Tile Fractal, using an L-System
.LINK
    https://paulbourke.net/fractals/lsys/
.EXAMPLE
    turtle TileFractal 42 1
.EXAMPLE
    turtle TileFractal 42 2
.EXAMPLE
    turtle TileFractal 42 3
.EXAMPLE
    turtle TileFractal 42 4
#>
param(
# The size of each segment
[double]$Size = (Get-Random -Min 100 -Max 200),
# The order of magnitude (the number of expansions)
[int]$Order = (3,4 | Get-Random),
# The default angle.
[double]$Angle = 90
)
return $this.LSystem('F+F+F+F',  [Ordered]@{
    F = 'FF+F-F+F+FF'
}, $Order, [Ordered]@{
    '\+'    = { $this.Rotate($Angle) }
    '-'     = { $this.Rotate($Angle * -1)}
    'F'     = { $this.Forward($Size) }
})
