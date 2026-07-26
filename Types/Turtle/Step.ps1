<#
.SYNOPSIS
    Takes a Step 
.DESCRIPTION
    Makes a relative movement.
.EXAMPLE
    turtle step 5 5 step 0 -5 step -5 0 save ./stepTriangle.svg
#>
param(
# The DeltaX
[double]$DeltaX = 0, 
# The DeltaY
[double]$DeltaY = 0,

# The curvature of the step.
# By default, not a number (no curve).
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

# If no curvature was provided, check the object
if (
    ($null -eq $Curvature) -and 
    ($null -ne $this.'#Curvature')
) {
    # and use any value we have set.
    $Curvature = $this.'#Curvature'
}

# If we want to draw a curvy turtle
if ($null -ne $Curvature -and (
    $null -ne ($Curvature -as [double])
)) {
    $stepCurve = @(
        $DeltaX
        $DeltaY
        $Curvature
        if ($CurveType) {
            $CurveType
        }
    )
    
    # call step curve and return
    return $this.StepCurve.Invoke($stepCurve)
}

# If both coordinates are empty, there is no step
if ($DeltaX -or $DeltaY) {
    $this.Position = $DeltaX, $DeltaY
    if ($This.IsPenDown) {
        $this.Steps.Add(" l $DeltaX $DeltaY")
    } else {
        $this.Steps.Add(" m $DeltaX $DeltaY")
    }
}

return $this
