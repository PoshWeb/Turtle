<#
.SYNOPSIS
    Generates a Koch Snowflake.
.DESCRIPTION
    Generates a Koch Snowflake using turtle graphics.
.LINK
    https://en.wikipedia.org/wiki/Koch_snowflake#Representation_as_Lindenmayer_system
.EXAMPLE
    $turtle.KochSnowflake().Pattern.Save("$pwd/KochSnowflake.svg")
.EXAMPLE
    $turtle.Clear()
    $turtle.KochSnowflake(10,4)
    $turtle.PatternTransform = @{
        'scale' = 0.9        
    }    
    $turtle.PatternAnimation = "
    <animateTransform attributeName='patternTransform' attributeType='XML' type='scale' values='1;0.9;1' dur='19s' repeatCount='indefinite' additive='sum' />
    <animateTransform attributeName='patternTransform' attributeType='XML' type='skewY' values='0;-30;30;-30;0' dur='67s' repeatCount='indefinite' additive='sum' />
    <animateTransform attributeName='patternTransform' attributeType='XML' type='skewX' values='0;-30;30;-30;0' dur='83s' repeatCount='indefinite' additive='sum' />
    "
    $turtle.Pattern.Save("$pwd/KochSnowflake2.svg")
#>
param(
    [double]$Size = $(Get-Random -Min 5.0 -Max 20.0),    
    [int]$Order = (2,3,4 | Get-Random),
    [double]$Rotation = 60
)    
return $this.LSystem('F--F--F ',  @{
    F = 'F+F--F+F'
}, $Order, [Ordered]@{
    '\+' = { $this.Rotate($Rotation) }
    'F' =  { $this.Forward($Size) }    
    '-' = { $this.Rotate($Rotation * -1) }
})