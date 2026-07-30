<#
.SYNOPSIS
    Curvy Fractals
.DESCRIPTION
    Creates a page comparing curvy fractals.
#>
param(
[Collections.IDictionary]
$Fractals = $(
    [Ordered]@{
        'Binary Tree' = 'BinaryTree', 42, 3
        # 'Board Fractal' = 'BoardFractal', 42, 3
        'Box Fractal' = 'BoxFractal', 42, 3
        'Crystal Fractal' = 'CrystalFractal', 42, 3
        # 'Hilbert Curve' = 'HilbertCurve', 42, 3
        # 'Koch Island' = 'KochIsland', 42, 3
        'Krishna Anklets' = 'KrishnaAnklets', 42, 3
        'Koch Snowflake' = 'KochSnowflake', 42, 3
        'Pentaplexity' = 'Pentaplexity', 42, 3
        # 'Moore Curve' = 'MooreCurve', 42, 3
        # 'Ring Fractal' = 'RingFractal', 42, 3
        'Sierpinski Triangle' = 'SierpińskiTriangle', 42, 3
        'Sierpinski Curve' = 'rotate', -45, 'SierpińskiCurve', 42, 3
        'Sierpinski Square Curve' = 'SierpińskiSquareCurve', 42, 3, 'SierpińskiSquareCurve', -42, 3
    }
),

[switch]
$PassThru
)


$mySelf = $MyInvocation.MyCommand

$style = 🐢 style ([Ordered]@{    
    '.demogrid' = ([Ordered]@{
        'display' = 'grid'
        'place-items' = 'center'
        'grid-template-columns' = '1fr 1fr 1fr 1fr'        
        'margin' = '1rem'
        'padding' = '1rem'
    })
})


$drawFractals = {
    $progress = @{
        id= Get-Random
        activity='Generating Curvy Fractals'
    }
    
    $counter = 0
    foreach ($fractalName in $fractals.Keys) {
        $counter++        
        $progress.PercentComplete = $counter * 100 / $fractals.Count
        $progress.Status = $fractalName
        Write-Progress @progress
        $fractalId = $fractalName -replace '\s','-'

        $moves = @($fractals[$fractalName])


        🐢 markdown @"
## $fractalName

<div class='demogrid'>
<section>
<h3>$FractalName</h3>
$(
    turtle id "$fractalId-normal" @moves
)
</section>

$(
    foreach ($curveType in 'Simple', 'Quadratic', 'Cubic') {

"
<section>
<h3>$curveType</h3>
$(
    $curve1 = turtle curvature 1 curvetype "${curveType}Curve" id "$fractalId-simple" @moves
    $curve2 = turtle curvature -1 curvetype "${curveType}Curve" id "$fractalId-simple-1" @moves    
)

$(turtle id "$fractalId-$CurveType-morph" @moves morph @(
    $curve1
    $curve2
    $curve1
))
</section>
"        
    }
)

</div>
"@ 

    }
    $progress.Remove('PercentComplete')
    $progress.Completed = $true
    Write-Progress @progress
}

$article = 🐢 markdown @"
# Curvy Fractals

Our Turtle is pretty crafty.  It can also be pretty curvy.

We can tell our turtle to curve each straight line it would draw by using `Curvature`.

$(. $drawFractals)


Here is the source code:

~~~PowerShell
$drawFractals
~~~
"@


🐢 element @"
<html lang='en'>
    <head>
        <meta charset='utf-8' />
        <title>Curvy Fractals</title>
        $style
    </head>
    <body>
    $article
    </body>
</html>
"@ | Save-Turtle ./CurvyFractals.html
