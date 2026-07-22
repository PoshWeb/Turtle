<#
.SYNOPSIS
    Gets the Turtle's viewbox
.DESCRIPTION
    Gets the Turtle's current viewBox.

    If this has not been set, it will be automatically calculated by the minimum and maximum
.NOTES
    turtle square 42 viewbox
#>

param()

# If we have set a viewbox, return it.
if ($this.'.ViewBox') { return $this.'.ViewBox' }

# Otherwise, subtract max from minimum to get a bounding box
$viewBox = ($this.Maximum - $this.Minimum)

$precision = $this.Precision
filter roundToPrecision { [Math]::Round($_, $precision)}

$viewX = [Math]::Round($viewBox.X, $precision)
$viewY = [Math]::Round($viewBox.Y, $precision)

if ($viewX -and -not $viewY) {
    $viewY = $viewX
}
if ($viewY -and -not $viewX) {
    $viewX = $viewY
}

if (
    (-not $viewX -or -not $viewY) -and 
    $this.Turtles
) {
    $MaxX, $MaxY = 0, 0
    foreach ($turtle in $this.Turtles.Values) {
        if ($turtle.Width -gt $MaxX) {
            $MaxX = $turtle.Width
        }
        if ($turtle.Height -gt $MaxY) {
            $MaxY = $turtle.hEIGHT
        }
    }
    if ($MaxX -and -not $viewX) {
        $viewX = [Math]::Round($MaxX)
    }
    if ($MaxY -and -not $viewY) {
        $viewY = [Math]::Round($MaxY)
    }
}

if ($precision) {
    return 0, 0, [Math]::Round($viewX, $precision) , [Math]::Round($viewY, $precision)
} else {
    # and return the viewbox
    return 0, 0, $viewX, $viewY
}



