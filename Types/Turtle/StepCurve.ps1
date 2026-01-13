<#
.SYNOPSIS
    Takes a curved step 
.DESCRIPTION
    Makes a relative movement with a curve.
.EXAMPLE
    turtle viewbox 20 teleport 10 0 stepCurve 5 5 stepCurve -5 0 stepCurve 0 -5 closepath
#>
param(
# The DeltaX
[double]$DeltaX = $(Get-Random -Min -100.0 -Max 100.0), 
# The DeltaY
[double]$DeltaY = $(Get-Random -Min -100.0 -Max 100.0)
)

# If both coordinates are empty, we aren't going anywhere.
# But we _might_ want a point to exist.
$this.Position = $DeltaX, $DeltaY
if ($This.IsPenDown) {
    $this.Steps.Add(" t $deltaX $deltaY")
} else {
    $this.Steps.Add(" m $DeltaX $DeltaY")
}

return $this
