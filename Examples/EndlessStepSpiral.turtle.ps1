Push-Location $PSScriptRoot
$myName = $MyInvocation.MyCommand.Name -replace '\.turtle\.ps1$'
$turtle = turtle id EndlessStepSpiral @('StepSpiral',16, 90, 16, 20, 'rotate',90 * 4) | 
    Set-Turtle -Property PatternTransform -Value @{scale=1} |
    # set-turtle -property Fill -value 'currentColor' |
    # set-turtle -property FillRule -value 'evenodd' |
    Set-Turtle -Property PatternAnimation -Value ([Ordered]@{
        type = 'scale'    ; values = 0.66,0.33, 0.66 ; repeatCount = 'indefinite' ;dur = "23s"; additive = 'sum'
    }, [Ordered]@{
        type = 'rotate'   ; values = 0, 360 ;repeatCount = 'indefinite'; dur = "41s"; additive = 'sum'
    }, [Ordered]@{
        type = 'translate';values = "0 0","42 42", "0 0";repeatCount = 'indefinite';additive = 'sum';dur = "117s"
    })    
    
$turtle | save-turtle -Path "./$myName.svg" -Property Pattern
Pop-Location