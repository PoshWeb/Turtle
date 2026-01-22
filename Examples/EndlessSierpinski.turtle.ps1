#requires -Module Turtle
Push-Location $PSScriptRoot
$turtle = turtle id EndlessSierpinskiTriangle SierpinskiTriangle 25 5  |
    Set-Turtle PatternTransform @{
        scale = 0.66
    } |
    Set-Turtle Stroke '#4488ff'

$turtle.PatternAnimation += "
<animateTransform attributeName='patternTransform' attributeType='XML' type='scale' values='0.66;0.33;0.66' dur='19s' repeatCount='indefinite' additive='sum' />
"

$turtle.PatternAnimation += "
<animateTransform attributeName='patternTransform' attributeType='XML' type='rotate' from='0' to='360' dur='29s' repeatCount='indefinite' additive='sum' />
"

$turtle.PatternAnimation += "
<animateTransform attributeName='patternTransform' attributeType='XML' type='skewX' values='30;-30;30' dur='67s' repeatCount='indefinite' additive='sum' />
"

$turtle.PatternAnimation += "
<animateTransform attributeName='patternTransform' attributeType='XML' type='skewY' values='30;-30;30' dur='83s' repeatCount='indefinite' additive='sum' />
"

$turtle.PatternAnimation += "
<animateTransform attributeName='patternTransform' attributeType='XML' type='translate' values='0 0;42 42;0 0' dur='103s' repeatCount='indefinite' additive='sum' />
"

$turtle | 
    Save-Turtle -Path "./EndlessSierpinskiTrianglePattern.svg" -Property Pattern

Pop-Location