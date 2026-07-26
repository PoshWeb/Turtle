<#
.SYNOPSIS
    Takes a curved step 
.DESCRIPTION
    Makes a relative movement with a curve.
.EXAMPLE
    turtle viewbox 20 teleport 10 0 stepCurve 5 5 stepCurve -5 0 stepCurve 0 -5
.EXAMPLE
    turtle stepCurve 1 1 0.5 simpleCurve stepcurve -1 1 0.5 simpleCurve stepcurve -1 -1 0.9 simpleCurve stepcurve 1 -1 0.9 simpleCurve pathdata
.EXAMPLE
    turtle stepCurve 1 1 0.5 [q] stepcurve -1 1 0.5 [q] stepcurve -1 -1 0.5 [q] stepcurve 1 -1 0.5 [q] 
.EXAMPLE
    turtle stepCurve 1 1 0.9 [c] stepcurve -1 1 0.9 [c] stepcurve -1 -1 0.9 [c] stepcurve 1 -1 0.9 [c] 
.EXAMPLE
    turtle stepCurve 1 1 0.5 [s] stepcurve -1 1 0.9 [s] stepcurve -1 -1 0.9 [s] stepcurve 1 -1 0.9 [s] 
#>
param(
# The DeltaX
[double]$DeltaX = $(Get-Random -Min -10.0 -Max 10.0), 
# The DeltaY
[double]$DeltaY = $(Get-Random -Min -10.0 -Max 10.0),

# The curvature.
# If a value is provided, will curve between two points.
# If no curvature is provided,
# StepCurve will use the continue curve `t` instruction to curve
[object]$Curvature,

# The type of curve
[ValidateSet(
    's', 'SimpleCurve',
    'q', 'QuadraticCurve',
    'c', 'CubicCurve',
    'l', 'LineCurve',
    't', 'ToCurve'
)]
[string]$CurveType = $(
    if ($this.'CurveType') {
        $this.'CurveType'
    } else {
        's'
    }
)
)

# -curve*nx+x/2, -curve*ny+y/2, curve*nx+x/2, curve*ny+y/2, x, y

# If both coordinates are empty, we aren't going anywhere.
# But we _might_ want a point to exist.
$this.Position = $DeltaX, $DeltaY

if ($This.IsPenDown) {
    # If no curvature was provided
    # and the Turtle wants to be curved.
    if ($null -eq $Curvature -and $this.'#Curvature') {
        # use the Turtle's curvature
        $curvature = $this.'#Curvature'
    }            

    # If we have a curvature
    if ($null -ne $Curvature -as [double]) {
        # Then let's do some math
        $curve = $Curvature -as [double]
                
        # Reflected point
        $nx, $ny = $DeltaY, ($DeltaX * -1)
        # Negative curve 
        $nc = ($curve * -1)

        # We can use our CurveType to draw the curve

        $curveStep = @(
            switch -Regex ($CurveType) {
                '^c' {
                    # cubic `c` curves need 6 points
                    ($nc*$nx)+$DeltaX/2
                    ($nc*$ny)+$DeltaY/2
                    ($curve*$nx)+$DeltaX/2
                    ($curve*$ny)+$DeltaY/2
                    $DeltaX
                    $DeltaY
                }
                '^[sq]' {
                    # simple and quadratic (`s` and `q`) curves need 4 points
                    ($nc*$nx)+$DeltaX/2
                    ($nc*$ny)+$DeltaY/2
                    $DeltaX
                    $DeltaY
                }
                
                '^[lt]' {
                    # lines and continued curves (`l` and `t`) need 2 steps.
                    $DeltaX
                    $DeltaY
                } 
            }
        )

        # If the switch had no matches 
        $curveStep = if (-not $curveStep) {
            "t $deltaX $deltaY" # default to `t`
        } else {
            # Otherwise,
            @(
                "$($CurveType.Substring(0,1).ToLower())"
                $curveStep
            ) -join ' '        

        }

        
        $this.Steps.Add($curveStep)
    } else {
        $this.Steps.Add("t $DeltaX $DeltaY")
    }
} else {
    $this.Steps.Add("m $DeltaX $DeltaY")
}

return $this
