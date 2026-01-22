<#
.SYNOPSIS
    Draws a arcflower pattern.
.DESCRIPTION
    Draws a arcflower pattern in turtle graphics.

    This pattern consists of a series of CircleArcs and rotations to create a flower-like design.
.EXAMPLE    
    turtle ArcFlower 42 6 21 
.EXAMPLE
    turtle ArcFlower 42 20 21 18
.EXAMPLE
    turtle ArcFlower 42 20 6 18
#>
param(
    # The size of the base shape
    [double]$Size = (
        ( Get-Random -Min 21 -Max 84 ) * (1,-1 | Get-Random)
    ),
    # The rotation after each step
    [double]$Rotation = (Get-Random -Min 10 -Max 90),
    # The number of sides in each shape
    [double]$Angle = (
        ( Get-Random -Min 21 -Max 84 ) * (1,-1 | Get-Random)
    ),
    # The number of steps in the flower.
    [int]$StepCount = 0
)

if ($Rotation -eq 0) { return $this }

# If no step count was provided
if ($StepCount -eq 0) {
    # pick a random number of rotations
    $revolutions = (Get-Random -Minimum 1 -Max 64)
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
    $this.
        CircleArc($Size, $Angle).
        Rotate($Rotation)
}

return $this