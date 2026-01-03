
<#
.SYNOPSIS
    Draws a Cubic Bezier Curve
.DESCRIPTION
    Draws a Cubic Bezier curve.

    Cubic Bezier curves take three points:

    * A Start Control Point
    * An End Control Point
    * An End Point

    A line will be drawn from the current position to the end point,
    curved towards both the start and control point.
.EXAMPLE
    turtle @(
        'CubicBezierCurve',
            200,0,  # Start Control Point 
            0,200,  # End Control Point
            200,200 # End Point        
    ) save ./cubic.svg
.EXAMPLE
    turtle width 200 height 200 morph @(
        turtle 'CubicBezierCurve',
            200,0,  # Start Control Point 
            0,200,  # End Control Point
            200,200 # End Point
            
        turtle 'CubicBezierCurve',
            0,200,  # Start Control Point 
            200,0,  # End Control Point
            200,200 # End Point
        turtle 'CubicBezierCurve',
            200,0,  # Start Control Point 
            0,200,  # End Control Point
            200,200 # End Point
    ) save ./CubicMorph.svg
.EXAMPLE
    turtle width 200 height 200 morph @(
        turtle 'CubicBezierCurve',
            200,0,    # Start Control Point 
            0,200,    # End Control Point
            200,200   # End Point
            
        turtle 'CubicBezierCurve',
            0,200,    # Start Control Point 
            200,0,    # End Control Point
            200,200   # End Point

        turtle 'CubicBezierCurve',
            200,200,  # Start Control Point 
            200,0,    # End Control Point
            200,200   # End Point
        
        turtle 'CubicBezierCurve',
            0,200,    # Start Control Point 
            0,200,    # End Control Point
            200,200   # End Point

        turtle 'CubicBezierCurve',
            400,0,    # Start Control Point 
            0,200,    # End Control Point
            200,200   # End Point

        turtle 'CubicBezierCurve',
            0,200,      # Start Control Point 
            200,0,      # End Control Point
            200,200   # End Point

        turtle 'CubicBezierCurve',
            400,0,    # Start Control Point 
            0,400,    # End Control Point
            200,200   # End Point

        turtle 'CubicBezierCurve',
            0,200,      # Start Control Point 
            200,0,      # End Control Point
            200,200   # End Point        

        turtle 'CubicBezierCurve',
            200,0,   # Start Control Point 
            0,200,   # End Control Point
            200,200  # End Point
    ) save ./MoreCubicMorphs.svg
.EXAMPLE
    # Cubic Bezier Curves are Aliased to 'c'
    turtle c 0 200 200 0 200 200 
.EXAMPLE
    turtle c 0 200 200 0 200 200 morph @(
        turtle c 0   0 0   0 200 200 
        turtle c 0 200 200 0 200 200 
        turtle c 0   0 0   0 200 200
        turtle c 200 0 0 200 200 200
        turtle c 0   0 0   0 200 200 
    ) save ./cmorph.svg
.EXAMPLE    
    turtle teleport 200 0 c 0 0 0 0 -200 200 morph @(
        turtle c 0   0 0   0 -200 200 
        turtle c 0 200 -200 0 -200 200 
        turtle c 0   0 0   0 -200 200
        turtle c -200 0 0 200 -200 200
        turtle c 0   0 0   0 -200 200 
    ) save ./cmorph2.svg
.EXAMPLE
    turtle backgroundcolor '#000000' width 200 height 200 turtles @(
        turtle width 200 height 200 morph @(
            turtle c 0   0 0   0 200 200 
            turtle c 0 200 200 0 200 200 
            turtle c 0   0 0   0 200 200
            turtle c 200 0 0 200 200 200
            turtle c 0   0 0   0 200 200 
        ) fill '#4488ff' stroke '#224488'
        turtle width 200 height 200 teleport 200 morph @(
            turtle c 0    0 0    0 -200 200 
            turtle c 0  200 -200 0 -200 200 
            turtle c 0    0 0    0 -200 200
            turtle c -200 0 0  200 -200 200
            turtle c 0    0 0    0 -200 200 
        ) stroke '#4488ff' fill '#224488'
    ) save ./cmorph3.svg
.EXAMPLE
    turtle backgroundcolor '#000000' width 200 height 200 turtles @(
        turtle width 200 height 200 morph @(
            turtle teleport 100 0 c 0 0 0 0 0 200
            turtle teleport 100 0 c -100 0 100 200 0 200
            turtle teleport 100 0 c 0 0 0 0 0 200
        ) fill '#4488ff' stroke '#224488'
        turtle width 200 height 200 teleport 200 morph @(
            turtle teleport 0 100 c 0 0 0 0 200 0
            turtle teleport 0 100 c 0 -100 200 100 200 0
            turtle teleport 0 100 c 0 0 0 0 200 0
        ) stroke '#4488ff' fill '#224488'
    ) save ./cmorph4.svg
.EXAMPLE
    turtle backgroundcolor '#000000' width 200 height 200 turtles @(
    turtle width 200 height 200 morph @(
            turtle c 0   0 0   0 200 200 
            turtle c 0 200 200 0 200 200 
            turtle c 0   0 0   0 200 200
            turtle c 200 0 0 200 200 200
            turtle c 0   0 0   0 200 200 
        ) fill '#4488ff' stroke '#224488'
        turtle width 200 height 200 teleport 200 morph @(
            turtle c 0    0 0    0 -200 200 
            turtle c 0  200 -200 0 -200 200 
            turtle c 0    0 0    0 -200 200
            turtle c -200 0 0  200 -200 200
            turtle c 0    0 0    0 -200 200 
        ) stroke '#4488ff' fill '#224488'
        turtle width 200 height 200 morph @(
            turtle teleport 100 0 c 0 0 0 0 0 200
            turtle teleport 100 0 c -100 0 100 200 0 200
            turtle teleport 100 0 c 0 0 0 0 0 200
        ) fill '#4488ff' stroke '#224488'
        turtle width 200 height 200 teleport 200 morph @(
            turtle teleport 0 100 c 0 0 0 0 200 0
            turtle teleport 0 100 c 0 -100 200 100 200 0
            turtle teleport 0 100 c 0 0 0 0 200 0
        ) stroke '#4488ff' fill '#224488'
    ) save ./cmorph5.svg
.EXAMPLE
    turtle backgroundcolor '#000000' width 200 height 200 turtles @(
        $r = @(foreach ($n in 1..4) { Get-Random -Min 0 -Max 200})
        turtle width 200 height 200 morph @(
            turtle teleport 100 0 c 0 0 0 0 0 200
            turtle teleport 100 0 c $r $r $r $r 0 200
            turtle teleport 100 0 c 0 0 0 0 0 200
        ) fill '#4488ff' stroke '#224488'
        turtle width 200 height 200 teleport 200 morph @(
            turtle teleport 0 100 c 0 0 0 0 200 0
            turtle teleport 0 100 c $r $r $r $r 200 0
            turtle teleport 0 100 c 0 0 0 0 200 0
        ) stroke '#4488ff' fill '#224488'
    ) save ./cmorphrandom.svg
.NOTES
    This corresponds to the `c` element in an SVG Path
.LINK
    https://developer.mozilla.org/en-US/docs/Web/SVG/Tutorials/SVG_from_scratch/Paths#b%C3%A9zier_curves
.LINK
    https://en.wikipedia.org/wiki/B%C3%A9zier_curve
#>
param(
# The X control point
[double]
$ControlStartX = $(Get-Random -Min -100 -Max 100),

# The Y control point
[double]
$ControlStartY = $(Get-Random -Min -100 -Max 100),

# The X control point
[double]
$ControlEndX = $(Get-Random -Min -100 -Max 100),

# The Y control point
[double]
$ControlEndY = $(Get-Random -Min -100 -Max 100),

# The delta X
[double]
$DeltaX = $(Get-Random -Min -100 -Max 100),

# The delta Y
[double]
$DeltaY = $(Get-Random -Min -100 -Max 100)
)

if ($DeltaX -or $DeltaY) {
    $this.Position = $DeltaX, $DeltaY
    # If the pen is down
    if ($this.IsPenDown) {
        # draw the curve
        $this.Steps.Add("c $ControlStartX $ControlStartY $ControlEndX $ControlEndY $DeltaX $DeltaY")
    } else {        
        # otherwise, move to the deltaX/deltaY
        $this.Steps.Add("m $DeltaX $DeltaY")
    }
}

return $this

