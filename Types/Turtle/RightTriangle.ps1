<#
.SYNOPSIS
    Right triangle
.DESCRIPTION
    Draws a right triangle using two side lengths.
.EXAMPLE
    # Draw a random right triangle
    turtle RightTriangle 
.EXAMPLE
    # Draw a 3-4-5 right triangle
    turtle RightTriangle 3 4
.EXAMPLE
    # We can rotate after each right triangle
    turtle @('RightTriangle',1,4,'Rotate', 90 * 4)
.EXAMPLE
    # We can make a parallax by putting with multiple right triangles
    turtle id Parallax @(foreach ($n in 1..10) {
        'RightTriangle',$n,-10
        'RightTriangle',($n*-1),-10
    }) save ./Parallax.svg
.EXAMPLE
    # We can do this along two axes to make a parallax illusion
    turtle @(foreach ($n in 1..10) {
        'RightTriangle',$n,(10)
        'RightTriangle',($n),-10
        'RightTriangle',($n * -1),-10
        'RightTriangle',($n * -1),10
    }) save ./ParallaxIllusion.svg
.EXAMPLE
    # We can create a parallax corner by scaling the triangles
    turtle id ParallaxCorner @(foreach ($n in 1..10) {
        'RightTriangle',(10 - $n),$n
        'RightTriangle',$n,(10-$n)
    }) save ./ParallaxCorner.svg   
.EXAMPLE
    # We can rotate and repeat this to make a Parallax Astroid
    turtle id ParallaxAstroid (@(
        @(foreach ($n in 1..10) {
            'RightTriangle',(10 - $n),$n
            'RightTriangle',$n,(10-$n)    
        })
        'rotate', 90
    ) * 4) save ./ParallaxAstroid.svg
.EXAMPLE
    # We can make a pair of parallax astroids and morph them.
    $parallaxAstroid = turtle id ParallaxAstroid (
        @(
            foreach ($n in 1..10) {
                'RightTriangle',(10 - $n),$n
                'RightTriangle',$n,(10-$n)    
            }
            'rotate', 90  
        ) * 4
    )

    $parallaxAstroid2 = turtle id ParallaxAstroid (
        @(
            foreach ($n in 1..10) {
                'RightTriangle',(10 - $n),($n*-1)
                'RightTriangle',($n*-1),(10-$n)    
            }
            'rotate', 90  
        ) * 4
    )
            
    $parallaxAstroid | turtle morph @(
        $parallaxAstroid
        $parallaxAstroid2
        $parallaxAstroid
    ) @(
        'stroke','#4488ff'
        'fill','#224488'
        'pathclass','foreground-stroke foreground-fill'
        'fillrule','evenodd'
    )
#>
param(
# The distance along the current angle.
[Alias('Opposite')]
[double]
$Side1 = $(
    (Get-Random -Minimum 42 -Maximum 84) * (1,-1 | Get-Random)
),

# The distance along the adjacent angle.
[Alias('Adjacent')]
[double]
$Side2 = $(
    (Get-Random -Minimum 42 -Maximum 84) * (1,-1 | Get-Random)
)
)

# If neither side is a number, return ourself
if (-not $side1 -and -not $side2) { return $this }

# Figure out our angles with a bit of trigonometry.
# (SOHCAHTOA)
$angle1 = [Math]::Atan2($side2, $Side1) * (180/[Math]::Pi)
$angle2 = [Math]::Atan2($side1, $side2) * (180/[Math]::Pi)


# Figure out our hypotenuse (Pythagorean Theorem)
$hypotenuse = [Math]::Sqrt(
    ($Side1 * $side1) +
    ($Side2 * $side2)
)

# Now draw our triangle
return $this.
    # move forward along our current side
    Forward($side1). 
    # turn back around and then turn by our angle. 
    Rotate(180 - $angle1). 
     # draw the hypotenuse
    Forward($hypotenuse).
    # turn back around and then turn by our other angle 
    Rotate(180 - $angle2).
    Forward($side2).
    Rotate(-270)
    

    
    
    

