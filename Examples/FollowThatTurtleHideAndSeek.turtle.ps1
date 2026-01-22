<#
.SYNOPSIS
    Hide and Seek
.DESCRIPTION
    Simple behavior modelling with Turtle.
.NOTES
    Imagine we have eight turtles playing hide and seek

    Four turtles are seeking.

    Four turtles are hiding.

    Each hiding turtle starts in the center.

    Each seeking turtle will chase a hiding turtle.

    Each hiding turtle will run away at an angle (by default 90 degrees).
#>
param(
[double]
$SquareSize = 200,
[double]
$HiderSpeed = 2,
[double]
$SeekerSpeedRatio = ((1 + [Math]::Sqrt(5))/2),
[double]
$EvadeAngle = 90
)

if ($PSScriptRoot) { Push-Location $PSScriptRoot}

$midpoint = ($squareSize/2), ($squareSize/2)
$seekerSpeed = $HiderSpeed * $SeekerSpeedRatio # (1 + (Get-Random -Min 10 -Max 50)/50) # (Get-Random -Min 1 -Max 5)
$stepCount = $squareSize/2 * (1 + ([Math]::Abs($attackerSpeed - $evaderSpeed)))

$hideAndSeek = turtle id hideAndSeek square $squareSize stroke '#4488ff' turtles ([Ordered]@{
    s1 = turtle teleport 0 0 stroke '#4488ff' # stroke 'red' pathclass 'red-stroke' fill red
    s2 = turtle teleport $squareSize 0 stroke '#4488ff' # stroke 'yellow' pathclass 'yellow-stroke' fill yellow
    s3 = turtle teleport $squareSize $squareSize stroke '#4488ff' # stroke 'green' pathclass 'green-stroke' fill green
    s4 = turtle teleport 0 $squareSize stroke '#4488ff' # stroke 'blue' PathClass 'blue-stroke' fill blue
    h1 = turtle teleport $midpoint stroke '#4488ff' # stroke 'red' fill 'red'
    h2 = turtle teleport $midpoint stroke '#4488ff' # stroke 'yellow' fill 'yellow'
    h3 = turtle teleport $midpoint stroke '#4488ff' # stroke 'green' fill 'green'
    h4 = turtle teleport $midpoint stroke '#4488ff' # stroke 'blue' fill 'blue'
})



# Since all attackers and evaders start with equal distances, 
# when we have caught one we have caught them all.
:caughtEm foreach ($n in 1..$stepCount) {

    # Get the seeker turtles
    $seekers = $hideAndSeek.Turtles[@($hideAndSeek.Turtles.Keys -match '^s')]
    # Get the hiding turtles
    $hiders = $hideAndSeek.Turtles[@($hideAndSeek.Turtles.Keys -match '^h')]

    for ($hiderNumber = 0; $hiderNumber -lt $hiders.Length; $hiderNumber++) {
        $thisTurtle = $hiders[$hiderNumber]
        $runningAwayFrom = $seekers[$hiderNumber % $seekers.Length]
        $null = $thisTurtle.Rotate(
            $thisTurtle.Towards($runningAwayFrom) + $evadeAngle # (Get-Random -Minimum 80 -Maximum 100)
        ).Forward($HiderSpeed)
    }
    
    for ($seekerNumber = 0; $seekerNumber -lt $seekers.Length; $seekerNumber++) {
        $thisTurtle = $seekers[$seekerNumber]
        $runningTowards = $hiders[$seekerNumber % $hiders.Length]
        $null = $thisTurtle.Rotate(
            $thisTurtle.Towards($runningTowards) # + (Get-Random -Minimum -10 -Maximum 10)
        ).Forward($seekerSpeed)
    }

    for ($seekerNumber = 0; $seekerNumber -lt $seekers.Length; $seekerNumber++) {
        $thisTurtle = $seekers[$seekerNumber]        
        $runningTowards = $hiders[$seekerNumber % $hiders.Length]
        if ($thisTurtle.Distance($runningTowards) -le 1) {
            break caughtEm
        }
    }
}


$hideAndSeek | turtle save ./FollowThatTurtleHideAndSeek.svg
$hideAndSeek.Stroke = 'transparent'
$hideAndSeek | Save-Turtle ./FollowThatTurtleHideAndSeekPattern.svg Pattern

if ($PSScriptRoot) { Pop-Location}