<#
.SYNOPSIS
    Draws a step spiral
.DESCRIPTION
    Draws a spiral as a series of steps.

    Each step will draw a line, rotate, and increment the length of the next step.

    By default, this creates an outward spiral.

    To create an inward spiral, use a negative StepSize or StepCount.
.EXAMPLE
    turtle StepSpiral 1 90 2 20 save ./StepSpiral.svg
.EXAMPLE
    turtle @('StepSpiral',3, 120, 'rotate',120 * 3) save ./StepSpiralx3.svg
.EXAMPLE
    turtle @('StepSpiral',3, 90, 'rotate',90 * 4) save ./StepSpiralx4.svg
.EXAMPLE
    turtle @('StepSpiral',3, -6, 0, (360/6 * 2), 'rotate',30 * (360/6))
.EXAMPLE
    turtle @('StepSpiral',3, -60, 0, (360/60 * 2), 'rotate',60 * (360/60)) morph @(
        turtle @('StepSpiral',3, -60, 0, (360/60 * 2), 'rotate',60 * (360/60))
        turtle @('StepSpiral',2, 60, 0, (360/60 * 2), 'rotate',60 * (360/60))
        turtle @('StepSpiral',3, -60, 0, (360/60 * 2), 'rotate',60 * (360/60))
    ) save ./StepSpiralSmoothMorph.svg
.EXAMPLE
    turtle @('StepSpiral',3, -6, 0, (360/6 * 2), 'rotate',30 * (360/6)) morph @(
        turtle @('StepSpiral',3, -6, 0, (360/6 * 2), 'rotate',30 * (360/6))
        turtle @('StepSpiral',3, 6, 0, (360/6 * 2), 'rotate',30 * (360/6))
        turtle @('StepSpiral',3, -6, 0, (360/6 * 2), 'rotate',30 * (360/6))
    ) save ./StepSpiralSmoothMorph.svg
#>
param(
# The length of the first step
[double]$Length = $(Get-Random -Min 1.0 -Max 2.0),
# The angle to rotate after each step
[double]$Angle = $(
    @(
        foreach ($n in 3..24) {
            if ([Math]::Floor(360/$n) -eq (360/$n)) {
                360/$n
            }
        }
    ) | Get-Random
),
# The amount of change per step
[double]$StepSize = 0,
# The number of steps.
[int]$StepCount = 0
)

if ($Rotation -eq 0) { return $this }

if (-not $StepSize) {
    $StepSize = $Length * 2
}

# If no step count was provided
if ($StepCount -eq 0) {
    # we want to use a fixed number of steps
    # and figure out how many steps at our angle it takes to get there.
    $revolutions = 4
    $StepCount = [Math]::Ceiling(($revolutions*360)/$angle)
}

# If the step size or count is negative
if (
    ($stepSize -lt 0 -or $stepCount -lt 0) -and
    $Length -in 0,1 # and the length is either the default or zero
) {
    # set the length to the correct maximim step size, so we can make an inward spiral.
    $Length = ([Math]::Abs($stepSize) * [Math]::Abs($stepCount))
} 
elseif ($length -eq 0) {
    # If the length is empty, default it to the step size
    $Length = $StepSize
}

# Perform the appropriate steps
foreach ($n in 1..([Math]::Abs($StepCount))) {
    $this = $this.Forward($length).Rotate($angle)
    $length += $stepSize    
}
# and return ourself.
return $this

