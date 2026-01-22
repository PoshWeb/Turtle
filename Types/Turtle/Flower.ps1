<#
.SYNOPSIS
    Draws a flower pattern.
.DESCRIPTION
    Draws a flower pattern in turtle graphics.

    This pattern consists of a series of polygons and rotations to create a flower-like design.
.EXAMPLE    
    turtle Flower 42
.EXAMPLE
    turtle Flower 42 20 6 18
.EXAMPLE
    turtle Flower 42 20 6 18
.EXAMPLE
    # We can make Flowers with partial polygons
    turtle Flower 42 20 6.6 18
.EXAMPLE
    # They are surprisingly beautiful     
    turtle Flower 42 30 7.7 12
#>
param(
    # The size of the base shape
    [double]$Size = $( Get-Random -Min 42 -Max 84 ),
    # The rotation after each step
    [double]$Rotation = (Get-Random -Min 10.0 -Max 120.0),
    # The number of sides in each shape
    [double]$SideCount = $( Get-Random -Min 3 -Max 12 ),
    # The number of steps in the flower.
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
    $this.Polygon($Size, $SideCount)
    $this.Rotate($Rotation)
}

return $this