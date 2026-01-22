<#
.SYNOPSIS
    Hilbert Curve
.DESCRIPTION
    Draws a Hilbert Curve, using an L-System.

    A Hilbert Curve is a space-filling curve.
.EXAMPLE
    turtle id hilbert1 hilbertCurve 42 1
.EXAMPLE
    turtle id hilbert2 hilbertCurve 42 2
.EXAMPLE
    turtle id hilbert3 hilbertCurve 42 3
.EXAMPLE
    turtle id hilbert4 hilbertCurve 42 4
#>
param(
    # The size of each segment.
    [double]$Size = (Get-Random -Min 10 -Max 100),
    # The number of generations.
    [int]$Order = (3,4,5 | Get-Random),
    # The angle.
    [double]$Angle = 90
)        

return $this.LSystem('A',  [Ordered]@{
    A = '+BF-AFA-FB+'
    B = '-AF+BFB+FA-'
}, $Order, [Ordered]@{
    'F'     = { $this.Forward($Size) }
    '\+'    = { $this.Rotate($Angle) }
    '\-'    = { $this.Rotate($Angle * -1) }
})
