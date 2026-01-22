Push-Location $PSScriptRoot
$turtle = turtle id EndlessBoxFractal BoxFractal 20 4 | 
    set-turtle -property Fill -value '#4488ff' | 
    set-turtle -property backgroundColor '#224488' |
    Set-Turtle -Property PatternTransform @{scale=0.5} |
    Set-Turtle -Property PatternAnimation -Value "

    <animateTransform attributeName='patternTransform' attributeType='XML' type='scale' values='0.66;0.33;0.66' dur='19s' repeatCount='indefinite' additive='sum' />

    <animateTransform attributeName='patternTransform' attributeType='XML' type='rotate' from='0' to='360' dur='29s' repeatCount='indefinite' additive='sum' />

    <animateTransform attributeName='patternTransform' attributeType='XML' type='skewX' values='30;-30;30' dur='67s' repeatCount='indefinite' additive='sum' />

    <animateTransform attributeName='patternTransform' attributeType='XML' type='skewY' values='30;-30;30' dur='83s' repeatCount='indefinite' additive='sum' />

    <animateTransform attributeName='patternTransform' attributeType='XML' type='translate' values='0 0;42 42;0 0' dur='103s' repeatCount='indefinite' additive='sum' />

    "
    


    
$turtle | save-turtle -Path ./EndlessBoxFractal.svg -Property Pattern
Pop-Location