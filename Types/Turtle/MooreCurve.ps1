<#
.SYNOPSIS
    Generates a Moore curve.
.DESCRIPTION
    Generates a Moore curve using turtle graphics.
.LINK
    https://en.wikipedia.org/wiki/Moore_curve
.EXAMPLE
    turtle id moore1 moorecurve 42 1
.EXAMPLE
    turtle id moore2 moorecurve 42 2
.EXAMPLE
    turtle id moore3 moorecurve 42 3
.EXAMPLE
    turtle id moore4 moorecurve 42 4
.EXAMPLE
    Move-Turtle MooreCurve 15 5 |
        Set-Turtle Stroke '#4488ff' |
        Save-Turtle "./MooreCurve.svg"
#>
param(
[double]$Size = $(
    (Get-Random -Min 42 -Max 84) * (1,-1 |Get-Random)
),
[int]$Order = (3,4 | Get-Random),
[double]$Angle = 90
)        


return $this.LSystem(
    'LFL+F+LFL', 
    [Ordered]@{ 
        L = '-RF+LFL+FR-'
        R = '+LF-RFR-FL+'
    },
    $Order,
    @{
        F = { $this.Forward($Size) }
        '\+' = { $this.Rotate(90) }            
        '-' = { $this.Rotate(-90) }
    }
)
