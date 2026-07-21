<#
.SYNOPSIS
    Gets the Turtle width
.DESCRIPTION
    Gets the Turtle's ViewBox width.
.NOTES
    If this has not been set, it will be automatically computed from the distance between the minimum and maximum.
.EXAMPLE
    turtle forward 100 width
#>
if ($this.'.ViewBox') { 
    return @($this.'.ViewBox')[-2]
}

$viewX = $this.Maximum.X + ($this.Minimum.X * -1)

if (-not $viewX -and $this.Turtles) {
    $Max = 0 
    foreach ($turtle in $this.Turtles.Values) {
        if ($turtle.Width -gt $max) {
            $max = $turtle.Width
        }
    }
    return $max
} else {
    return $viewX
}

return $viewX


