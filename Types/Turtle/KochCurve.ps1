<#
.SYNOPSIS
    Draws a Koch Curve
.DESCRIPTION
    Draws a Koch Curve, using an L-System.
#>
param(
    [double]$Size = (Get-Random -Min 21 -Max 42),
    [int]$Order = (2,3,4 | Get-Random),
    [double]$Rotation = 90    
)    
return $this.LSystem('F',  @{
    F = 'F+F-F-F+F'
}, $Order, [Ordered]@{
    '\+' = { $this.Rotate($Rotation) }
    'F' =  { $this.Forward($Size) }    
    '\-' = { $this.Rotate($Rotation * -1) }
})