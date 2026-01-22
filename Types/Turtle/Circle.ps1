<#
.SYNOPSIS
    Draws a circle.
.DESCRIPTION
    Draws a whole or partial circle using turtle graphics.

    That is, it draws a circle by moving the turtle forward and rotating it.

    To draw a semicircle, use an extent of 0.5.

    To draw a quarter circle, use an extent of 0.25.

    To draw a half hexagon, use an extent of 0.5 and step count of 6.
.EXAMPLE
    turtle circle 42 | Save-Turtle ./Circle.svg 
.EXAMPLE
    turtle circle 42 .5 | Save-Turtle ./HalfCircle.svg
.EXAMPLE
    turtle circle 42 .25 | Save-Turtle ./QuarterCircle.svg
.EXAMPLE
    turtle circle 42 | Save-Turtle ./CirclePattern.svg
.EXAMPLE
    turtle start 21 21 circle 42 morph @(
        turtle start 21 21 circle 42
        turtle start 21 21 circle -42
        turtle start 21 21 circle 42
    ) | Save-Turtle ./CircleMorphPattern.svg 
.EXAMPLE
    $turtle = New-Turtle
    $turtle.Circle(10).Pattern.Save("$pwd/CirclePattern.svg")
.EXAMPLE
    turtle circle 42 1 90 morph | 
        Save-Turtle ./CircleConstructionMorph.svg
.EXAMPLE
    turtle forward 42 rotate -90 Circle 21 Circle 21 .5 rotate -90 forward 42 |
        Save-Turtle ./DashDotDash.svg 
.EXAMPLE
    turtle @('forward', 40, 'Circle', 10, .75 * 4) |
        Save-Turtle ./CommandSymbol.svg
.EXAMPLE
    turtle @('forward', 40, 'Circle', 10, .75 * 4) morph |
        Save-Turtle ./CommandSymbolStepMorph.svg
.EXAMPLE
    turtle @('forward', 40, 'Circle', 10, .75 * 4) |
        Save-Turtle ./CommandSymbolPattern.svg
#>
param(
# The radius of the circle
[double]$Radius = $(
    (Get-Random -Min 21 -Max 42) * (1,-1 | Get-Random)
),
# The portion of the circle to draw.
[double]$Extent = 1,
# The number of steps.
# If this is not provided, steps will be automatically determined
# If the the extent is between `1` or `-1` and the angle is a multiple of 90, 
# then the circle will be drawn in up to four steps.
# Otherwise, the step count will default to 180.
[int]$StepCount
)

if (-not $this) { return }
if ($extent -eq 0) { return $this }

# If the step count was not specified, and the `-Extent` is `1` or `-1`,
# we want to draw an optimized path around the circle.
if ((-not $StepCount) -and (
        -not (($extent * 360) % 90)
    ) -and 
    $extent -le 1 -and 
    $extent -ge -1
) {
    # First, we need to know what the center is.
    # Luckily, the center is always a right triangle away
    $headingToCenter = $this.Heading + 90
    $circleCenter = [Numerics.Vector2]::new(
        $this.X + ($radius * [math]::cos($headingToCenter * [Math]::PI / 180)),
        $this.Y + ($radius * [math]::sin($headingToCenter * [Math]::PI / 180))
    )

    # Once we know the center, we can construct four vectors for each quadrant of the circle
    $circleRight, $circleBottom, $circleLeft, $circleTop = foreach ($n in 0..3) {
        $headingTo = $this.Heading + (90 * $n)
        $circleCenter + [Numerics.Vector2]::new(
            $radius * [math]::cos($headingTo * [Math]::PI / 180),
            $radius * [math]::sin($headingTo * [Math]::PI / 180)
        )
    }
    # and then we can draw up to four relative arcs.    
    # (this ensures a pure circle is smoothly drawn and the bounding box is updated accordingly)
    $updated = switch ($extent * 360) {
        90 {
            $this.
                Arc($radius, $radius, 0, $false, $true,$circleRight.X - $this.X, $circleRight.Y - $this.Y).
                Rotate(90)
        }
        -90 {
            $this.
                Arc($radius, $radius, 0, $false, $false,$circleLeft.X - $this.X, $circleLeft.Y - $this.Y).
                Rotate(-90)
        }
        180 {
            $this.
                Arc($radius, $radius, 0, $false, $true,$circleRight.X - $this.X, $circleRight.Y - $this.Y).
                Arc($radius, $radius, 0, $false, $true,$circleBottom.X - $this.X, $circleBottom.Y - $this.Y).
                Rotate(180)
        }
        -180  {
            $this.
                Arc($radius, $radius, 0, $false, $false,$circleLeft.X - $this.X, $circleLeft.Y - $this.Y).
                Arc($radius, $radius, 0, $false, $false,$circleBottom.X - $this.X, $circleBottom.Y - $this.Y).
                Rotate(-180)
        }
        270 {
            $this.
                Arc($radius, $radius, 0, $false, $true,$circleRight.X - $this.X, $circleRight.Y - $this.Y).
                Arc($radius, $radius, 0, $false, $true,$circleBottom.X - $this.X, $circleBottom.Y - $this.Y).
                Arc($radius, $radius, 0, $false, $true,$circleLeft.X - $this.X, $circleLeft.Y - $this.Y).
                Rotate(270)
        }
        -270 {
            $this.
                Arc($radius, $radius, 0, $false, $false,$circleLeft.X - $this.X, $circleLeft.Y - $this.Y).
                Arc($radius, $radius, 0, $false, $false,$circleBottom.X - $this.X, $circleBottom.Y - $this.Y).
                Arc($radius, $radius, 0, $false, $false,$circleRight.X - $this.X, $circleRight.Y - $this.Y).
                Rotate(-270)
        }
        360 {
            $this.
                Arc($radius, $radius, 0, $false, $true,$circleRight.X - $this.X, $circleRight.Y - $this.Y).
                Arc($radius, $radius, 0, $false, $true,$circleBottom.X - $this.X, $circleBottom.Y - $this.Y).
                Arc($radius, $radius, 0, $false, $true,$circleLeft.X - $this.X, $circleLeft.Y - $this.Y).
                Arc($radius, $radius, 0, $false, $true,$circleTop.X - $this.X, $circleTop.Y - $this.Y)
        }
        -360 {
            $this.
                Arc($radius, $radius, 0, $false, $false,$circleLeft.X - $this.X, $circleLeft.Y - $this.Y).
                Arc($radius, $radius, 0, $false, $false,$circleBottom.X - $this.X, $circleBottom.Y - $this.Y).
                Arc($radius, $radius, 0, $false, $false,$circleRight.X - $this.X, $circleRight.Y - $this.Y).
                Arc($radius, $radius, 0, $false, $false,$circleTop.X - $this.X, $circleTop.Y - $this.Y)
        }
    }

    # If we drew our arcs
    if ($updated) {
        # return the updated turtle
        return $updated
    }
}

# If no step count was specified, default to 180
if (-not $StepCount) { $StepCount = 180 }

# Determine the circumference of the circle
$circumference = 2 * [math]::PI * $Radius
# and divide by the number of steps
$circumferenceStep = $circumference / $StepCount

# Get a multiplier for our extent, so we turn in the right direction
$extentMultiplier = if ($extent -gt 0) { 1 } else { -1 }

$currentExtent = 0
$maxExtent = [math]::Abs($extent)
# determine how much extent each step covers.
$extentStep = 1/$StepCount

# Every step we take
$null = foreach ($n in 1..$StepCount) {
    # we move forward by a portion of the circumference
    $this.Forward($circumferenceStep)
    $currentExtent += $extentStep

    # and we rotate (as long as we would not exceed the extent).
    if ($n -le $StepCount -and $currentExtent -le $maxExtent) {
        $this.Rotate( (360 / $StepCount) * $extentMultiplier)
    }

    if ($currentExtent -gt $maxExtent) {
        break
    }
}
# Once we have taken all of the necessary steps, return this so we never break the chain.
return $this