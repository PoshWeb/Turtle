<#
.SYNOPSIS
    Draws a vertical line
.DESCRIPTION
    Draws a vertical line.  
    
    The heading will not be changed.
.EXAMPLE
    turtle VerticalLine 42
.EXAMPLE
    turtle VerticalLine 42 pathdata
#>
param(
# The length of the line.
[double]
$Distance = $(Get-Random -Min 1 -Max 100)
)

$instruction = 
    if ($this.IsPenDown) {
        "v $Distance"
    } else {
        "m 0 $($this.Position.Y + $Distance)"
    }
$this.Position = 0, $Distance
$this.Steps.Add($instruction)
return $this