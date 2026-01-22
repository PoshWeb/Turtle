<#
.SYNOPSIS
    Arcs the turtle to the right
.DESCRIPTION
    Arcs the turtle to the right (clockwise) a number of degrees.

    For each degree, the turtle will move forward and rotate.
.NOTES
    The amount moved forward will be the portion of the circumference.
#>
param(
# The radius of a the circle, were it to complete the arc.
[double]
$Radius = (Get-Random -Min 42 -Max 84),

# The angle of the arc
[double]
$Angle = (Get-Random -Min 30 -Max 90),

# The number of steps.  If not provided, will default to half of the angle.
[int]
$StepCount
)

# Determine the absolute angle, for this operation
$absAngle = [Math]::Abs($angle)

if ($absAngle -eq 0) { return $this }

# Determine the circumference of a circle of this radius
$Circumference = ((2 * $Radius) * [Math]::PI)

# The circumference step is the circumference times 
# the number of revolutions
$revolutionCount = $angle/360
# divided by the angle
$CircumferenceStep = ($Circumference * $revolutionCount) / $Angle

# The iteration is as close to one or negative one as possible
$iteration  = $angle / [Math]::Floor($absAngle)

# If we have no step count
if (-not $StepCount) {
    # default to half of the angle.
    $StepCount = [Math]::Round($absAngle / 2)
}
# Turn this into a ratio (by default, this ratio would be `2`).
$stepSize = $absAngle / $StepCount

# Starting at zero, keep turning until we have reached the number.
# Increase our angle by iteration * stepSize each time.
for ($angleDelta = 0; [Math]::Abs($angleDelta) -lt $absAngle; $angleDelta+=($iteration*$stepSize)) {    
    $this = $this. # In each step, 
        Forward($CircumferenceStep*$StepSize). # move forward a fraction of the circumference,
        Rotate($iteration*$StepSize) # and rotate a fraction of the total angle.
}

# When we are done, return $this so we never break the chain.
return $this