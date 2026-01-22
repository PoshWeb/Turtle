<#
.SYNOPSIS
    Follow that Turtle!
.DESCRIPTION
    Basic behavior modelling with Turtle.

    A series of turtles will follow the next turtle.
#>
param(
# The size of the square
[double]
$Size = 200,

# The speed of each turtle
[double]
$Speed = 1,

# The number of steps
[int]
$StepCount
)

# If no steps were provided
if (-not $StepCount) {
    # double the size and divide by speed
    $StepCount = ($size * 2)/$speed
}

# Set up our turtles.
$followThatTurtle = turtle id FollowThatTurtle stroke '#4488ff' square $Size turtles ([Ordered]@{
    t1 = turtle teleport 0 0 stroke '#4488ff'
    t2 = turtle teleport $Size 0 stroke '#4488ff'
    t3 = turtle teleport $Size $Size stroke '#4488ff' 
    t4 = turtle teleport 0 $Size stroke '#4488ff'
})

# For each step
foreach ($n in 1..([Math]::Abs($StepCount))) {
    # Go to each turtle
    for ($turtleNumber = 0; $turtleNumber -lt $followThatTurtle.Turtles.Count; $turtleNumber++) {        
        $thisTurtle = $followThatTurtle.Turtles[$turtleNumber]
        # and find the next turtle
        $nextTurtle = if ($turtleNumber -eq $followThatTurtle.Turtles.Count - 1) {
            $followThatTurtle.Turtles[0]
        } else {
            $followThatTurtle.Turtles[$turtleNumber + 1]
        }
        # If we are more than 1 unit away
        if ($thisTurtle.Distance($nextTurtle) -ge 1) {
            # rotate towards it 
            $null = $thisTurtle.Rotate(
                $thisTurtle.Towards($nextTurtle)
            ).Forward($Speed) # and move forward.
        }        
    }
}


$followThatTurtle | turtle save ./FollowThatTurtle.svg
$followThatTurtle.Stroke = 'transparent'
$followThatTurtle | Save-Turtle ./FollowThatTurtlePattern.svg Pattern

