<#
.SYNOPSIS
    Generates a Twin Dragon Curve.
.DESCRIPTION
    Generates a Twin Dragon Curve using turtle graphics.
.LINK
    https://en.wikipedia.org/wiki/Dragon_curve#Twindragon
.EXAMPLE
    $turtle.TwinDragonCurve().Pattern.Save("$pwd/TwinDragonCurve.svg")
.EXAMPLE
    $turtle.Clear()
    $turtle.TwinDragonCurve(20,7,90)
    $turtle.PatternTransform = @{
        'scale' = 0.9
        'rotate' = 45
    }
    
    $turtle.PatternAnimation = "
    <animateTransform attributeName='patternTransform' attributeType='XML' type='scale' values='1;0.9;1' dur='19s' repeatCount='indefinite' additive='sum' />
    <animateTransform attributeName='patternTransform' attributeType='XML' type='skewY' values='30;-30;30' dur='67s' repeatCount='indefinite' additive='sum' />
    <animateTransform attributeName='patternTransform' attributeType='XML' type='skewX' values='30;-30;30' dur='83s' repeatCount='indefinite' additive='sum' />
    "
    $turtle.Pattern.Save("$pwd/TwinDragonCurve2.svg")
#>

param(
    [double]$Size = (Get-Random -Min 21 -Max 42),
    [int]$Order = (3,4,5,6, 7, 8 | Get-Random ),
    [double]$Angle = 90
)
return $this.LSystem('FX+FX+',  [Ordered]@{
    X = 'X+YF'
    Y = 'FX-Y'
}, $Order, [Ordered]@{
    '\+'    = { $this.Rotate($Angle) }
    '\-'     = { $this.Rotate($Angle * -1) }
    '[F]'  = { $this.Forward($Size) }
})
