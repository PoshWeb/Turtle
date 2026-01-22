<#
.SYNOPSIS
    Draws a Rectangle
.DESCRIPTION
    Draws a Rectangle.  
    
    If only one dimension is specified, will draw a golden rectangle.
.EXAMPLE    
    turtle rectangle 42 save ./goldenRectangle.svg
#>
param(
# The width of the rectangle
[double]
$Width = $(Get-Random -Min 42 -Maximum 84),

# The height of the rectangle.  If not provided, will be the width divided by the golden ratio.
[double]
$Height
)

if (-not $Height) {
    $Height = $width/((1 + [Math]::Sqrt(5))/2)
}

$this.
    Forward($width).Rotate(90).
    Forward($Height).Rotate(90).
    Forward($Width).Rotate(90).
    Forward($height).Rotate(90)