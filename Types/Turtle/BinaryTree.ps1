<#
.SYNOPSIS
    Draws a binary tree
.DESCRIPTION
    Draws a binary tree using an L-system.      
.LINK
    https://en.wikipedia.org/wiki/L-system#Example_2:_fractal_(binary)_tree
#>
param(
# The size of each segment
[double]$Size = $(Get-Random -Min 21 -Max 42),
# The order of magnitude (the number of times the L-system is expanded)
[int]$Order = (2,3,4,5,6| Get-Random),
# The angle
[double]$Angle = 45
)
return $this.Rotate(-90).LSystem('0',  [Ordered]@{
    '1' = '11'
    '0' = '1[0]0'    
}, $Order, [Ordered]@{
    '[01]'    = { $this.Forward($Size) }
    '\['      = { $this.Push().Rotate($Angle * -1) }
    '\]'      = { $this.Pop().Rotate($Angle) }
})

