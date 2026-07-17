<#
.SYNOPSIS
    Draws a Rose.
.DESCRIPTION
    Draws a Rose in Turtle graphics.
.LINK
    https://en.wikipedia.org/wiki/Rose_(mathematics)
.EXAMPLE
    # We can draw a rose with a radius and a frequency
    Turtle rose 42 2
.EXAMPLE    
    Turtle rose 42 3
.EXAMPLE
    Turtle rose 42 4
.EXAMPLE
    Turtle rose 42 5
.EXAMPLE
    Turtle rose 42 6   
.EXAMPLE
    # We can provide a step count for higher resolution
    Turtle rose 42 7 1 360
.EXAMPLE
    Turtle rose 42 8 1 360
.EXAMPLE
    # We can provide an extent to make multiple revolutions
    Turtle rose 42 (1/4) 4 360
.EXAMPLE
    # We can experiment with different ratios between frequency and extent
    Turtle rose 42 (6/8) 1 720
.EXAMPLE
    Turtle rose 42 (2/3) 3 720
.EXAMPLE
    Turtle rose 42 (2/3) 3 720 morph @(
        Turtle rose 42 (1/3) 3 720
        Turtle rose 42 (2/3) 3 720
        Turtle rose 42 (1/3) 3 720
    )
.EXAMPLE
    Turtle rose 42 (1/5) 720 5 morph @(
        Turtle rose 42 (1/5) 5 720
        Turtle rose 42 (2/5) 5 720
        Turtle rose 42 (3/5) 5 720
        Turtle rose 42 (4/5) 5 720
        Turtle rose 42 (1/5) 5 720
    )
.EXAMPLE
    Turtle rose 42 (1/6) 720 5 morph @(
        Turtle rose 42 (1/6) 6 720 
        Turtle rose 42 (3/6) 6 720
        Turtle rose 42 (1/6) 6 720
    )
.EXAMPLE
    # Any roses with an equal number of steps should morph
    turtle Rose 100 2 1 180 morph @(
        turtle Rose 100 2 1 180
        turtle Rose 100 4 1 180
        turtle Rose 100 2 1 180
    )
.EXAMPLE
    # As we reduce the number of steps, the rose gets more pointed.
    turtle Rose 100 2 1 90 morph @(
        turtle Rose 100 2 1 90
        turtle Rose 100 4 1 90
        turtle Rose 100 2 1 90
    )
.EXAMPLE    
    turtle Rose 100 2 45 morph @(
        turtle Rose 100 2 1 45
        turtle Rose 100 4 1 45
        turtle Rose 100 2 1 45
    )
.EXAMPLE    
    turtle Rose 100 2 24 morph @(
        turtle Rose 100 2 1 24
        turtle Rose 100 4 1 24
        turtle Rose 100 2 1 24
    )
.EXAMPLE
    turtle Rose 100 2 16 morph @(
        turtle Rose 100 2 1 16
        turtle Rose 100 4 1 16
        turtle Rose 100 2 1 16
    )
.EXAMPLE
    turtle Rose 100 2 12 morph @(
        turtle Rose 100 2 1 12
        turtle Rose 100 4 1 12
        turtle Rose 100 2 1 12
    )
.EXAMPLE
    turtle Rose 100 2 8 morph @(
        turtle Rose 100 2 1 8
        turtle Rose 100 4 1 8
        turtle Rose 100 2 1 8
    )
.EXAMPLE
    turtle Rose 100 2 4 morph @(
        turtle Rose 100 2 1 4
        turtle Rose 100 4 1 4
        turtle Rose 100 2 1 4
    )
.EXAMPLE
    # We can morph between multiple roses
    # This shows a circle turning into roses with a frequency of 2 
    turtle PolarEquation 100 { $Radius } @{} 90 morph @(
        turtle PolarEquation 100 { $Radius } @{} 90
        turtle Rose 100 2 1 90
        turtle Rose 100 4 1 90
        turtle Rose 100 6 1 90
        turtle Rose 100 8 1 90
        turtle Rose 100 6 1 90
        turtle Rose 100 4 1 90
        turtle Rose 100 2 1 90
        turtle PolarEquation 100 { $Radius } @{} 90
    )
.EXAMPLE
    turtle repeat 4 [ rotate 90 rose 4.2 2 ] 
.EXAMPLE
    turtle repeat 8 [ rotate 45 rose 4.2 4 ] 
.EXAMPLE
    turtle repeat 4 [ rotate 90 rose 4.2 2 ] morph @(
        turtle repeat 4 [ rotate 90 rose 4.2 2 ]
        turtle repeat 4 [ rotate 90 rose -4.2 4 ]
        turtle repeat 4 [ rotate 90 rose 4.2 2  ]        
    )
.EXAMPLE
    turtle repeat 4 [ rotate 90 rose 4.2 2 ] morph @(
        turtle repeat 4 [ rotate 90 rose 4.2 2 ]
        turtle repeat 4 [ rotate 90 rose 4.2 -4 ]
        turtle repeat 4 [ rotate 90 rose 4.2 2 ]
    )
.EXAMPLE
    turtle repeat 3 [ 120 rose 4.2 3 ] morph @(
        turtle repeat 3 [ rotate 120 rose 4.2 3  ]
        turtle repeat 3 [ rotate 120 rose -4.2 3 ]
        turtle repeat 3 [ rotate 120 rose 4.2 3 ]
    )
#>
param(
# The radius of the rose
[double]
$Radius = $(Get-Random -Minimum 23 -Maximum 42),

# The frequency of the rose
[double]
$Frequency = $(Get-Random -Min 2 -Max 8),

# The extent of the rose (or the number of revolutions)
[Alias('Revolutions','RevolutionCount')]
[double]
$Extent = 1.0,

# The number of steps to draw.  By default, 180.
# Using a smaller number of steps will make sharper looking edges.
[int]
$StepCount = 180
)

$turtle = if ($this) { $this } else { turtle }

return $turtle.PolarEquation($radius, {
    $Radius * [Math]::Cos($Frequency * $Angle * ([Math]::PI / 180))
}, @{Frequency=$Frequency}, $StepCount, $extent)