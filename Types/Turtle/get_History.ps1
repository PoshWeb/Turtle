<#
.SYNOPSIS
    Gets a Turtle's history
.DESCRIPTION
    Gets an annotated history of a turtle's movements.

    This is an SVG path translated into back into human readable text and coordinates.
#>

# We will always know where we are (relative to where we started, at least)
# But knowing where we have _been_?  That's going to take a bit of work.
# SVG paths can be either absolute or relative
# So to know where we have been, we need to retrace our steps.

# So let's keep our current position
$currentPosition = [Numerics.Vector2]::new(0,0)
# make a history list
$historyList = [Collections.Generic.List[PSObject]]::new()
# and create a stack to traceback our steps
$startStack = [Collections.Stack]::new()

# SVG paths proceed letter by letter, 
# so we want a pattern to split at that point
$BeforeNextLetter =
    @(
        '(?='      # Lookahead for
        '['        # this set of characters:
        '\p{L}'    # Any letter
        '-'        # except
        '[E]'      # the letter 'e' (used in exponent notation).
        ']'        # Now close the character set
        ')'        # and close the lookahead.        
    ) -join ''

# Get our path data
$pathData = $this.PathData
# then split it into steps and remove empty steps.
$pathSteps = $pathData -join ' ' -split $BeforeNextLetter -ne ''

# Now let's do some history:
foreach ($pathStep in $pathSteps) {
    # First, determine what letter we are dealing with    
    $letter = $pathStep[0]
    # Like a lot of G-Code, SVG paths are case sensitive
    # so find out if it is uppercase by using a case sensitive comparison.
    $isUpper = "$letter".ToLower() -cne $letter
    # If it was uppercase,
    $toBy = 
        if ($isUpper) {
            'to' # the movement is absolute (to)
        } else {
            'by' # if it is lowercase, the movement is relative (by)
        }    

    # Now let's turn each step into a floating point (except the letter)
    $stepPoints = $pathStep -replace $letter -replace ',', ' ' -split '\s{1,}' -ne '' -as [float[]]
    
    # This next part is a great example of a maxim of mine:
    # Programming is tedious, not hard.

    # There are only 10 different letters in SVG syntax
    # Unfortunately, that's 10 slightly different ways to write a bit of a path.

    # They all boil down to: a letter followed by sets of N numbers

    # They almost all treat repeating numbers as additional steps

    # But we still need to handle each slightly differently.

    # So, here we go
    
    # In (mostly) alphabetical order:
    
    $historyEntry = 
    switch ($letter) {
        a {
            # `a` is for arc path
            # These take 7 steps
            # "a $RadiusX $RadiusY $Rotation $IsBigArc $IsSweep $DeltaX $DeltaY"
            for ($stepIndex = 0; $stepIndex -lt $stepPoints.Length; $stepIndex+=7) {
                $sequence = $stepPoints[$stepIndex..($stepIndex + 6)]
                $comment = "arc $toBy $sequence"                
                $delta = [Numerics.Vector2]::new.Invoke($sequence[@(-2,-1)])
                # If they are absolute coordinates,
                # subtract them to get a delta.
                if ($isUpper) { $delta -= $currentPosition }
                # Create our history entry
                [PSCustomObject]@{
                    PSTypeName='Turtle.History'
                    Letter = "$letter"
                    Start = $currentPosition
                    End = $currentPosition + $delta
                    Delta = $delta
                    Instruction = "$Letter $sequence"                    
                    Comment = $comment
                }
                # update our position and go to the next set of points.
                $currentPosition += $delta
            }
        }
        c {
            # `c` is for cubic bezier curve
            # Cubic bezier curves take 6 points:
            # "c $ControlX1 $ControlY1 $ControlX2 $ControlY2 $DeltaX $DeltaY"            
            for ($stepIndex = 0; $stepIndex -lt $stepPoints.Length; $stepIndex+=6) {
                $sequence = $stepPoints[$stepIndex..($stepIndex + 5)]
                $comment = "cubic curve $toBy $sequence"
                $delta = [Numerics.Vector2]::new.Invoke($sequence[@(-2,-1)])
                # If they are absolute coordinates,
                # subtract them to get a delta.
                if ($isUpper) { $delta -= $currentPosition }
                # Create our history entry
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
            # `l` is for line segment
            # These take pairs of points:
            # `l $DeltaX $DeltaY`
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
            # `m` is for move
            # Move is a pair of points
            # The first pair moves without drawing            
            # "m $DeltaX $DeltaY"
            # Any more points are drawn, and effectively become
            # "l $DeltaX $DeltaY"

            # So let's go over each m in pairs.
            for ($stepIndex = 0; $stepIndex -lt $stepPoints.Length; $stepIndex+=2) {
                $sequence = $stepPoints[$stepIndex..($stepIndex + 1)]
                $comment = "line $toBy $sequence"
                $delta = [Numerics.Vector2]::new.Invoke($sequence[@(-2,-1)])                                
                if ($isUpper) { $delta -= $currentPosition }
                # If we have more than one step
                if ($stepIndex -gt 0) {                    
                    if ($letter -eq 'm') {
                        # make it an l or L, depending on the case
                        if ($isUpper) { $letter = 'L' }
                        else { $letter = 'l'}
                    }
                    $comment = "line $toBy $sequence"
                } else {
                    # If it was actually a move we also need to 
                    $comment = "move $toBy $sequence"
                    # push this into our "start stack".
                    # Whenever we close paths, this is the point we are closing to.
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
        q {            
            # `q` is for quadratic bezier curve
            # It takes a control point and and an end point
            # "q $ControlX $controlY $DeltaX $DeltaY"
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
        s {
            # `s` is a simple or sine bezier curve
            # It takes a control point and an end point
            # "q $ControlX $controlY $DeltaX $DeltaY"
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
            # This tries to continue the last bezier curve
            # It only has a deltaX and deltaY.
            # "t $DeltaX $DeltaY"
            # It will use the last `s` or `t` as the control point
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
        # `h` is for horizontal and `v` is for vertical
        # Each of these draw a straight line
        # "h $Distance"
        # "v $Distance"
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
            # `z` is for close
            # This takes no parameters
            # Instead it tries to close the shape.
            # It draws a line back to the last location stack
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

# Now that we've done some history, return our results to you. 

# This should give a full history of every move this turtle has made, and exactly where it was after each step.

return $historyList