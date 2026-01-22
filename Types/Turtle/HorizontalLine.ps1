<#
.SYNOPSIS
    Draws a horizontal line
.DESCRIPTION
    Draws a horizontal line.  
    
    The heading will not be changed.
.EXAMPLE
    turtle HorizontalLine 42
.EXAMPLE
    turtle HorizontalLine 42 pathdata
#>
param(
[double]
$Distance = (Get-Random -Min 1 -Max 100)
)

$instruction = 
    if ($this.IsPenDown) {
        "h $Distance"
    } else {
        "m $($this.Position.X + $Distance) 0"
    }
$this.Position = $Distance,0
$this.Steps.Add($instruction)
return $this