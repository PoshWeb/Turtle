<#
.SYNOPSIS
    Gets a Turtle's history
.DESCRIPTION
    Gets an annotated history of a turtle's movements.

    This is an SVG path translated into back into human readable text and coordinates.
#>
$currentPosition = [Numerics.Vector2]::new(0,0)
$historyList = [Collections.Generic.List[PSObject]]::new()
$startStack = [Collections.Stack]::new()
foreach ($pathStep in $this.PathData -join ' ' -split '(?=[\p{L}-[E]])' -ne '') {
    $letter = $pathStep[0]
    $isUpper = "$letter".ToLower() -cne $letter
    $isLower = -not $isUpper
    $toBy = if ($isUpper) { 'to'} else { 'by'}    
    $stepPoints = $pathStep -replace $letter -replace ',', ' ' -split '\s{1,}' -ne '' -as [float[]]
    
    $historyEntry = 
    switch ($letter) {
        a {            
            for ($stepIndex = 0; $stepIndex -lt $stepPoints.Length; $stepIndex+=7) {
                $sequence = $stepPoints[$stepIndex..($stepIndex + 6)]
                $comment = "arc $toBy $sequence"
                $delta = [Numerics.Vector2]::new.Invoke($sequence[@(-2,-1)])
                if ($isUpper) { $delta -= $currentPosition }
                [PSCustomObject]@{
                    PSTypeName='Turtle.History'
                    Letter = "$letter"
                    Start = $currentPosition
                    End = $currentPosition + $delta
                    Delta = $delta
                    Instruction = "$Letter $sequence"                    
                    Comment = $comment
                }
                $currentPosition += $delta
            }
        }
        c {
            
            for ($stepIndex = 0; $stepIndex -lt $stepPoints.Length; $stepIndex+=6) {
                $sequence = $stepPoints[$stepIndex..($stepIndex + 5)]
                $comment = "cubic curve $toBy $sequence"
                $delta = [Numerics.Vector2]::new.Invoke($sequence[@(-2,-1)])
                if ($isUpper) { $delta -= $currentPosition }
                [PSCustomObject]@{
                    PSTypeName='Turtle.History'
                    Letter = "$letter"
                    Start = $currentPosition
                    End = $currentPosition + $delta
                    Delta = $delta
                    Instruction = "$Letter $sequence"                    
                    Comment = $comment
                }
                $currentPosition += $delta
            }
        }
        l {
            # line segment
            for ($stepIndex = 0; $stepIndex -lt $stepPoints.Length; $stepIndex+=2) {
                $sequence = $stepPoints[$stepIndex..($stepIndex + 1)]
                $comment = "line $toBy $sequence"
                $delta = [Numerics.Vector2]::new.Invoke($sequence[@(-2,-1)])
                if ($isUpper) { $delta -= $currentPosition }
                [PSCustomObject]@{
                    PSTypeName='Turtle.History'
                    Letter = "$letter"
                    Start = $currentPosition
                    End = $currentPosition + $delta
                    Delta = $delta
                    Instruction = "$Letter $sequence"
                    Comment = $comment
                }
                $currentPosition += $delta
            }
        }
        m { 
            # movement
            for ($stepIndex = 0; $stepIndex -lt $stepPoints.Length; $stepIndex+=2) {
                $sequence = $stepPoints[$stepIndex..($stepIndex + 1)]

                $comment = "line $toBy $sequence"

                $delta = [Numerics.Vector2]::new.Invoke($sequence[@(-2,-1)])
                
                if ($isUpper) { $delta -= $currentPosition }

                if ($stepIndex -gt 0) {                    
                    if ($letter -eq 'm') {
                        if ($isUpper) { $letter = 'L' }
                        else { $letter = 'l'}
                    }
                    $comment = "line $toBy $sequence"                    
                } else {
                    $comment = "move $toBy $sequence"
                    $startStack.Push($currentPosition + $delta)
                }
                
                [PSCustomObject]@{
                    PSTypeName='Turtle.History'
                    Letter = "$letter"
                    Start = $currentPosition
                    End = $currentPosition + $delta
                    Delta = $delta
                    Instruction = "$Letter $sequence"
                    Comment = $comment
                }
                $currentPosition += $delta
            }
        }
        s {
            # simple bezier curve
            for ($stepIndex = 0; $stepIndex -lt $stepPoints.Length; $stepIndex+=4) {
                $sequence = $stepPoints[$stepIndex..($stepIndex + 3)]
                $comment = "simple bezier curve $toBy $sequence"
                $delta = [Numerics.Vector2]::new.Invoke($sequence[@(-2,-1)])
                if ($isUpper) { $delta -= $currentPosition }
                [PSCustomObject]@{
                    PSTypeName='Turtle.History'
                    Letter = "$letter"
                    Start = $currentPosition
                    End = $currentPosition + $delta
                    Delta = $delta
                    Instruction = "$Letter $sequence"
                    Comment = $comment
                }                
                $currentPosition += $delta
            }
        }
        t {
            # continue simple bezier curve            
            for ($stepIndex = 0; $stepIndex -lt $stepPoints.Length; $stepIndex+=2) {
                $sequence = $stepPoints[$stepIndex..($stepIndex + 1)]
                $comment = "continue bezier curve $toBy $sequence"
                $delta = [Numerics.Vector2]::new.Invoke($sequence[@(-2,-1)])
                if ($isUpper) { $delta -= $currentPosition }
                [PSCustomObject]@{
                    PSTypeName='Turtle.History'
                    Letter = "$letter"
                    Start = $currentPosition
                    End = $currentPosition + $delta
                    Delta = $delta
                    Instruction = "$Letter $sequence"
                    Comment = $comment
                }                
                $currentPosition += $delta
            } 
        }
        q {            
            for ($stepIndex = 0; $stepIndex -lt $stepPoints.Length; $stepIndex+=4) {
                
                $sequence = $stepPoints[$stepIndex..($stepIndex + 3)]
                $comment = "quadratic bezier curve $toBy $sequence"
                $delta = [Numerics.Vector2]::new.Invoke($sequence[@(-2,-1)])
                if ($isUpper) { $delta -= $currentPosition }
                [PSCustomObject]@{
                    PSTypeName='Turtle.History'
                    Letter = "$letter"
                    Start = $currentPosition
                    End = $currentPosition + $delta
                    Delta = $delta
                    Instruction = "$Letter $sequence"
                    Comment = $comment
                }                
                $currentPosition += $delta
            }
        }
        { $_ -in 'h', 'v' } {
            for ($stepIndex = 0; $stepIndex -lt $stepPoints.Length; $stepIndex++) {                
                $sequence = $stepPoints[$stepIndex..$stepIndex]
                $comment = "$(
                        if ($letter -eq 'v') { 'vertical' } else {'horizontal'}
                ) line $toBy $sequence"
                $delta = 
                    if ($letter -eq 'v') {
                        [Numerics.Vector2]::new(0, $sequence[0])
                    } else {
                        [Numerics.Vector2]::new($sequence[0], 0)
                    }
                if ($isUpper) { $delta -= $currentPosition }
                [PSCustomObject]@{
                    PSTypeName='Turtle.History'
                    Letter = "$letter"
                    Start = $currentPosition
                    End = $currentPosition + $delta
                    Delta = $delta
                    Instruction = "$Letter $sequence"
                    Comment = $comment
                }                
                $currentPosition += $delta
            }                        
        }        
        z {
            $closePosition = $startStack.Pop()
            $delta = $closePosition - $currentPosition
            [PSCustomObject]@{
                PSTypeName='Turtle.History'
                Letter = "$letter"
                Start = $currentPosition
                End = $currentPosition + $delta
                Delta = $delta
                Instruction = "$Letter"
                Comment = "close path"
            }
            $currentPosition += $delta
            
        }                
    }

    $historyList.Add($historyEntry)
}


return $historyList