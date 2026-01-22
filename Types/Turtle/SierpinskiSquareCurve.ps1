<#
.SYNOPSIS
    Generates a Sierpinski Square Curve.
.DESCRIPTION
    Generates a Sierpinski Square Curve using turtle graphics.
.LINK
    https://en.wikipedia.org/wiki/Sierpi%C5%84ski_curve#Representation_as_Lindenmayer_system
.EXAMPLE
    $turtle.SierpinskiSquareCurve().Pattern.Save("$pwd/SierpinskiSquareCurve.svg")
.EXAMPLE
    $turtle.Clear()
    $turtle.SierpinskiSquareCurve(10,4)
    $turtle.PatternTransform = @{
        'scale' = 0.9        
    }    
    $turtle.PatternAnimation = "
    <animateTransform attributeName='patternTransform' attributeType='XML' type='scale' values='1;0.9;1' dur='19s' repeatCount='indefinite' additive='sum' />
    <animateTransform attributeName='patternTransform' attributeType='XML' type='skewY' values='0;-30;30;-30;0' dur='67s' repeatCount='indefinite' additive='sum' />
    <animateTransform attributeName='patternTransform' attributeType='XML' type='skewX' values='0;-30;30;-30;0' dur='83s' repeatCount='indefinite' additive='sum' />
    "
    $turtle.Pattern.Save("$pwd/SierpinskiSquareCurve2.svg")
#>
param(
    [double]$Size = (Get-Random -Min 21 -Max 42),
    [int]$Order = (2,3,4,5 | Get-Random),
    [double]$Angle = 90
)
return $this.LSystem('X',  [Ordered]@{
    X = 'XF-F+F-XF+F+XF-F+F-X'
}, $Order, [Ordered]@{
    '\+'    = { $this.Rotate($Angle) }
    '-'     = { $this.Rotate($Angle * -1) }
    '[FG]'  = { $this.Forward($Size) }
})
