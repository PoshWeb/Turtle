<#
.SYNOPSIS
    Generates a Sierpinski Arrowhead Curve.
.DESCRIPTION
    Generates a Sierpinski Arrowhead Curve using turtle graphics.
.LINK
    https://en.wikipedia.org/wiki/Sierpi%C5%84ski_curve#Representation_as_Lindenmayer_system_2
.EXAMPLE
    $turtle.SierpinskiArrowheadCurve().Pattern.Save("$pwd/SierpinskiArrowhead.svg")
.EXAMPLE
    $turtle.Clear()
    $turtle.SierpinskiArrowheadCurve(10,4)
    $turtle.PatternTransform = @{
        'scale' = 0.9        
    }    
    $turtle.PatternAnimation = "
    <animateTransform attributeName='patternTransform' attributeType='XML' type='scale' values='1;0.9;1' dur='19s' repeatCount='indefinite' additive='sum' />
    <animateTransform attributeName='patternTransform' attributeType='XML' type='skewY' values='0;-30;30;-30;0' dur='67s' repeatCount='indefinite' additive='sum' />
    <animateTransform attributeName='patternTransform' attributeType='XML' type='skewX' values='0;-30;30;-30;0' dur='83s' repeatCount='indefinite' additive='sum' />
    "
    $turtle.Pattern.Save("$pwd/SierpinskiArrowhead2.svg")
#>

param(
    [double]$Size = $(Get-Random -Min 21 -Max 42),
    [int]$Order = $(Get-Random -Min 4 -Max 8),
    [double]$Angle = 60
)
return $this.LSystem('XF',  [Ordered]@{
    X = 'YF + XF + Y'
    Y = 'XF - YF - X'
}, $Order, [Ordered]@{
    '\+'    = { $this.Rotate($Angle)        }
    '-'     = { $this.Rotate($Angle * -1)   }
    'F'     = { $this.Forward($Size)        }
})
