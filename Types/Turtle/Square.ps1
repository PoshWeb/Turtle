<#
.SYNOPSIS
    Draws a square
.DESCRIPTION
    Draws a square using Turtle graphics
.EXAMPLE
    turtle square 42    
#>
param(
[double]$Size = $(Get-Random -Min 21 -Max 42)
)
$null = foreach ($n in 1..4) {
    $this.Forward($Size)
    $this.Rotate(90)
}
return $this