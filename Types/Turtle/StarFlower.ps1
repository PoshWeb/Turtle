<#
.SYNOPSIS
    Draws a star flower pattern.
.DESCRIPTION
    Draws a flower made out of stars.

    This pattern consists of a series of stars and rotations to create a flower-like design.
.EXAMPLE
    Turtle StarFlower
.EXAMPLE
    Turtle StarFlower 42 20 10
.EXAMPLE
    Turtle StarFlower 42 40 13 9
.EXAMPLE
    Turtle StarFlower 84 40 6 9 | Save-Turtle ./StarFlowerPattern.svg Pattern
#>
param(
    # The size of the base shape
    [double]$Size = $( Get-Random -Min 42 -Max 84 ),
    # The rotation after each step
    [double]$Rotation = (Get-Random -Min 10.0 -Max 120.0),
    
    # The number of points in the star    
    [double]$PointCount = (Get-Random -Min 5 -Max 12),
    # The number of steps.
    [int]$StepCount = 0
)



if ($Rotation -eq 0) { return $this }

# If no step count was provided
if ($StepCount -eq 0) {
    # pick a random number of rotations
    $revolutions = (Get-Random -Minimum 1 -Max 8)
    # and figure out how many steps at our angle it takes to get there.
    foreach ($n in 2..$revolutions) {
        $revNumber = ($revolutions * 360)/$Rotation
        $StepCount = [Math]::Ceiling($revNumber)
        if ([Math]::Floor($revNumber) -eq $revNumber) {
            break
        }
    }    
}

$null = foreach ($n in 1..([Math]::Abs($StepCount))) {    
    $this.Star($Size, $PointCount)
    $this.Rotate($Rotation)
}

return $this