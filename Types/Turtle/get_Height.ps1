<#
.SYNOPSIS
    Gets the Turtle height
.DESCRIPTION
    Gets the Turtle's ViewBox height.
.NOTES
    If this has not been set, it will be automatically computed from the distance between the minimum and maximum.
.EXAMPLE
    turtle rotate 90 forward 100 width
#>
param()
if ($this.'.ViewBox') { 
    return @($this.'.ViewBox')[-1]
}

$viewY = $this.Maximum.Y + ($this.Minimum.Y * -1)

if (-not $viewY -and $this.Turtles) {
    $Max = 0 
    foreach ($turtle in $this.Turtles.Values) {
        if ($turtle.Height -gt $max) {
            $max = $turtle.Height
        }
    }
    return $max
} else {
    return $viewY
}