<#
.SYNOPSIS
    Draws a triflower pattern.
.DESCRIPTION
    Draws a triflower pattern in turtle graphics.

    This pattern consists of a series of polygons and rotations to create a flower-like design.
.EXAMPLE
    # Make a random triflower
    turtle TriFlower 
.EXAMPLE
    # Make a TriFlower with one side of 42, 
    # rotating 6 degrees each step, 
    # with a second side of 21
    turtle TriFlower 42 6 21 
.EXAMPLE
    # Make a TriFlower
    turtle TriFlower 42 20 6 18
.EXAMPLE
    turtle TriFlower 42 20 6 18
.EXAMPLE
    # Triflowers look amazing when morphed
    turtle TriFlower 42 8 -42 45 morph @(
        turtle TriFlower 42 8 -42 45
        turtle TriFlower 42 8 42 45
        turtle TriFlower 42 8 -42 45
    )
.EXAMPLE
    # We can make a triflower fold in on itself
    turtle TriFlower 42 15 -42 24 morph @(
        turtle TriFlower 42 60 -42 24    
        turtle TriFlower 42 15 -42 24
        turtle TriFlower 42 60 -42 24
    )
#>
param(
    # The size of the base shape
    [double]$Size = (
        ( Get-Random -Min 42 -Max 420 ) * (1,-1 | Get-Random)
    ),
    # The rotation after each step
    [double]$Rotation = (Get-Random -Min 10.0 -Max 120.0),
    # The number of sides in each shape
    [double]$Size2 = (
        ( Get-Random -Min 21 -Max 210 ) * (1,-1 | Get-Random)
    ),
    # The number of steps in the flower.
    [int]$StepCount = 0
)

if ($Rotation -eq 0) { return $this }

# If no step count was provided
if ($StepCount -eq 0) {
    # pick a random number of rotations
    $revolutions = (Get-Random -Minimum 1 -Max 16)
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
    $this.RightTriangle($Size, $Size2)
    $this.Rotate($Rotation)
}

return $this