function Get-Turtle {
    <#
    .SYNOPSIS
        Turtle Graphics in PowerShell
    .DESCRIPTION
        Turtle Graphics in PowerShell.  Draw any image with turtles in a powershell.
    .NOTES
        Turtle Graphics are pretty groovy.
        
        They have been kicking it since 1966, and they are how computers first learned to draw.

        They kicked off the first computer-aided design boom and inspired generations.

        They are also _incredibly_ easy to build.

        A Turtle graphic is described with a series of moves.

        Let's start with the core three moves:
        
        Imagine you are a Turtle holding a pen.

        * You can turn `rotate`
        * You can move `forward`
        * You can lift the pen

        These are the three basic moves a turtle can make.
        
        We can describe more complex moves by combining these steps.

        As a PowerShell turtle, we can take any pipeline of objects and turn them into turtles.

        Each argument can be the name of a method or property of the turtle object.        

        After a member name is encountered,
        subsequent arguments will be passed to the member as parameters.

        This repeats until there are no more arguments to process.

        This lets us write Turtle in a natural syntax.
    .EXAMPLE
        # We can write shapes as a series of steps.
        # Let's start with a simple diagonal line
        turtle rotate 45 forward 42    
    .EXAMPLE
        # Let's draw an equilateral triangle        
        turtle forward 42 rotate 120 forward 42 rotate 120 forward 42
    .EXAMPLE
        # Typing that might get tedious.
        # Instead, let's use a method.
        # Polygon will draw an an N-sided polygon.
        turtle polygon 10 5
    .EXAMPLE
        # There's also a method for squares
        turtle square 42
    .EXAMPLE
        # If we rotate 45 degrees first, our square becomes a rhombus
        turtle rotate 45 square 42
    .EXAMPLE
        # We can also draw a rectangle
        turtle rectangle 42 4.2
    .EXAMPLE
        # If we only provide the first parameter, we get a golden rectangle
        turtle rectangle 42
    .EXAMPLE
        ### Right Triangles
        # We can draw right triangles
        turtle RightTriangle 3 4
    .EXAMPLE
        # Right triangles take two sides
        # either can be negative
        turtle RightTriangle 3 4
        turtle RightTriangle -3 4
        turtle RightTriangle -3 -4
        turtle RightTriangle 3 -4
    .EXAMPLE
        # We can draw a random right triangle
        turtle RightTriangle
    .EXAMPLE
        # We can a right triangle by a random degree
        turtle rotate RightTriangle
    .EXAMPLE
        # We can easily rotate and repeat right triangles
        turtle @(
            'RightTriangle',3,-4,'rotate', 90 * 4
        )
    .EXAMPLE
        # Right triangles are easy to morph
        turtle @(
            'RightTriangle',3,-4,'rotate', 90 * 4
        ) morph @(
            turtle ('RightTriangle',3,-4,'rotate', 90 * 4)
            turtle ('RightTriangle',3,4,'rotate', 90 * 4)
            turtle ('RightTriangle',3,-4,'rotate', 90 * 4)
        )
    .EXAMPLE
        # We can create a parallax by repeating and reflecting triangles
        turtle @(
            'RightTriangle', 1,-4
            'RightTriangle', 2,-4
            'RightTriangle', 3,-4
            'RightTriangle', 4,-4
            'RightTriangle', -4,-4
            'RightTriangle', -3,-4
            'RightTriangle', -2,-4
            'RightTriangle', -1,-4
        )
    .EXAMPLE
        # This can also be morphed to produce a beautiful illusion
        turtle morph @(
            turtle @(
                'RightTriangle', 1,-4
                'RightTriangle', 2,-4
                'RightTriangle', 3,-4
                'RightTriangle', 4,-4
                'RightTriangle', -4,-4
                'RightTriangle', -3,-4
                'RightTriangle', -2,-4
                'RightTriangle', -1,-4
            )
            turtle @(
                'RightTriangle', -1,-4
                'RightTriangle', -2,-4
                'RightTriangle', -3,-4
                'RightTriangle', -4,-4
                'RightTriangle', 4,-4
                'RightTriangle', 3,-4
                'RightTriangle', 2,-4
                'RightTriangle', 1,-4
            )
            turtle @(
                'RightTriangle', 1,-4
                'RightTriangle', 2,-4
                'RightTriangle', 3,-4
                'RightTriangle', 4,-4
                'RightTriangle', -4,-4
                'RightTriangle', -3,-4
                'RightTriangle', -2,-4
                'RightTriangle', -1,-4
            )
        )
    .EXAMPLE
        # Two sets of right triangles that grow in different directions
        # produce what looks like a parallax illusion curve        
        turtle id ParallaxCorner @(foreach ($n in 1..10) {
            'RightTriangle',(10 - $n),$n
            'RightTriangle',$n,(10-$n)
        })
    .EXAMPLE
         # We can rotate and repeat this to make a Parallax Astroid
        turtle id ParallaxAstroid (@(
            @(foreach ($n in 1..10) {
                'RightTriangle',(10 - $n),$n
                'RightTriangle',$n,(10-$n)    
            })
            'rotate', 90
        ) * 4)
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
            'pathclass','foreground-stroke foreground-fill'
            'fillrule','evenodd'
        )
    .EXAMPLE
        #### Circles
        # We can draw a circle 
        turtle circle 10
    .EXAMPLE
        # Or a pair of half-circles
        turtle circle 10 0.5 rotate 90 circle 10 0.5
    .EXAMPLE
        # We can multiply arrays in PowerShell
        # this can make composing complex shapes easier.
        # Let's take the previous example and repeat it 8 times.
        turtle @('circle',42,0.5,'rotate',90 * 8)
    .EXAMPLE
        # We can also write this with a polygon
        turtle polygon 10 3    
    .EXAMPLE
        # Let's make a series of polygons, decreasing in size
        turtle polygon 10 6 polygon 10 5 polygon 10 4
    .EXAMPLE
        # We can also use a loop to produce a series of steps
        # Let's extend our previous example and make 9 polygons
        turtle @(
            foreach ($n in 12..3) {
                'polygon'
                42
                $n
            }
        )
    .EXAMPLE
        # We can use the same trick to make successively larger polygons
        turtle @(
            $sideCount = 3..8 | Get-Random 
            foreach ($n in 1..5) {
                'polygon'
                $n * 10
                $sideCount
            }
        )
    .EXAMPLE
        # We can reflect a shape by drawing it with a negative number
        turtle polygon 42 3 polygon -42 3
    .EXAMPLE
        # We can change the angle of reflection by rotating first
        turtle rotate 60 polygon 42 3 polygon -42 3
    .EXAMPLE
        # We can morph any N shapes with the same number of points.        
        turtle square 42 morph @(
            turtle square 42
            turtle rotate 45 square 42
            turtle square 42
        )
    .EXAMPLE
        # Reflections always have the same number of points.
        # 
        # Morphing a shape into its reflection will zoom out, flip, and zoom back in.
        turtle polygon 42 6 morph @(
            turtle polygon -42 6
            turtle polygon 42 6
            turtle polygon -42 6
        )
    .EXAMPLE    
        # If we want to morph a smaller shape into a bigger shape,
        # 
        # we can duplicate lines
        turtle polygon 21 6 morph @(
            turtle @('forward', 21,'backward', 21 * 3)
            turtle polygon 21 6
            turtle @('forward', 21,'backward', 21 * 3)
        )                
    .EXAMPLE
        # We can repeat steps by multiplying arrays.
        # Lets repeat a hexagon three times with a rotation
        turtle ('polygon', 23, 6, 'rotate', -120 * 3)
    .EXAMPLE
        # Let's change the angle a bit and see how they overlap        
        turtle ('polygon', 23, 6, 'rotate', -60 * 6)
    .EXAMPLE
        # Let's do the same thing, but with a smaller angle
        turtle ('polygon', 23, 6, 'rotate', -40 * 9)
    .EXAMPLE
        ### Flowers
        # A flower is a series of repeated polygons and rotations
        turtle Flower    
    .EXAMPLE
        # Flowers look pretty with any number of polygons
        turtle Flower 50 10 (3..12 | Get-Random) 36
    .EXAMPLE
        # Flowers get less dense as we increase the angle and decrease the repetitions
        turtle Flower 50 15 (3..12 | Get-Random) 24
    .EXAMPLE
        # Flowers get more dense as we decrease the angle and increase the repetitions.
        turtle Flower 50 5 (3..12 | Get-Random) 72
    .EXAMPLE        
        # Flowers look especially beautiful as they morph
        $sideCount = (3..12 | Get-Random)        
        turtle Flower 50 15 $sideCount 36 morph @(
            turtle Flower 50 10 $sideCount 72
            turtle rotate (                
                Get-Random -Max 360 -Min -360
            ) Flower 50 5 $sideCount 72
            turtle Flower 50 10 $sideCount 72
        )
    .EXAMPLE
        # We can draw many types of Flowers
        # A `triflower` is a flower made of Right Triangles
        turtle TriFlower 50 15 24 25
    .EXAMPLE
        # Triflowers morph smoothly
        turtle TriFlower 50 15 25 24 morph @(
            turtle TriFlower 50 15 25 24 
            turtle TriFlower 25 15 50 24 
            turtle TriFlower 50 15 25 24 
        )
    .EXAMPLE
        # We can draw a flower using golden rectangles
        # We call this a `GoldenFlower`
        turtle GoldenFlower 50 15 24
    .EXAMPLE
        # GoldenFlowers also morph smoothly
        turtle GoldenFlower 50 15 24 morph @(
            turtle GoldenFlower 50 15 24
            turtle GoldenFlower -50 30 24
            turtle GoldenFlower 50 15 24
        )
    .EXAMPLE
        ### Petals and Flowers
        # We can draw a pair of arcs and turn back after each one.
        # 
        # We call this a 'petal'.
        turtle rotate -30 Petal 42 60
    .EXAMPLE
        # We can construct a flower out of petals
        turtle FlowerPetal
    .EXAMPLE
        # Adjusting the angle of the petal makes our petal wider or thinner
        turtle FlowerPetal 42 15 (20..60 | Get-Random) 24
    .EXAMPLE
        # Flower Petals get more dense as we decrease the angle and increase repetitions 
        turtle FlowerPetal 42 10 (10..50 | Get-Random) 36
    .EXAMPLE
        # Flower Petals get less dense as we increase the angle and decrease repetitions
        turtle FlowerPetal 50 20 (20..72 | Get-Random) 18
    .EXAMPLE
        # Flower Petals look amazing when morphed
        $Radius = 23..42 | Get-Random
        $flowerAngle = 30..60 | Get-Random
        $AngleFactor = 2..6 | Get-Random
        $StepCount = 36
        $flowerPetals =
            turtle rotate (
                (Get-Random -Max 180) * -1
            ) flowerPetal $radius 10 $flowerAngle $stepCount
        $flowerPetals2 =
            turtle rotate (
                (Get-Random -Max 180)
            ) flowerPetal $radius (
                10 * $AngleFactor
            ) $flowerAngle $stepCount
        turtle flowerPetal $radius 10 $flowerAngle $stepCount morph (
            $flowerPetals, 
            $flowerPetals2,
            $flowerPetals
        )
    .EXAMPLE
        # We can also draw flower out of circles.
        # We call this a `bloom`
        turtle bloom
    .EXAMPLE
        # Blooms take a radius, petal count, spread        
        turtle bloom 42 6 60 6
    .EXAMPLE
        # Blooms look blooming beautiful when morphed
        turtle bloom 42 6 60 morph @(
            turtle bloom 42 6 60
            turtle bloom 42 6 10
            turtle bloom 42 6 60
        )
    .EXAMPLE
        # We can also provide a jump and extent
        turtle bloom 42 8 120 21 0.25
    .EXAMPLE
        turtle bloom 42 8 120 21 0.25 morph @(
            turtle bloom 42 8 120 21 0.25
            turtle bloom 42 8 120 0 0.25
            turtle bloom 42 8 120 21 0.25
        )        
    .EXAMPLE
        turtle bloom 42 4 120 0 0.5
    .EXAMPLE
        turtle bloom 42 4 120 0 0.5 morph @(
            turtle bloom 42 4 120 0 0.5
            turtle bloom 42 4 120 0 -0.5
            turtle bloom 42 4 120 0 0.5
        )
    .EXAMPLE
        #### Roses
        # We can draw roses
        # They use the format `$radius` `$frequency` `$extent` `$stepcount`
        Turtle rose 42 2
    .EXAMPLE
        # All the simple roses
        # 
        # between 1 and 8
        Turtle rose 42 2 1 
        Turtle rose 42 3 1
        Turtle rose 42 4 1
        Turtle rose 42 5 1
        Turtle rose 42 6 1
        Turtle rose 42 7 1
        Turtle rose 42 8 1
    .EXAMPLE
        # All the simple fractional roses
        #
        # between 1/2 and 1/8
        Turtle rose 42 (1/2) 2
        Turtle rose 42 (1/3) 3
        Turtle rose 42 (1/4) 4
        Turtle rose 42 (1/5) 5
        Turtle rose 42 (1/6) 6
        Turtle rose 42 (1/7) 7
        Turtle rose 42 (1/8) 8
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
        turtle Rose 100 2 8 morph @(
            turtle Rose 100 2 1 8
            turtle Rose 100 4 1 8
            turtle Rose 100 2 1 8
        )
    .EXAMPLE
        # We can rotate and repeat roses
        turtle repeat 4 [ rotate 90 rose 42 2 ] 
    .EXAMPLE
        turtle repeat 8 [ rotate 45 rose 42 2 ]    
    .EXAMPLE
        turtle repeat 2 [ rotate 180 rose 42 (1/2) 2 ]
    .EXAMPLE
        #### Arcs and Suns
        # We can arc right or left
        turtle arcRight 42 120
        turtle arcLeft 42 120 
    .EXAMPLE
        # We can arc right and then left to produce a ray or wave shape
        turtle arcRight 42 120 arcLeft 42 120
    .EXAMPLE
        # We can rotate and repeat that rays to make a sun
        $Length = 42
        $Angle = 160
        $RayAngle = 90
        $StepCount = 9
        turtle sun $Length $Angle $RayAngle $StepCount
    .EXAMPLE
        # If we reverse the ray angle and morph, the sun really shines!
        turtle Sun 100 135 60 8 morph @(
            turtle Sun 100 135 60 8
            turtle Sun 100 135 -60 8
            turtle Sun 100 135 60 8
        ) 
    .EXAMPLE
        # We can add multiple fixed colors to make a gradient
        # Then the sun is truly bright.
        turtle Sun 100 135 60 8 fill 'yellow' 'goldenrod' stroke 'goldenrod' 'yellow' morph @(
            turtle Sun 100 135 60 8
            turtle Sun 100 135 -60 8
            turtle Sun 100 135 60 8
        ) 
    .EXAMPLE
        #### Stars
        # We can create a Star with N points
        turtle star 42 5

        turtle star 42 6

        turtle star 42 7

        turtle star 42 8
    .EXAMPLE
        # Stars look spectacular when we rotate and repeat them 
        turtle @('star',42,5,'rotate',72 * 5)

        turtle @('star',42,6,'rotate',60 * 6)

        turtle @('star',42,7,'rotate',(360/7) * 7)

        turtle @('star',42,8,'rotate',45 * 8)
    .EXAMPLE
        #### Starflowers
        # When we do this, we call it a Star Flower
        turtle StarFlower 42
    .EXAMPLE
        turtle StarFlower 42 30 6 12
    .EXAMPLE
        turtle StarFlower 42 (360/7) 7 7
    .EXAMPLE
        turtle StarFlower 42 45 8 8
    .EXAMPLE
        # StarFlowers look spectacular when morphed
        turtle StarFlower 42 45 8 24 morph @(
            turtle StarFlower 42 45 8 24
            turtle StarFlower 42 15 8 24
            turtle StarFlower 42 45 8 24
        )
    .EXAMPLE
        # We can rotate the points we morph into.
        turtle StarFlower 42 45 8 24 morph @(
            turtle StarFlower 42 45 8 24
            turtle rotate (Get-Random -Max 360) StarFlower 42 15 8 24
            turtle StarFlower 42 45 8 24
        )
    .EXAMPLE
        # We can mix the number of points in a star flower morph
        # 
        # (as long as we're drawing the same number of points)        
        turtle StarFlower 42 12 5 30 morph @(
            turtle StarFlower 42 12 5 30
            turtle rotate (
                Get-Random -Max 360 -Min -360
            ) StarFlower 42 14.4 6 25
            turtle StarFlower 42 12 5 30
        )
    .EXAMPLE
        #### Scissors
        # We can construct a 'scissor' by drawing two lines at an angle
        turtle Scissor 42 60
    .EXAMPLE
        # Drawing a scissor does not change the heading
        #
        # We can create a zig-zag pattern by multiplying scissors
        turtle @('Scissor',42,60 * 4)
    .EXAMPLE
        # Getting a bit more interesting, we can create a polygon out of scissors
        # 
        # We will continually rotate until we have turned a multiple of 360 degrees.
        Turtle ScissorPoly 23 90 120
    .EXAMPLE
        Turtle ScissorPoly 23 60 72
    .EXAMPLE
        # This can get very chaotic, if it takes a while to reach a multiple of 360
        # 
        # Let's build a dozen scissor polygons.        
        foreach ($n in 60..72) {
            Turtle ScissorPoly 16 $n $n
        }
    .EXAMPLE
        #### Step Spirals
        # We can draw an outward spiral by growing a bit each step
        turtle StepSpiral
    .EXAMPLE
        turtle StepSpiral 42 120 4 18
    .EXAMPLE
        # Because Step Spirals are a fixed number of steps,        
        # they are easy to morph.
        turtle StepSpiral 42 120 4 18 morph @(
            turtle StepSpiral 42 90 4 24
            turtle StepSpiral 42 120 4 24
            turtle StepSpiral 42 90 4 24            
        )
    .EXAMPLE
        turtle @('StepSpiral',3, 120, 'rotate',60 * 6)
    .EXAMPLE
        turtle @('StepSpiral',3, 90, 'rotate',90 * 4)
    .EXAMPLE
        # Step spirals look lovely when morphed
        #
        # (especially when reversing angles)
        turtle @('StepSpiral',3, 120, 'rotate',60 * 6) morph @(
            turtle @('StepSpiral',3, 120, 'rotate',60 * 6)
            turtle @('StepSpiral',6, -120, 'rotate',120 * 6)
            turtle @('StepSpiral',3, 120, 'rotate',60 * 6)
        )
    .EXAMPLE        
        # When we reverse the spiral angle, the step spiral curve flips
        turtle @('StepSpiral',3, 90, 'rotate',90 * 4) morph @(
            turtle @('StepSpiral',3, 90, 'rotate',90 * 4)
            turtle @('StepSpiral',3, -90, 'rotate',90 * 4)
            turtle @('StepSpiral',3, 90, 'rotate',90 * 4)
        )
    .EXAMPLE
        # When we reverse the rotation, the step spiral curve slides
        turtle @('StepSpiral',3, 90, 'rotate',90 * 4) morph @(
            turtle @('StepSpiral',3, 90, 'rotate',90 * 4)
            turtle @('StepSpiral',3, 90, 'rotate',-90 * 4)
            turtle @('StepSpiral',3, 90, 'rotate',90 * 4)
        )
    .EXAMPLE
        # We we alternate, it looks amazing
        turtle @('StepSpiral',3, 90, 'rotate',90 * 4) morph @(
            turtle @('StepSpiral',3, 90, 'rotate',90 * 4)
            turtle @('StepSpiral',3, 90, 'rotate',-90 * 4)
            turtle @('StepSpiral',3, 90, 'rotate',90 * 4)
            turtle @('StepSpiral',3, -90, 'rotate',90 * 4)
            turtle @('StepSpiral',3, 90, 'rotate',90 * 4)            
        )
    .EXAMPLE        
        turtle @('StepSpiral',3, 120, 'rotate',60 * 6) morph @(
            turtle @('StepSpiral',3, 120, 'rotate',60 * 6)
            turtle @('StepSpiral',6, -120, 'rotate',120 * 6)
            turtle @('StepSpiral',3, 120, 'rotate',60 * 6)
            turtle @('StepSpiral',6, 120, 'rotate',-120 * 6)
            turtle @('StepSpiral',3, 120, 'rotate',60 * 6)
        )
    .EXAMPLE
        #### Spirolaterals
        turtle spirolateral 10 90 10
    .EXAMPLE
        turtle spirolateral 50 60 10
    .EXAMPLE
        turtle spirolateral 50 120 6 @(1,3)
    .EXAMPLE
        turtle spirolateral 23 144 8
    .EXAMPLE
        turtle spirolateral 23 72 8    
    .EXAMPLE
        #### Bezier Curves
        # We can draw simple Bezier Curves.
        # Imagine a string being tugged by a point
        turtle bezierCurve 0 100 100 100
    .EXAMPLE
        # A morph can help us understand bezier curve movement
        turtle bezierCurve 0 100 100 100 morph @(
            turtle bezierCurve 0 100 100 100
            turtle bezierCurve 100 0 100 100
            turtle bezierCurve 0 100 100 100
        )
    .EXAMPLE
        # Lets make it more exaggerated
        turtle viewbox 150 bezierCurve 0 100 100 100 morph @(
            turtle bezierCurve 0 200 100 100
            turtle bezierCurve 200 0 100 100
            turtle bezierCurve 0 200 100 100
        )    
    .EXAMPLE
        # We use the shorthand 's' for a simple bezier curve
        turtle s 100 0 100 100
    .EXAMPLE
        # This helps make beautifully short moprhs
        turtle s 100 0 100 100 morph @(
            turtle s 100 0 100 100
            turtle s 0 100 100 100
            turtle s 100 0 100 100
        )
    .EXAMPLE
        # We can also draw quadratic bezier curves
        turtle quadraticbezierCurve 0 100 100 100
    .EXAMPLE
        # We can use the alias q, and morph them, too.
        turtle q 0 100 100 100 morph @(
            turtle q 100 0 100 100
            turtle q 0 100 100 100
            turtle q 100 0 100 100
        )
    .EXAMPLE
        # We can also draw cubic bezier curves
        # For these, imaging a string being pulled by two other strings.        
        turtle cubicBezierCurve 0 100 100 0 100 100
    .EXAMPLE
        # We can shorten this to `c`, and morph it in beautiful ways        
        turtle width 200 height 200 morph @(
            turtle c 0   0 0   0 200 200 
            turtle c 0 200 200 0 200 200 
            turtle c 0   0 0   0 200 200
            turtle c 200 0 0 200 200 200
            turtle c 0   0 0   0 200 200 
        )

        turtle width 200 height 200 start 200 200 morph @(
            turtle c 0    0 0    0 -200 200 
            turtle c 0  200 -200 0 -200 200 
            turtle c 0    0 0    0 -200 200
            turtle c -200 0 0  200 -200 200
            turtle c 0    0 0    0 -200 200 
        )        
    .EXAMPLE
        # We can start at a given location, and morph along an axis.
        turtle width 200 height 200 morph @(
            turtle start 100 0 c 0 0 0 0 0 200
            turtle start 100 0 c -100 0 100 200 0 200
            turtle start 100 0 c 0 0 0 0 0 200
        )
    .EXAMPLE
        turtle width 200 height 200 morph @(
            turtle start 0 100 c 0 0 0 0 200 0
            turtle start 0 100 c 0 -100 200 100 200 0
            turtle start 0 100 c 0 0 0 0 200 0
        )
    .EXAMPLE
        #### Curvy Turtles
        # Turtles can be curvy
        # We can tell turtle to use a Curvature
        turtle curvature 1 curvetype QuadraticCurve rotate 45 square
    .EXAMPLE
        # We can tell turtle to use a Simple Bezier Curvature
        turtle curvature 1 curvetype SimpleCurve rotate 45 square
    .EXAMPLE
        # We can tell turtle to use a Cubic Bezier Curvature
        turtle curvature 1 curvetype CubicCurve rotate 45 square
    .EXAMPLE
        # We can morph between the same curve type
        # We can also specify the curve with the first letter in brackets.
        # Let's morph between curves
        turtle rotate 45 square 42 morph @(
            turtle curvature 0 curvetype [q] rotate 45 square 42
            turtle curvature 1 curvetype [q] rotate 45 square 42
            turtle curvature 0 curvetype [q] rotate 45 square 42
        )
    .EXAMPLE
        turtle rotate 45 square 42 morph @(
            turtle curvature 0 curvetype [c] rotate 45 square 42
            turtle curvature 1 curvetype [c] rotate 45 square 42
            turtle curvature 0 curvetype [c] rotate 45 square 42
        )
    .EXAMPLE
        turtle rotate 45 square 42 morph @(
            turtle curvature 0 curvetype [s] rotate 45 square 42
            turtle curvature 1 curvetype [s] rotate 45 square 42
            turtle curvature 0 curvetype [s] rotate 45 square 42
        )
    .EXAMPLE
        #### Curvy Flowers
        # We can make any of our flowers curvy
        turtle curvature 1 curvetype [q] flower 42 60 6 6
    .EXAMPLE
        # Curvy Flowers morph nicely
        turtle flower 42 60 6 6 morph @(
            turtle curvature 0 curvetype [q] flower 42 60 6 6
            turtle curvature 2 curvetype [q] flower 42 60 6 6
            turtle curvature 0 curvetype [q] flower 42 60 6 6
        )
    .EXAMPLE
        turtle starflower 42 60 6 6 morph @(
            turtle curvature 0 curvetype [q] starflower 42 60 6 6
            turtle curvature 2 curvetype [q] starflower 42 60 6 6
            turtle curvature 0 curvetype [q] starflower 42 60 6 6
        )
    .EXAMPLE
        turtle triflower 42 60 6 6 morph @(
            turtle curvature 0 curvetype [q] triflower 42 60 6 6
            turtle curvature 2 curvetype [q] triflower 42 60 6 6
            turtle curvature 0 curvetype [q] triflower 42 60 6 6
        )
    .EXAMPLE
        turtle goldenflower 42 60 6 6 morph @(
            turtle curvature 0 curvetype [q] goldenflower 42 60 6 6
            turtle curvature 1 curvetype [q] goldenflower 42 60 6 6
            turtle curvature 0 curvetype [q] goldenflower 42 60 6 6
        )
    .EXAMPLE
        #### Bar Graphs
        # Lets get practical.  Turtle can easily make a bar graph.
        turtle BarGraph 200 300 (1..10)
    .EXAMPLE
        # Want a vertical bar graph? Rotate first.
        turtle rotate 90 BarGraph 200 300 (1..10)
    .EXAMPLE
        # Let's provide more random points:
        turtle rotate 90 BarGraph 200 300 (1..20 | Get-Random -Count 20)
    .EXAMPLE
        # We can draw pretty pictures by connecting and rotating graphs
        turtle @(
            'BarGraph', 200, 300, (1..10),
            'BarGraph', 200, 300, (10..1),
            'rotate',180 * 2
        )
    .EXAMPLE
        #### Pie Graphs        
        # Want a Piece of Pie?
        Turtle Pie 100 4
        Turtle Pie 100 6
        Turtle Pie 100 8
    .EXAMPLE
        # Want a quarter?
        Turtle Pie 100 (1/4)
    .EXAMPLE
        # How about a range of slices?
        Turtle Pie 100 (1..10)
    .EXAMPLE
        # What about some colorful slices?
        Turtle Pie 100 @(
            foreach ($color in 'red', 'green', 'blue') {
                @{
                    Value = 1
                    PathClass = "$color-fill foreground-stroke"
                    Fill = $color
                    Title = $color
                }
            }
        )
    .EXAMPLE
        # What about some random colorful slices?
        Turtle Pie 100 @(
            foreach ($color in 'red', 'green', 'blue', 'yellow', 'magenta','cyan') {
                @{
                    Value = (Get-Random -Max 100)
                    PathClass = "$color-fill foreground-stroke"
                    Fill = $color
                    Title = $color
                }
            }
        )
    .EXAMPLE
        #### Circle Arcs
        # Pie graphs are made out of circle arcs
        Turtle id Quadrants @(
            'CircleArc',42, 90,
            'Rotate', 90 * 4
        )
        Turtle id Sextants @(
            'CircleArc',42, 60,
            'Rotate', 60 * 6
        )
        Turtle id Octants @(
            'CircleArc',42, 45,
            'Rotate', 45 * 8
        )        
    .EXAMPLE
        # We can alternate rotations and arcs to create radial stripes
        Turtle 'Rotate', -22.5 @(
            'Rotate', 15,
            'CircleArc',42, 15,
            'Rotate', 15 * 24
        )
        
        Turtle 'Rotate', -15 @(
            'Rotate', 30,
            'CircleArc',42, 30,
            'Rotate', 30 * 12
        )
            
        Turtle @(
            'Rotate', 60,
            'CircleArc',42, 60,
            'Rotate', 60 * 6
        )
    .EXAMPLE
        # We can draw negative circle arcs
        Turtle CircleArc 42 -90    
    .EXAMPLE    
        # Negative quadrants
        Turtle @(
            'CircleArc',42, -90,
            'Rotate', 90 * 4
        )
    .EXAMPLE    
        # Negative sextants
        Turtle @(
            'CircleArc',42, -60,
            'Rotate', 60 * 6
        )
    .EXAMPLE    
        # Negative octants
        Turtle @(
            'CircleArc',42, -45,
            'Rotate', 45 * 8
        )
    .EXAMPLE
        # We can combine arcs and movement to make a pinwheel
        turtle @(
            'circlearc', 42, 60,
            'rotate',60,
            'forward',42  * 6 
        )    
    .EXAMPLE
        # Lets morph positive quadrants into negative quadrants
        $quadrants = Turtle @(
            'CircleArc',42, 90,
            'Rotate', 90 * 4
        )
        $quadrants | turtle morph @(
            $quadrants
            Turtle @(
                'CircleArc',42, -90,
                'Rotate', 90 * 4
            )
            $quadrants
        )        
    .EXAMPLE
        # Lets morph positive sextants into negative sextants
        $sextants = Turtle id Sextants @(
            'CircleArc',42, 60,
            'Rotate', 60 * 6
        )
        $sextants | turtle morph @(
            $sextants
            Turtle @(
                'CircleArc',42, -60,
                'Rotate', 60 * 6
            )
            $sextants
        )
    .EXAMPLE
        # Lets morph positive octants into negative octants
        $octants = Turtle id Octants @(
            'CircleArc',42, 45,
            'Rotate', 45 * 8
        )
        
        $octants | turtle morph @(
            $octants
            Turtle @(
                'CircleArc',42, -45,
                'Rotate', 45 * 8
            )
            $octants
        )
    .EXAMPLE
        # We can overlap pinwheels to make even more exotic shapes
        turtle @(
            @(
                'circlearc', 21, -60,
                'rotate',60,
                'forward',42  * 6 
                'rotate', 30
            ) * 12
        )
    .EXAMPLE        
        # We can morph and spin these exotic shapes to create hypnotic animations
        $exoticShape = turtle (
            @(                
                'circlearc', 21, -60,
                'rotate',60,
                'forward',42  * 6 
                
                'rotate', 30
            ) * 12
        )
        
        $exoticShape |
            turtle morph @(
                $exoticShape
                turtle (
                    @(                
                        'circlearc', 21, 60,
                        'rotate',60,
                        'forward',42  * 6 
                        
                        'rotate', 30
                    ) * 12
                )
                $exoticShape
            ) pathAnimation @{
                type = 'rotate'
                values = 0, 360
                repeatCount = 'indefinite'
            }
    .EXAMPLE
        #### Turtles all the way down
        # Turtles can contain turtles.
        # Let's make a circle inscribed into a square
        turtle viewbox 42 turtles ([Ordered]@{
            'square' = turtle square 42 
            'circle' = turtle circle 21
        })        
    .EXAMPLE
        # Each turtle can have a distinct color or CSS class
        turtle viewbox 42 turtles ([Ordered]@{
            'square' = turtle square 42 pathclass 'blue-fill foreground-stroke'
            'circle' = turtle circle 21 pathclass 'cyan-fill foreground-stroke' 
        })
    .EXAMPLE
        # Lets make some colorful boxes
        turtle viewbox 42 turtles @([Ordered]@{
            'q1' = turtle start 0 0 square 21 pathclass 'red-fill foreground-stroke'
            'q2' = turtle start 21 0 square 21 pathclass 'green-fill foreground-stroke'
            'q3' = turtle start 21 21 square 21 pathclass 'yellow-fill foreground-stroke'
            'q4' = turtle start 0 21 square 21 pathclass 'blue-fill foreground-stroke'
        })
    .EXAMPLE
        # Nested turtles can morph!
        # Let's move these squares around.
        turtle viewbox 42 turtles @([Ordered]@{
            'q1' = turtle viewbox 21 fill red pathclass 'red-fill foreground-stroke' morph @(
                turtle start 0 0 square 21
                turtle start 21 0 square 21
                turtle start 21 21 square 21
                turtle start 0 21 square 21
                turtle start 0 0 square 21
            )
            'q2' = turtle viewbox 21 fill green pathclass 'green-fill foreground-stroke' morph @(
                turtle start 21 0 square 21
                turtle start 21 21 square 21
                turtle start 0 21 square 21
                turtle start 0 0 square 21
                turtle start 21 0 square 21
            )
            'q3' = turtle viewbox 21 fill yellow pathclass 'yellow-fill foreground-stroke' morph @(
                turtle start 21 21 square 21
                turtle start 0 21 square 21
                turtle start 0 0 square 21
                turtle start 21 0 square 21
                turtle start 21 21 square 21
            ) 
            'q4' = turtle viewbox 21 fill blue pathclass 'blue-fill foreground-stroke' morph @(                
                turtle start 0 21 square 21
                turtle start 0 0 square 21
                turtle start 21 0 square 21
                turtle start 21 21 square 21
                turtle start 0 21 square 21
            )
        })
    .EXAMPLE
        # Let's make a colorful cubic morph
        $Colors = @('fill', '#4488ff','stroke','#224488','pathclass', 'brightBlue-fill','blue-stroke')
        turtle width 200 height 200 turtles @(
            turtle morph @(
                turtle c 0   0 0   0 200 200 
                turtle c 0 200 200 0 200 200 
                turtle c 0   0 0   0 200 200
                turtle c 200 0 0 200 200 200
                turtle c 0   0 0   0 200 200 
            ) @colors
            turtle morph @(
                turtle c 0    0 0    0 -200 200 
                turtle c 0  200 -200 0 -200 200 
                turtle c 0    0 0    0 -200 200
                turtle c -200 0 0  200 -200 200
                turtle c 0    0 0    0 -200 200 
            ) @colors
            turtle morph @(
                turtle teleport 100 0 c 0 0 0 0 0 200
                turtle teleport 100 0 c -100 0 100 200 0 200
                turtle teleport 100 0 c 0 0 0 0 0 200
            ) @colors
            turtle morph @(
                turtle teleport 0 100 c 0 0 0 0 200 0
                turtle teleport 0 100 c 0 -100 200 100 200 0
                turtle teleport 0 100 c 0 0 0 0 200 0
            ) @colors
        )
    .EXAMPLE
        #### Webs
        # Turtle can draw webs
        Turtle Spiderweb
    .EXAMPLE
        # Turtle can draw spiderwebs with any number of spokes and rings
        Turtle Spiderweb 7 13
    .EXAMPLE
        Turtle Spiderweb 7 13
    .EXAMPLE
        # We can draw random webs
        $spokes = Get-Random -Min 3 -Max 13
        $rings =  Get-Random -Min 3 -Max (13 * 3)
        turtle web 42 $spokes $rings morph @(
            turtle web 42 $spokes $rings 
            turtle rotate (
                Get-Random -Max 360
            ) web 42 $spokes $rings 
            turtle web 42 $spokes $rings 
        ) stroke 'goldenrod' pathclass 'yellow-stroke'
    .EXAMPLE
        # We can draw a web with color and class
        Turtle Spiderweb 7 13 stroke goldenrod pathclass 'yellow-stroke'
    .EXAMPLE
        # We can draw a random web with color and class
        $spokes = Get-Random -Min 5 -Max 13
        $rings  = Get-Random -Min 3 -Max (13 * 3)
        turtle web 42 $spokes $rings morph @(
            turtle web 42 $spokes $rings 
            turtle rotate (
                Get-Random -Min 90 -Max 360
            ) web 42 $spokes $rings
            turtle web 42 $spokes $rings
        ) stroke goldenrod pathclass 'yellow-stroke'
    .EXAMPLE
        #### Websites

        # We can make websites in Turtle 
        turtle markdown "            

        We can write websites in Turtle.

        A Turtle can be made of Markdown, like this one.

        If we can string a few sentences together, we can write a website.

        "
    .EXAMPLE
        turtle markdown '            

        Markdown turtles are _very_ cool.
        
        Markdown has tons of useful features, like:

        * Bullet Point Lists
        * Numbered Lists
        * Tables
        * Headings
        * Code Blocks

        All we need to do is:

        ~~~PowerShell
        turtle markdown $markdown
        ~~~
        '        
    .EXAMPLE
        # We can also create arbitrary elements
        turtle element "<p>Like this paragraph</p>"
    .EXAMPLE
        # We can use `turtle style` to generate CSS

        turtle style @{
            '.cool6' = @{
                'font-size' = '1.5rem'
                'font-style' = 'italic'
            }
        }
    .EXAMPLE    
        # We can use `turtle class` to give an element class
        # We can make a list of turtles and multiply them
        # This repeats the element N times

        @(
            turtle class cool6 element '<span>Cool</span>'
        ) * 6
    .EXAMPLE
        # We can also use a string expansion `$()`. 
        # 
        # This embeds multiple turtles into one string.
        "$(
            @(
                turtle class cool6 element '<span>Cool</span>'
            ) * 6
        )"
    .EXAMPLE
        # We can also `-join` turtles by a string.
        #
        # That string can be anything
        (@(
            turtle class cool6 element '<span>Cool</span>'
        ) * 6) -join ' <b>Very</b> '
    .EXAMPLE
        # We can also simply write inline html
        turtle element "
        <menu>
            <button>1</button>
            <button>2</button>
            <button>3</button>
        </menu>
        "
    .EXAMPLE
        # We can use htmx  
        turtle element '
        <button hx-on:click="alert(''You clicked me!'')">
            Click Me!
        </button>
        '        
    .EXAMPLE
        # We can create keyframes        
        turtle square 42 fill '#4488ff' stroke '#224488' keyframe ([Ordered]@{
            'wiggle3d' = [Ordered]@{
                '0%,100%' = [Ordered]@{
                    transform = "rotateX(-3deg) rotateY(-3deg) rotateZ(-3deg)"            
                }
                '50%' = [Ordered]@{
                    transform = "rotateX(3deg) rotateY(3deg) rotateZ(3deg)"
                }
            }
        }) pathclass wiggle3d
    .EXAMPLE
        turtle keyframe ([Ordered]@{
            'wiggle3d' = [Ordered]@{
                '0%,100%' = [Ordered]@{
                    transform = "rotateX(-3deg) rotateY(-3deg) rotateZ(-3deg)"            
                }
                '50%' = [Ordered]@{
                    transform = "rotateX(3deg) rotateY(3deg) rotateZ(3deg)"
                }
            }
        })
        turtle class wiggle3d markdown '# Turtles Are Fun'

    .EXAMPLE
        #### Extending Turtle
        # Turtle is extensible
        #
        # We can add new methods to turtle with `turtle to`
        turtle to [hexagon] :size 42 [ repeat 6 [ forward :size rotate 60 ]] hexagon
    .EXAMPLE
        # We can also define a method in PowerShell
        turtle to [menu] {
            param()
            "<menu>$($args -join ' ')</menu>"
        }
        turtle menu @(
            "<a href='/'><button>Home</button></a>"
            "<a href='/History'><button>History</button></a>"
            "<a href='/Commands/Get-Turtle'><button>Examples</button></a>"
        )
    .EXAMPLE
        #### Drawing with Symbols
        # Fun fact: Glyphs _are_ Turtles.
        #
        # Each character is a Turtle living in a box
        # 
        # Many methods are aliased to symbols
        #
        # Here are some of the symbols we can use
        # |Symbol|Method|
        # |-|-|
        # |∠|Rotate|
        # |⊿|RightTriangle|
        # |⊿⚘|Triflower|
        # |⌒|Arc|
        # |⌒⬡|Arcygon|
        # |□|Square|
        # |▯|Rectangle|
        # |△|Tri|
        # |△△|TriTri|
        # |☆|Star|
        # |⚘|Flower|
        # |⚘⊿|Triflower|
        # |⚘▯|Goldenflower|
        # |⚘☆|Starflower|
        # |⚘⭘|Bloom|
        # |⟁|SierpinskiTriangle|
        # |⦣|Left|
        # |⪦|CircleArc|
        # |⬡|Polygon|
        # |⭘|Circle|
        # |⭠|Backward|
        # |⭢|Forward|         
        # 
        # We can also use the 🐢 symbol as an alias for `turtle`

        # Let's draw a few shapes this way.
        🐢 ∠ 120 ⭢ 1 ∠ 120 ⭢ 1 ∠ 120 ⭢ 1
    .EXAMPLE    
        # The golden ratio
        🐢 □ 1 ▯ 1
    .EXAMPLE
        # One third of a circle
        🐢 ⪦ 1 (360 * 1/3)
    .EXAMPLE
        # A 1/3 2/3rd pie graph
        🐢 ⪦ 1 (360 * 1/3 ) ∠ ( 360 * 1/3 ) ⪦ 1 ( 360 * 2/3 )
    .EXAMPLE
        🐢 □ 1 ⊿ 1 1 
    .EXAMPLE
        # A flower
        🐢 repeat 6 [ ∠ 60 ⬡ 6 6 ]
    .EXAMPLE    
        # A Starflower
        🐢 repeat 5 [ ∠ 72 ☆ 6 5 ]
    .EXAMPLE    
        # A bloom
        🐢 repeat 6 [ ⭘ 42 ∠ 60 ]
    .EXAMPLE    
        # A triflower
        🐢 repeat 6 [ ⊿ 6 6 ∠ 60 ]
    .EXAMPLE    
        # A Flower and Starflower
        🐢 repeat 5 [ ∠ 72 ☆ 6 5 ⬡ 6 5  ]
    .EXAMPLE    
        # A Flower, StarFlower, and Bloom        
        🐢 repeat 5 [ ∠ 72 ☆ 6 5 ⬡ 6 5 ⭘ 6 ]
    .EXAMPLE    
        # A Flower, StarFlower, Triflower, and Bloom        
        🐢 repeat 6 [ ∠ 60 ☆ 6 6 ⬡ 6 6 ⊿ 6 6 ⭘ 6 ]
    .EXAMPLE    
        # A Parallax View
        🐢 ⊿ 1 -2 ⊿ 2 -2  ⊿ -2 -2 ⊿ -1 -2
    .EXAMPLE
        # A Parallax Astroid
        🐢 (
            @(
                foreach ($n in 1..7) {
                    '⊿',(7 - $n),$n
                    '⊿',$n,(7-$n)    
                }
                '∠',90      
            ) * 4
        )
    .EXAMPLE
        # A Parallax Astroid Morph
        $moves = @(
            foreach ($n in 1..7) {
                '⊿',(7 - $n),$n
                '⊿',$n,(7-$n)    
            }
            '∠',90
        ) * 4
        🐢 $moves morph @(
            🐢 $moves
            🐢 (
                @(
                    foreach ($n in 1..7) {
                        '⊿',(7 - $n),($n*-1)
                        '⊿',($n*-1),(7-$n)    
                    }
                    '∠',90      
                ) * 4
            )

            🐢 $moves
        )
    .EXAMPLE
        #### Fractals
        # Turtle can draw a number of fractals
        turtle BoxFractal 42 4
    .EXAMPLE
        # We can make a Board Fractal
        turtle BoardFractal 42 4
    .EXAMPLE
        # We can make a Crystal Fractal
        turtle CrystalFractal 42 4
    .EXAMPLE
        # We can make ring fractals
        turtle RingFractal 42 4
    .EXAMPLE
        # We can make a Triplexity
        turtle Triplexity 42 4
    .EXAMPLE
        # We can draw the Koch Island 
        turtle KochIsland 42 4
    .EXAMPLE
        # Or we can draw the Koch Curve
        turtle KochCurve 42 
    .EXAMPLE
        # We can make a Koch Snowflake
        turtle KochSnowflake 42
    .EXAMPLE
        # We can make Krishna Anklets
        turtle KrishnaAnklets 42 4       
    .EXAMPLE
        # Krishna Anklets look beautiful when curved and morphed
        turtle KrishnaAnklets 42 4 morph @(
            turtle curvature -1 curvetype [q] KrishnaAnklets 42 4
            turtle curvature 1 curvetype [q] KrishnaAnklets 42 4
            turtle curvature -1 curvetype [q] KrishnaAnklets 42 4
        )
    .EXAMPLE
        # We can make a Pentaplexity
        turtle Pentaplexity 42 3
    .EXAMPLE
        # We can draw the Levy Curve
        turtle LevyCurve 42 6
    .EXAMPLE
        # We can use a Hilbert Curve to fill a space
        Turtle HilbertCurve 42 4
    .EXAMPLE
        # We can use a Moore Curve to fill a space with a bit more density.
        turtle MooreCurve 42 4
    .EXAMPLE
        # We can rotate and repeat moore curves, giving us even Moore.
        turtle @('MooreCurve', 42, 4, 'Rotate', 90 * 4)
    .EXAMPLE
        # We can show a binary tree
        turtle BinaryTree 42 4
    .EXAMPLE
        # We can make fractal plants
        turtle FractalPlant 42 4
    .EXAMPLE
        # We can also make fractal shrubs
        turtle FractalShrub 42 4
    .EXAMPLE
        # The SierpinskiArrowHead Curve is pretty          
        turtle SierpinskiArrowheadCurve 42 4
    .EXAMPLE
        # So is the SierpinskiCurve
        turtle SierpinskiCurve 42 4
    .EXAMPLE
        # The SierpinskiCurveSquare curve fills a from a corner
        turtle SierpinskiSquareCurve 42 4
    .EXAMPLE
        # If we put four of these next to each other
        # and turn left, we get a square made of square curves.
        turtle @('SierpinskiSquareCurve', -42, 4, 'Rotate', -90 * 4) 
    .EXAMPLE
        # If we turn right instead, we get a diamond with an empty square at the center        
        turtle @('SierpinskiSquareCurve', -42, 4, 'Rotate', 90 * 4)     
    .EXAMPLE
        # The SierpinskiTriangle is a Fractal classic    
        turtle SierpinskiTriangle 42 4
    .EXAMPLE
        # We can morph with no parameters to try to draw step by step
        # 
        # This will result in large files, and may not work in all browsers
        # 
        # For best results, adjust the precision
        turtle SierpinskiTriangle 42 3 morph
    .EXAMPLE
        # We can morph most shapes with a curvature
        # SierpinskiTriangle 42 3
        turtle SierpinskiTriangle 42 3 morph @(
            turtle curvature -1 curvetype [q] SierpinskiTriangle 42 3
            turtle curvature 1 curvetype [q] SierpinskiTriangle 42 3
            turtle curvature -1 curvetype [q] SierpinskiTriangle 42 3
        )
    .EXAMPLE
        # Let's draw two reflected Sierpinski Triangles
        turtle @(
            'rotate', 60
            'SierpinskiTriangle', 42, 4
            'SierpinskiTriangle', -42, 4
        )
    .EXAMPLE
        # Now let's draw a dozen reflected Sierpinski Triangles
        turtle @(
            'rotate', 60,
            'SierpinskiTriangle', 42, 3,
            'SierpinskiTriangle', -42, 3,
            'rotate', 30 *
                12
        )
    .EXAMPLE
        # We can draw a 'Sierpinski Snowflake' with multiple Sierpinski Triangles.
        turtle @('rotate', 30, 'SierpinskiTriangle',42,3 * 12)
    .EXAMPLE
        turtle @('rotate', 45, 'SierpinskiTriangle',42,3 * 24)    
    .LINK
        https://psturtle.com/Commands/Get-Turtle
    .LINK
        https://psturtle.com/History/
    #>
    [CmdletBinding(PositionalBinding=$false)]
    [Alias('turtle','🐢')]
    param(
    # The arguments to pass to turtle.
    [ArgumentCompleter({
        param ( $commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters )
        if (-not $script:TurtleTypeData) {
            $script:TurtleTypeData = Get-TypeData -TypeName Turtle
        } 
        $memberNames = @($script:TurtleTypeData.Members.Keys)
                
        if ($wordToComplete) {
            return $memberNames -like "$wordToComplete*"
        } else {
            return $memberNames
        }
    })]
    [Parameter(ValueFromRemainingArguments)]
    [PSObject[]]
    $ArgumentList,

    # Any input object to process.
    # If this is already a turtle object, the arguments will be applied to this object.
    # If the input object is not a turtle object, it will be ignored and a new turtle object will be created.
    [Parameter(ValueFromPipeline)]
    [PSObject]
    $InputObject,

    # If set, will run as a background job.
    [switch]
    $AsJob
    )

    begin {        
        # Create a new turtle object in case we have no turtle input.
        $currentTurtle = [PSCustomObject]@{PSTypeName='Turtle'}

        # Grab our invocation information
        $invocationInfo = $myInv = $MyInvocation
        # and attach a script property to access this point in command history
        $invocationInfo | 
            Add-Member ScriptProperty History {Get-History -Id $this.HistoryId} -Force
                    
        # Peek at our callstack
        $myCallstack = @(Get-PSCallStack)
        # and try to get our most recent few callers
        foreach ($possibleCaller in $myCallstack[-1..-3]) {
            # If we can, find the CommandAst that called us.
            # (this will have the arugment list in a more useful form, and will help us recreate a call)
            if (-not $possibleCaller.InvocationInfo.MyCommand.ScriptBlock.Ast) { continue }
            $myCommandAst = 
                $possibleCaller.InvocationInfo.MyCommand.ScriptBlock.Ast.FindAll({
                    param($ast) 
                        $ast.Extent.StartLineNumber -eq $myInv.ScriptLineNumber -and
                        $ast.Extent.StartColumnNumber -eq $myInv.OffsetInLine -and 
                        $ast -is [Management.Automation.Language.CommandAst]
                },$true)
            if ($myCommandAst) {
                break
            }
        }        
    }

    process {
        # If we were piped in a Turtle,
        if ($PSBoundParameters.InputObject -and 
            $PSBoundParameters.InputObject.pstypenames -eq 'Turtle') {
            # make it the current turtle
            $currentTurtle = $PSBoundParameters.InputObject
        } elseif ($PSBoundParameters.InputObject) {
            # If input was passed, and it was not a turtle, pass it through.
            return $PSBoundParameters.InputObject
        }

        #region -AsJob
        # If we wanted to run a background job        
        if ($PSBoundParameters.AsJob) {
            # remove the -AsJob variable from our parameters
            $null = $PSBoundParameters.Remove('AsJob')
            
            $jobCommand = 
                $threadJob = 
                    $ExecutionContext.SessionState.InvokeCommand.GetCommand('Start-ThreadJob', 'Cmdlet')
            
            if (-not $threadJob) {
                $jobCommand = $ExecutionContext.SessionState.InvokeCommand.GetCommand('Start-Job', 'Cmdlet')                
            }

            if (-not $jobCommand) {
                Write-Error "No Job Command found.  Start-ThreadJob or Start-Job must be loaded"
                return
            }
                        
            # and then start a thread job that will import the module and run the command.
            return & $jobCommand -ScriptBlock {
                param([Collections.IDictionary]$IO)
                Import-Module -Name $io.ModulePath
                $argList = @($IO.ArgumentList)
                if ($IO.InputObject) {
                    $io.InputObject | & $io.CommandName @argList
                } else {
                    & $io.CommandName @argList
                }
            } -ArgumentList (
                [Ordered]@{
                    ModulePath = $MyInvocation.MyCommand.ScriptBlock.Module.Path -replace '\.psm1$', '.psd1'
                    CommandName = $MyInvocation.MyCommand.Name
                } + $PSBoundParameters
            )
        }
        #endregion -AsJob

        if (-not $currentTurtle.Invocations) {
            $currentTurtle | Add-Member NoteProperty Invocations -Force @(,$invocationInfo) 
        } elseif ($currentTurtle.Invocations -is [object[]]) {
            $currentTurtle.Invocations += $invocationInfo
        }

        if ($myCommandAst) {
            if (-not $currentTurtle.Commands) {
                $currentTurtle | Add-Member NoteProperty Commands -Force @(,$myCommandAst)
            } elseif ($currentTurtle.Commands -is [object[]]) {
                $currentTurtle.Commands += $myCommandAst
            }
        }

        $currentTurtle.Go($ArgumentList)
    }
}
