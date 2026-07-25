<#
.SYNOPSIS
    Sets a Turtle's Curvature
.DESCRIPTION
    Sets the curvature of the steps.

    If no curvature is set, the turtle will draw straight lines.
    
    If a curvature is set, the turtle will draw cubic bezier curves.

    A curvature set to zero will draw what looks like a straight line
.LINK
    Turtle.StepCurve
#>
param([double]$Curve)

$this | Add-Member NoteProperty '#Curvature' $Curve -Force
