<#
.SYNOPSIS
    Generates a Sierpinski Triangle.
.DESCRIPTION
    Generates a Sierpinski Triangle using turtle graphics.
.LINK
    https://en.wikipedia.org/wiki/Sierpi%C5%84ski_triangle
.EXAMPLE
    $turtle.SierpinskiTriangle().Pattern.Save("$pwd/SierpinskiTriangle.svg")
.EXAMPLE
    $turtle.Clear()
    $turtle.SierpinskiTriangle(10,6)
    $turtle.PatternTransform = @{
        'scale' = 0.9        
    }    
    $turtle.PatternAnimation = "
    <animateTransform attributeName='patternTransform' attributeType='XML' type='scale' values='1;0.9;1' dur='19s' repeatCount='indefinite' additive='sum' />
    <animateTransform attributeName='patternTransform' attributeType='XML' type='skewY' values='0;-30;30;-30;0' dur='67s' repeatCount='indefinite' additive='sum' />
    <animateTransform attributeName='patternTransform' attributeType='XML' type='skewX' values='0;-30;30;-30;0' dur='83s' repeatCount='indefinite' additive='sum' />
    <animateTransform attributeName='patternTransform' attributeType='XML' type='rotate' values='0;360' dur='163s' repeatCount='indefinite' additive='sum' />
    <animateTransform attributeName='patternTransform' attributeType='XML' type='translate' values='0 0;200 200;0 0' dur='283s' repeatCount='indefinite' additive='sum' />
    "
    $turtle.Pattern.Save("$pwd/SierpinskiTriangle2.svg")
#>
param(
    [double]$Size = (Get-Random -Min 42 -Max 84),
    [int]$Order = $(Get-Random -Min 3 -Max 5),
    [double]$Angle = 120
)
return $this.LSystem('F-G-G',  [Ordered]@{
    F = 'F-G+F+G-F'
    G = 'GG'
}, $Order, [Ordered]@{
    '\+'    = { $this.Rotate($Angle) }
    '-'     = { $this.Rotate($Angle * -1) }
    '[FG]'  = { $this.Forward($Size) }
})
