<#
.SYNOPSIS
    Draws a golden rectangle flower pattern.
.DESCRIPTION
    Draws a flower made out of golden rectangles.

    This pattern consists of a series of rectangles and rotations to create a flower-like design.
.EXAMPLE
    Turtle GoldenFlower
.EXAMPLE
    Turtle GoldenFlower 42 10 36
.EXAMPLE
    Turtle GoldenFlower 42 5 72
.EXAMPLE
    Turtle GoldenFlower 84 30 12 | Save-Turtle ./GoldenFlowerPattern.svg Pattern
#>
param(
    # The width of each rectangle
    [double]$Size = $( Get-Random -Min 42 -Max 84 ),
    # The rotation after each step
    [double]$Rotation = (Get-Random -Min 10.0 -Max 120.0),
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
    $this.Rectangle($Size)
    $this.Rotate($Rotation)
}

return $this