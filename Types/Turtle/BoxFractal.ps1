<#
.EXAMPLE
    $turtle.PatternAnimation = ''    
    $turtle.Clear().BoxFractal().Pattern.Save("$pwd/BoxFractal.svg")
    
.EXAMPLE
    $turtle.Clear()
    $turtle.BoxFractal(10,4)
    $turtle.PatternTransform = @{
        'scale' = 0.9        
    }
    $turtle.PatternAnimation = "
    <animateTransform attributeName='patternTransform' attributeType='XML' type='scale' values='1;0.9;1' dur='19s' repeatCount='indefinite' additive='sum' />
    <animateTransform attributeName='patternTransform' attributeType='XML' type='skewY' values='0;-30;30;-30;0' dur='67s' repeatCount='indefinite' additive='sum' />
    <animateTransform attributeName='patternTransform' attributeType='XML' type='skewX' values='0;-30;30;-30;0' dur='83s' repeatCount='indefinite' additive='sum' />
    "
    $turtle.Pattern.Save("$pwd/BoxFractal2.svg")
#>
param(
    [double]$Size = (Get-Random -Min 21 -Max 42),
    [int]$Order = (2,3,4 | Get-Random),
    [double]$Angle = 90
)
return $this.LSystem('F-F-F-F',  [Ordered]@{
    F = 'F-F+F+F-F'
}, $Order, [Ordered]@{
    '\+'    = { $this.Rotate($Angle) }
    '-'     = { $this.Rotate($Angle * -1) }
    'F'     = { $this.Forward($Size) }
})

