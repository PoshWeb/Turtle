<#
.SYNOPSIS
    Draws a Fractal Shrub
.DESCRIPTION
    Draws a Fractal Shrub using an an L-System.

    This is a modification of the fractal plant will less rotation
.LINK
    https://en.wikipedia.org/wiki/L-system#Example_7:_fractal_plant
.EXAMPLE
    turtle FractalShrub 42 1 -25    
.EXAMPLE
    turtle FractalShrub 42 2 -25    
.EXAMPLE    
    turtle FractalShrub 42 3 -25    
.EXAMPLE    
    turtle FractalShrub 42 4 -25
.EXAMPLE
    turtle FractalShrub 42 4 -25
.EXAMPLE
    turtle FractalShrub 42 4
#>  
param(    
    # The size of each segment
    [double]$Size = (Get-Random -Min 42 -Max 84),
    # The order of magnitude (the number of times the L-system is expanded)
    [int]$Order = (3,4,5 | Get-Random),
    # The angle of each segment
    [double]$Angle = (Get-Random -Min -35 -Max -25)
)
return $this.Rotate(-90).LSystem('-X',  [Ordered]@{
    'X' = 'F[[X]X]F[FX]X'
    'F' = 'FF'
}, $Order, [Ordered]@{
    'F'  = { $this.Forward($Size) }
    #'\+' = { $this.Rotate($angle)}
    # '\-' = { $this.Rotate($angle * -1)}
    '\[' = { $this.Push().Rotate($angle) }
    '\]' = { $this.Pop().Rotate($angle * -1) }
})