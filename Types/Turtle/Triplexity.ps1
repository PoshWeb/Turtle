<#
.SYNOPSIS
    Draws a Triplexity
.DESCRIPTION
    Draws a Triplexity Fractal, using an L-System.

    Each generation of the triplexity will create an equilateral triangle with a spoke and an incomplete total rotation.
    
    Multiple generations of this seem to alternate between even numbered triangle shapes and odd numbered "lines" of triangles.
.EXAMPLE
    turtle Triplexity 42 1
.EXAMPLE
    turtle Triplexity 42 2
.EXAMPLE
    turtle Triplexity 42 3
.EXAMPLE
    turtle Triplexity 42 4
#>
param(
# The size of each segment
[double]$Size = (Get-Random -Min 21 -Max 42),
# The order of magnitude (the number of expansions)
[int]$Order = (2,3,4 | Get-Random),
# The default angle.
[double]$Angle = 60
)
return $this.LSystem('F++F++F',  [Ordered]@{
    F = 'F++F++FFF'
}, $Order, [Ordered]@{
    '\+'    = { $this.Rotate($Angle) }
    '-'     = { $this.Rotate($Angle*-1)}
    'F'     = { $this.Forward($Size) }
})
