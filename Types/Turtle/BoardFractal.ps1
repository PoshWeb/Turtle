<#
.SYNOPSIS
    Draws a Board
.DESCRIPTION
    Draws a Board, using an L-System
.LINK
    https://paulbourke.net/fractals/lsys/
.EXAMPLE
    turtle BoardFractal 42 1
.EXAMPLE
    turtle BoardFractal 42 2
.EXAMPLE
    turtle BoardFractal 42 3
.EXAMPLE
    turtle BoardFractal 42 4
#>
param(
# The size of each segment
[double]$Size = (Get-Random -Min 100 -Max 200),
# The order of magnitude (the number of expansions)
[int]$Order = (2,3,4 | Get-Random),
# The default angle.
[double]$Angle = 90
)
return $this.LSystem('F+F+F+F',  [Ordered]@{
    F = 'FF+F+F+F+FF'
}, $Order, [Ordered]@{
    '\+'    = { $this.Rotate($Angle) }
    'F'     = { $this.Forward($Size) }
})
