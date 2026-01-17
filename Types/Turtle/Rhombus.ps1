<#
.SYNOPSIS
    Draws a Rhombus
.DESCRIPTION
    Draws a Rhombus in Turtle Graphics.
.NOTES
    If you provide `NaN` or positive infinity `∞`, you'll get rhombus with a golden angle.

    If you provide negative infinity `-∞`, you'll get a rhombus with a different golden angle.
.LINK
    https://logothings.github.io/logothings/logo/SquashedSquares.html
.EXAMPLE
    # Draw a random rhombus
    turtle rhombus 
.EXAMPLE
    # Draw a 10 20 30 rhombus
    turtle rhombus 10 20 30
.EXAMPLE
    # More a 10 20 30 rhombus to a 10 20 90 rhombus
    turtle rhombus 10 20 30 morph @(
        turtle rhombus 10 20 30
        turtle rhombus 20 10 90
        turtle rhombus 10 20 30
    )
.EXAMPLE
    turtle rhombus 20 20 90 morph @(
        turtle rhombus 20 20 90
        turtle rhombus 20 10 30
        turtle rhombus 20 20 90
        turtle rhombus 10 20 -30
        turtle rhombus 20 20 90
    )
.EXAMPLE
    # If we pass nan for an angle, 
    # we use 1/the golden ratio as the angle
    turtle rhombus 10 20 nan
.EXAMPLE    
    turtle rhombus 10 20 nan morph @(
        turtle rhombus 10 20 nan
        turtle rhombus -20 -10 nan
        turtle rhombus 10 20 nan
    )
#>
param(
# The length of the first side
[double]
$Side1 = (Get-Random -Min 42 -Max 84),

# The length of the second side
[double]
$Side2 = (Get-Random -Min 42 -Max 84),

# The angle to rotate after the first and third side.
# The second and third side will be 180 - this angle.
# If 'NaN' is provided, the reciprocol of the golden ratio will be used as the angle.
[double]
$Angle = $(
    (Get-Random -Min 10.0 -Max 60.0) * 
        (1,-1 | Get-Random) * 
            (1, 1, [double]::NaN | Get-Random)
)
)

if ("$angle" -eq "NaN" -or 
    "$angle" -eq "$([double]::PositiveInfinity)") {    
    $angle = 
        [Math]::Atan(1 / (1 + [Math]::Sqrt(5))) * 2 * 180/[Math]::Pi
} elseif ($angle -eq "$([double]::NegativeInfinity)") {
    $angle = 
        [Math]::Atan((1 + [Math]::Sqrt(5))) * 2 * 180/[Math]::Pi
}

$this.
    Forward($Side1).Rotate($Angle).
    Forward($Side2).Rotate(180-$Angle).
    Forward($side1).Rotate($Angle).
    Forward($side2).Rotate(180-$Angle)