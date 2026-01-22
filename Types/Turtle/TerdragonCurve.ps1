
<#
.SYNOPSIS
    Generates a Terdragon Curve.
.DESCRIPTION
    Generates a Terdragon curve using turtle graphics.
.LINK
    https://en.wikipedia.org/wiki/Dragon_curve#Terdragon
.EXAMPLE
    turtle TerdragonCurve    
.EXAMPLE
    turtle id Terdragon1 TerdragonCurve 42 1
.EXAMPLE
    turtle id Terdragon2 TerdragonCurve 42 2
.EXAMPLE
    turtle id Terdragon3 TerdragonCurve 42 3
.EXAMPLE
    turtle id Terdragon4 TerdragonCurve 42 4
.EXAMPLE
    turtle id Terdragon5 TerdragonCurve 42 5
.EXAMPLE
    turtle id Terdragon6 TerdragonCurve 42 6
.EXAMPLE
    turtle id Terdragon7 TerdragonCurve 42 7
.EXAMPLE
    turtle id Terdragon8 TerdragonCurve 42 8
.EXAMPLE
    turtle id EndlessTerdragon TerdragonCurve PatternTransform = @{
        'scale' = 0.9
        'rotate' = 45
    } PatternAnimation @(
        "<animateTransform attributeName='patternTransform' attributeType='XML' type='scale' values='1;0.9;1' dur='19s' repeatCount='indefinite' additive='sum' />"
        "<animateTransform attributeName='patternTransform' attributeType='XML' type='skewY' values='30;-30;30' dur='67s' repeatCount='indefinite' additive='sum' />"
        "<animateTransform attributeName='patternTransform' attributeType='XML' type='skewX' values='30;-30;30' dur='83s' repeatCount='indefinite' additive='sum' />"        
    )     
#>
param(
    [double]$Size = $(
        Get-Random -Min 42 -Max 84
    ),
    [int]$Order = (
        5,6,7,8 | Get-Random
    ),
    [double]$Angle = 120
)
return $this.LSystem('F',  [Ordered]@{
    F = 'F+F-F'    
}, $Order, [Ordered]@{
    '\+'    = { $this.Rotate($Angle) }
    '-'     = { $this.Rotate($Angle * -1) }
    '[F]'  = { $this.Forward($Size) }
})
