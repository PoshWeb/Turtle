<#
.SYNOPSIS
    Draws a L-system pattern.
.DESCRIPTION
    Generates a pattern using a L-system.

    The initial string (Axiom) is transformed according to the rules provided for a specified number of iterations.    
.LINK
    https://en.wikipedia.org/wiki/L-system
.EXAMPLE        
    # Box Fractal L-System
    $Box = 'F-F-F-F'
    $Fractal = 'F-F+F+F-F'
    
    $turtle.Clear().LSystem(
            $Box, 
            [Ordered]@{ F = $Fractal },
            3, 
            @{
                F = { $this.Forward(10) }
                J = { $this.Jump(10) }
                '\+' = { $this.Rotate(90) }            
                '-' = { $this.Rotate(-90) }
            }
    ).Pattern.Save("$pwd/BoxFractalLSystem.svg")
.EXAMPLE
    # Fractal L-System
    $Box = 'FFFF-FFFF-FFFF-FFFF' 
    $Fractal = 'F-F+F+F-F'
        
    $turtle.Clear().LSystem(
            $Box, 
            [Ordered]@{ F = $Fractal },
            4, 
            @{
                F = { $this.Forward(10) }
                J = { $this.Jump(10) }
                '\+' = { $this.Rotate(90) }            
                '-' = { $this.Rotate(-90) }
            }
    ).Symbol.Save("$pwd/FractalLSystem.svg")
.EXAMPLE
    # Arrowhead Fractal L-System
    $Box = 'FF-FF-FF' 
    $Fractal = 'F-F+F+F-F'
    
    
    $turtle.Clear().LSystem(
            $Box, 
            [Ordered]@{ F = $Fractal },
            4, 
            @{
                F = { $this.Forward(10) }
                J = { $this.Jump(10) }
                '\+' = { $this.Rotate(90) }            
                '-' = { $this.Rotate(-90) }
            }
    ).Pattern.Save("$pwd/ArrowheadFractalLSystem.svg")
.EXAMPLE
    # Tetroid LSystem
    $turtle.Clear().LSystem(
            'F', 
            [Ordered]@{ F = 'F+F+F+F' + 
                '+JJJJ+' + 
                'F+F+F+F' + 
                '++JJJJ' +
                'F+F+F+F' +
                '++JJJJ' +
                'F+F+F+F' +
                '++JJJJ' + 
                '-JJJJ'
            },                
            3, 
            @{
                F = { $this.Forward(10) }
                J = { $this.Jump(10) }
                '\+' = { $this.Rotate(90) }            
                '-' = { $this.Rotate(-90) }
            }
    ).Pattern.Save("$pwd/TetroidLSystem.svg")

.EXAMPLE
    $turtle.Clear().LSystem(
        'F', 
        [Ordered]@{ F = '
F+F+F+F +JJJJ+ F+F+F+F ++ JJJJ' },
        3, 
        @{
            F = { $this.Forward(10) }
            J = { $this.Jump(10) }
            '\+' = { $this.Rotate(90) }            
            '-' = { $this.Rotate(-90) }
        }
    ).Pattern.Save("$pwd/LSystemCool1.svg")
.EXAMPLE
    Move-Turtle LSystem F-F-F-F ([Ordered]@{F='F-F+F+F-F'}) 3 (
        [Ordered]@{
            F = { $this.Forward(10) }
            J = { $this.Jump(10) }
            '\+' = { $this.Rotate(90) }            
            '-' = { $this.Rotate(-90) }
        }
    )
    
#>
param(
# The axiom, or starting string.
[Alias('Start', 'StartString', 'Initiator')]
[string]
$Axiom,

# The rules for expanding each iteration of the axiom.
[Alias('Rules', 'ProductionRules')]
[Collections.IDictionary]
$Rule = [Ordered]@{},

# The order of magnitude (or number of iterations)
[Alias('Iterations', 'IterationCount', 'N', 'Steps', 'StepCount')]
[int]
$Order = 2,

# The ways each variable will be expanded.
[Collections.IDictionary]
$Variable = @{}

)

# First, let us expand our axiom
$currentState = "$Axiom"
# (at least, as long as we're supposed to)
if ($Order -ge 1) {
    $combinedPattern = "(?>$($Rule.Keys -join '|'))"
    foreach ($iteration in 1..$Order) {
        # To expand each iteration, we replace any matching characters
        $currentState = $currentState -replace $combinedPattern, {
            $match = $_
            $matchingRule = $rule["$match"]
            # a matching rule could be dynamically specified with a script block
            if ($matchingRule -is [ScriptBlock]) {
                return "$(. $matchingRule $match)"
            } else {
                # but is often statically expanded with a string.
                return $matchingRule
            }
        }    
    }        
}

# Now we know our final state
$finalState = $currentState

# and can add the appropriate data attributes.
$this.PathAttribute = [Ordered]@{
    "data-l-order" = $Order
    "data-l-axiom" = $Axiom
    "data-l-rules" = ConvertTo-Json $Rule 
    "data-l-expanded" = $finalState
}

# Next, prepare our replacements.
# The provided script block will almost always be scoped differently
# so we need to recreate it.
$localReplacement = [Ordered]@{}
foreach ($key in $variable.Keys) {
    $localReplacement[$key] =
        if ($variable[$key] -is [ScriptBlock]) {
            [ScriptBlock]::Create($variable[$key])
        } else {
            $variable[$key]
        }
}

# Now we need to find all potential matches
$MatchesAny = "(?>$($variable.Keys -join '|'))"
$allMatches = @([Regex]::Matches($finalState, $MatchesAny, 'IgnoreCase,IgnorePatternWhitespace'))
# we want to minimize rematching, so create a temporary cache.
$matchCache = @{}
:nextMatch foreach ($match in $allMatches) {
    $m = "$match"
    # If we have not mapped the match to a script,
    if (-not $matchCache[$m]) {
        # find the matching replacement.
        foreach ($key in $Variable.Keys) {
            if (-not ($match -match $key)) { continue }     
            $matchCache[$m] = $localReplacement[$key]
            break
        }    
    }
    
    # If we have a script to run
    if ($matchCache[$m] -is [ScriptBlock]) {
        # run it
        $null =  . $matchCache[$m] $match
        # and continue to the next match.
        continue nextMatch
    }
}

# return this so we can pipe and chain this method.
return $this
