<#
.SYNOPSIS
    Draws a Bezier Curve
.DESCRIPTION
    Draws a simple Bezier curve.  
.EXAMPLE
    turtle BezierCurve 0 -100 100 -100 save ./b1.svg
.EXAMPLE
    turtle BezierCurve 0 -100 100 -100 BezierCurve 100 100 100 100 save ./b2.svg
.EXAMPLE    
    turtle @(
        'BezierCurve', 0, -100, 100, -100
        'BezierCurve', 100, 100, 100, 100
        'BezierCurve', 0, 100, -100, 100
    ) save ./b3.svg
.EXAMPLE
    turtle @(
        'BezierCurve', 0, -100, 100, -100
        'BezierCurve', 100, 100, 100, 100
        'BezierCurve', 0, 100, -100, 100
        'BezierCurve', -100, -100, -100, -100        
    ) save ./b4.svg
.LINK
    https://en.wikipedia.org/wiki/B%C3%A9zier_curve
#>
param(
# The X control point
[double]
$ControlX = (Get-Random -Max 42),

# The Y control point
[double]
$ControlY = (Get-Random -Max 42),

# The delta X
[double]
$DeltaX = (Get-Random -Min 0 -Max 100),

# The delta Y
[double]
$DeltaY = (Get-Random -Min 0 -Max 100)
)


if ($DeltaX -or $DeltaY) {
    $this.Position = $DeltaX,$DeltaY
    # If the pen is down
    if ($this.IsPenDown) {
        # draw the curve
        $this.Steps.Add("s $controlX $controlY $deltaX $deltaY")
    } else {        
        # otherwise, move to the deltaX/deltaY
        $this.Steps.Add("m $deltaX $deltaY")
    }
}

return $this

