<#
.SYNOPSIS
    Draws Krishan Anklets
.DESCRIPTION
    Draws Krishan Anklets in Turtle Graphics, using an L-System
.LINK
    https://paulbourke.net/fractals/lsys/
.EXAMPLE
    turtle KrishnaAnklets 42 3
.EXAMPLE
    turtle KrishnaAnklets 42 4
.EXAMPLE
    turtle KrishnaAnklets 42 5
.EXAMPLE
    turtle KrishnaAnklets 42 4 morph
.EXAMPLE
    turtle KrishnaAnklets 42 4 morph @(
        turtle KrishnaAnklets 42 4
        turtle KrishnaAnklets 42 4 135
        turtle KrishnaAnklets 42 4 
    )
.EXAMPLE
    turtle KrishnaAnklets 42 4 morph @(
        turtle KrishnaAnklets 42 4
        turtle KrishnaAnklets 42 4 -45
        turtle KrishnaAnklets 42 4 
    )
.EXAMPLE
    turtle turtles @(
        turtle KrishnaAnklets 42 4 morph @(
            turtle KrishnaAnklets 42 4
            turtle KrishnaAnklets 42 4 -45
            turtle KrishnaAnklets 42 4 
        )
        turtle KrishnaAnklets 42 4 morph @(
            turtle KrishnaAnklets 42 4
            turtle KrishnaAnklets 42 4 135
            turtle KrishnaAnklets 42 4 
        )
    )
.EXAMPLE
    turtle KrishnaAnklets 42 4 morph @(
        turtle curvature 1 curvetype [s] KrishnaAnklets 42 4
        turtle curvature -1 curvetype [s] KrishnaAnklets 42 4
        turtle curvature 1 curvetype [s] KrishnaAnklets 42 4 
    )
.EXAMPLE
    turtle KrishnaAnklets 42 4 morph @(
        turtle curvature 1 curvetype [q] KrishnaAnklets 42 4
        turtle curvature -1 curvetype [q] KrishnaAnklets 42 4
        turtle curvature 1 curvetype [q] KrishnaAnklets 42 4 
    )
.EXAMPLE
    turtle KrishnaAnklets 42 4 morph @(
        turtle curvature 1 curvetype [c] KrishnaAnklets 42 4
        turtle curvature -1 curvetype [c] KrishnaAnklets 42 4
        turtle curvature 1 curvetype [c] KrishnaAnklets 42 4 
    )
.EXAMPLE
    turtle KrishnaAnklets 42 4 morph @(
        turtle curvature 1 curvetype [q] KrishnaAnklets 42 4
        turtle curvature -1 curvetype [q] KrishnaAnklets 42 4
        turtle curvature 1 curvetype [q] KrishnaAnklets 42 4 
    ) fill random random stroke random random
#>
param(
# The size of each step
[double]$Size = (Get-Random -Min 42 -Max 84),
# The number of expansions
[int]$Order = $(Get-Random -Min 3 -Max 5),
# The angle per turn
[double]$Angle = 45
)

$turtle = $this 
if (-not $turtle) { $turtle = turtle }
return $turtle.LSystem('-X--X',  [Ordered]@{
    X = 'XFX--XFX'
}, $Order, [Ordered]@{    
    '-'     = { $turtle.Rotate($Angle * -1) }
    '[F]'  = { $turtle.Forward($Size) }
})
