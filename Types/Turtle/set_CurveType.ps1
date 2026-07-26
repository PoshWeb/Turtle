<#
.SYNOPSIS
    Sets a Turtle's Curvature
.DESCRIPTION
    Sets the curvature of the steps.

    If no curvature is set, the turtle will draw straight lines.
    
    If a curvature is set, the turtle will draw cubic bezier curves.

    A curvature set to zero will draw what looks like a straight line.
.LINK
    Turtle.StepCurve
#>
param(
# The type of curve.
# To clear this value, pass a blank.
[ValidateSet(
    's', 'SimpleCurve',
    'q', 'QuadraticCurve',
    'c', 'CubicCurve',
    'l', 'LineCurve',
    't', 'ToCurve',
    ''
)]
[string]$CurveType = ''
)

if ($CurveType) {
    $this | Add-Member NoteProperty '#CurveType' $CurveType -Force
} else {
    $this.psobject.properties.Remove('#CurveType')
}

