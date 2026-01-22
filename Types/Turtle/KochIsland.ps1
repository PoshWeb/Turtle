<#
.SYNOPSIS
    Generates a Koch Island
.DESCRIPTION
    Generates a Koch Island using turtle graphics.   
.EXAMPLE
    $turtle.KochIsland().Pattern.Save("$pwd/KochIsland.svg")
.EXAMPLE
    $turtle.Clear()
    $turtle.KochIsland(10,4)
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
    $turtle.Pattern.Save("$pwd/KochIsland2.svg")
#>
param(
    [double]$Size = $(Get-Random -Min 5.0 -Max 20.0),    
    [int]$Order = (2,3,4 | Get-Random),
    [double]$Angle = -90
)

return $this.LSystem('W',  [Ordered]@{
    W = 'F+F+F+F'
    F = 'F+F-F-FF+F+F-F'
}, $Order, [Ordered]@{
    '\+'    = { $this.Rotate($Angle) }
    '-'     = { $this.Rotate($Angle * -1) }
    '[FG]'  = { $this.Forward($Size) }
})
