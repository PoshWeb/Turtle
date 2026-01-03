<#
.SYNOPSIS
    Moves backwards
.DESCRIPTION
    Moves the turtle backwards by a specified distance.
.EXAMPLE
    turtle id 'tshape' forward 10 backward 5 rotate 90 forward 20    
#>
param(
# The distance to move backwards
[double]
$Distance = (Get-Random -Min 10 -Max 100)
)

$this.Forward($Distance * -1)
