<#
.SYNOPSIS
    Draws a flower made of petals
.DESCRIPTION
    Draws a flower made of a series of petals.  
    
    Each petal is a combination of two arcs and rotations.
.EXAMPLE
    turtle FlowerPetal 60
#>
param(
# The radius of the flower
[double]
$Radius = $(Get-Random -Minimum 42 -Maximum 84),

# The rotation per step 
[double]
$Rotation = $(Get-Random -Minimum 10 -Maximum 90),

# The angle of the petal.
[double]
$PetalAngle = $(Get-Random -Minimum 10 -Maximum 60),

# The number of steps.
[ValidateRange(0,1kb)]
[int]
$StepCount = 0
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


foreach ($n in 1..$stepCount) {
    $this = $this.Petal($radius, $PetalAngle).Rotate($Rotation)
}

return $this