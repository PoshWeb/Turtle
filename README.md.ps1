<#
.SYNOPSIS
    Turtle Graphics in PowerShell
.EXAMPLE
    .\README.md.ps1 > .\README.md    
#>
#requires -Module Turtle
param()


$imageHeader = @(
@'
<div align='center'>
    <img src='./Examples/SierpinskiTriangle.svg' alt='SierpinskiTriangle' width='33%' />
    <br/>
    <a href='https://www.powershellgallery.com/packages/Turtle/' >
    <img src='https://img.shields.io/powershellgallery/dt/Turtle' />
    </a>
</div>
'@
)

#region Introduction

@"
# Turtle

$imageHeader

## Turtles in a PowerShell

[Turtle Graphics](https://en.wikipedia.org/wiki/Turtle_graphics) are a great way to learn programming and describe shapes.

Turtle graphics start really simple.

Imagine we are a turtle dragging a pen.  

We can draw almost any shape by moving.

We can only really move in two ways:

We can turn, and we can take a step forward.

Turtle graphics starts with these two operations:

* `Rotate()` rotates the turtle
* `Forward()` moves forward

We can easily keep a list of these steps in memory, and draw them with [SVG](https://developer.mozilla.org/en-US/docs/Web/SVG).

We can make Turtle in any language.

This module gives you Turtle in a PowerShell.

* [Amazing Examples](https://psturtle.com/Commands/Get-Turtle)
* [A Brief History of Turtles](https://psturtle.com/History)


"@

#endregion Introduction

#region Installation

@"
### Installing and Importing

We can install Turtle from the PowerShell Gallery:

~~~PowerShell
$({Install-Module Turtle -Scope CurrentUser -Force})
~~~

Then we can import it like any other module

~~~PowerShell
$({Import-Module Turtle -Force -PassThru})
~~~

#### Cloning and Importing

You can also clone the repository and import the module

~~~PowerShell
$({
git clone https://github.com/PowerShellWeb/Turtle
cd ./Turtle
Import-Module ./ -Force -PassThru
})
~~~
"@

#endregion Installation

#region Turtle PowerShell GitHub Action

@"

### Turtle GitHub Action

Turtle has a GitHub action, and can be run in a workflow.

To use the turtle action, simply refer to this repository:

~~~yaml
- name: UseTurtle
  uses: StartAutomating/Turtle@main
~~~

This will run any *.turtle.ps1 files found in your repository, and check in any files that have changed.

What does this give us?

**We Can Generate Turtle Graphics in GitHub Workflows**

"@

#endregion Turtle PowerShell GitHub Action


#region Getting Started
@"
### Getting Started

Once we've imported Turtle, we can create any number of turtles, and control them with commands and methods.

The turtle is represented as an object, and any number of commands can make or move turtles.

* `New-Turtle` created a turtle
* `Move-Turtle` performs a single turtle movement
* `Set-Turtle` changes the turtle's properties
* `Save-Turtle` saves the output of a turtle.

Last but not least:  `Get-Turtle` lets you run multiple steps of turtle, and is aliased to `turtle`.

Get-Turtle is the command we will use most often, and we will almost always just call it by the alias `turtle`.

If you want to get a sense of all that Turtle can do, check out the [Get-Turtle examples](https://psturtle.com/Commands/Get-Turtle)
"@

@"

### Drawing Squares

<div align='center'>
$(
    $null = Get-Turtle Square 10 | 
        Set-Turtle -Property Stroke '#4488ff' |
        Save-Turtle -Path ./Examples/Square.svg
)
<img src='./Examples/Square.svg' alt='Square' width='50%' />
</div>

Let's start simple, by drawing a square with a series of commands.

~~~PowerShell
$(
$drawSquare1 = {
turtle Forward 10 Rotate 90 |
    turtle Forward 10 Rotate 90 |
    turtle Forward 10 Rotate 90 |
    turtle Forward 10 Rotate 90 |    
    Save-Turtle "./Square.svg"
}
$drawSquare1
)
~~~

"@



@'
We can also write this using a method chain:

~~~PowerShell
$turtle = New-Turtle
$turtle.
    Forward(10).Rotate(90).
    Forward(10).Rotate(90).
    Forward(10).Rotate(90).
    Forward(10).Rotate(90).
    Symbol.Save("$pwd/Square.svg")
~~~

Or we could use a loop:

~~~PowerShell
$turtle = New-Turtle
foreach ($n in 1..4) {
    $turtle = $turtle.Forward(10).Rotate(90)
}
$turtle | Save-Turtle ./Square.svg
~~~

Or we could use `Get-Turtle` directly.

~~~PowerShell
turtle forward 10 rotate 90 forward 10 rotate 90 forward 10 rotate 90 forward 10 rotate 90 |
    Save-Turtle ./Square.svg
~~~

Or we could use `Get-Turtle` with a bit of PowerShell multiplication magic:

~~~PowerShell
turtle ('forward',10,'rotate',90 * 4) |
    Save-Turtle ./Square.svg
~~~

This just demonstrates how we can construct shapes out of these two simple primitive steps.

There are a shell of a lot of ways you can draw any shape.

Turtle has many methods to help you draw, including a convenience method for squares.

So our shortest square can be written as:

~~~PowerShell
turtle square 10 | Save-Turtle ./Square.svg
~~~
'@



@'

### Drawing Other Shapes

We can use the same techniques to construct other shapes.

For example, this builds us a hexagon:

~~~PowerShell
$turtle = New-Turtle

foreach ($n in 1..6) {
    $turtle = $turtle.Forward(10).Rotate(60)
}

$turtle | 
    Save-Turtle "./Hexagon.svg" 
~~~
'@

@"
<div align='center'>
$(
$null = turtle ('Forward', 10, 'Rotate', 60  * 6) | 
    Set-Turtle -Property Stroke '#4488ff' |
    Save-Turtle -Path ./Examples/Hexagon.svg
)
<img src='./Examples/Hexagon.svg' alt='Hexagon' width='50%' />
</div>
"@

@"
Because this Turtle generates SVG, we can also use it to create patterns.
"@

$MakeHexagonPattern = {
    turtle ('Forward', 10, 'Rotate', 60  * 6) | 
        Set-Turtle -Property Stroke '#4488ff' |
        Save-Turtle -Path ./Examples/HexagonPattern.svg -Property Pattern
}


@"

~~~PowerShell
$MakeHexagonPattern
~~~
"@

$HexPattern = . $MakeHexagonPattern

@"
<div align='center'>
<img src='./Examples/$($HexPattern.Name)' alt='Hexagon Pattern' width='50%' />
</div>
"@


#region LSystems

$box1 = {
    Turtle BoxFractal 5 1 |
    Set-Turtle Stroke '#4488ff' |
    Save-Turtle ./Examples/BoxFractal1.svg
}

$box2 = {
    Turtle BoxFractal 5 2 |
    Set-Turtle Stroke '#4488ff' |
    Save-Turtle ./Examples/BoxFractal2.svg
}

$box3 = {
    Turtle BoxFractal 5 3 |
    Set-Turtle Stroke '#4488ff' |
    Save-Turtle ./Examples/BoxFractal3.svg
}

@"

### Drawing Fractals

Turtle is can be used to draw fractals.

Many fractals can be described in something called a [L-System](https://en.wikipedia.org/wiki/L-system) (short for Lindenmayer system)

L-Systems describe: 

* An initial state (called an Axiom)
* A series of rewriting rules
* The way each variable should be interpreted.

For example, let's show how we contruct the [Box Fractal](https://en.wikipedia.org/wiki/Vicsek_fractal)

Our Axiom is `F-F-F-F`.

This should look familiar:  it's a shorthand for the squares we drew earlier.

It basically reads "go forward, then left, four times"

Our Rule is `F = 'F-F+F+F-F'`.

This means every time we encounter `F`, we want to replace it with `F-F+F+F-F`.

This will turn our one box into 6 new boxes.  If we repeat it again, we'll get 36 boxes.  Once more and we're at 216 boxes.

Lets show the first three generations of the box fractal:

~~~PowerShell
$box1

$box2

$box3
~~~
$(
    $null = @(
        . $box1
        . $box2
        . $box3
    )
)

<div align='center'>
<img src='./Examples/BoxFractal1.svg' alt='Box Fractal 1' height='25%' />
<img src='./Examples/BoxFractal2.svg' alt='Box Fractal 2' height='25%' />
<img src='./Examples/BoxFractal3.svg' alt='Box Fractal 3' height='25%' />
</div>
"@


@"
This implementation of Turtle has quite a few built-in fractals.

For example, here is an example of a pattern comprised of Koch Snowflakes:
"@

$MakeSnowflakePattern = {
    turtle KochSnowflake 2.5 4 |     
        Set-Turtle -Property StrokeWidth '0.1%' | 
        Set-Turtle -Property Stroke '#4488ff' | 
        Set-Turtle -Property PatternTransform -Value @{scale = 0.5 } |
        Save-Turtle -Path ./Examples/KochSnowflakePattern.svg -Property Pattern
}


@"

~~~PowerShell
$MakeSnowflakePattern
~~~
"@

$SnowFlakePattern = . $MakeSnowflakePattern

@"
<div align='center'>
<img src='./Examples/$($SnowFlakePattern.Name)' alt='Snowflake Pattern' width='100%' height='25%' />
</div>
"@

@"
We can also animate the pattern, for endless variety:

~~~PowerShell
$(
    @(Get-Content ./Examples/EndlessSnowflake.turtle.ps1 | 
    Select-Object -Skip 1) -join [Environment]::NewLine
)
~~~
"@

@"
<div align='center'>
<img src='./Examples/EndlessSnowflake.svg' alt='Endless Snowflake Pattern' width='100%' height='25%' />
</div>
"@

#endregion LSystems

#region Turtles All The Way Down
@"
### Turtles all the way down

A turtle can contain turtles, which can contain turtles, which can contain turtles ...

We call this 'Turtles All The Way Down', and it lets us do two very important sets of things:

* It allows turtles to interact
* It allows us to model the behavior of multiple turtles

Let's start with a few cool examples.

At the most basic, let's make an inscribed circle and square:

~~~PowerShell
$(
    @(Get-Content ./Examples/InscribedCircle.turtle.ps1 | 
    Select-Object -Skip 1) -join [Environment]::NewLine
)
~~~

"@

@"
<div align='center'>
<img src='./Examples/InscribedCircle.svg' alt='Inscribed Circle' height='25%' />
</div>
"@

@"
Let's see it as a pattern:
"@

@"
<div align='center'>
<img src='./Examples/InscribedCirclePattern.svg' alt='Inscribed Circle Pattern' width='100%' height='25%' />
</div>
"@


@"
#### Behavior Modelling

Imagine we are four turtles in a square, each trying to catch up with the next turtle.

[What kind of shape do you think our paths will draw?](Get-Content ./Examples/FollowThatTurtle.turtle.ps1)

~~~PowerShell
$(
    @(Get-Content ./Examples/FollowThatTurtle.turtle.ps1 | 
    Select-Object -Skip 1) -join [Environment]::NewLine
)
~~~
"@

@"
<div align='center'>
<img src='./Examples/FollowThatTurtle.svg' alt='Follow That Turtle' width='100%' height='25%' />
</div>
"@

@"
Let's see it as a pattern:
"@

@"
<div align='center'>
<img src='./Examples/FollowThatTurtlePattern.svg' alt='Follow That Turtle' width='100%' height='50%' />
</div>
"@

@"

Now let's imagine we have four turtles in the center, and they're trying to get away from the turtles in the corners.

[What kind of shape will this produce?](./Examples/FollowThatTurtleHideAndSeek.turtle.ps1)
~~~PowerShell
$(
    @(Get-Content ./Examples/FollowThatTurtleHideAndSeek.turtle.ps1 | 
    Select-Object -Skip 1) -join [Environment]::NewLine
)
~~~
"@


@"
<div align='center'>
<img src='./Examples/FollowThatTurtleHideAndSeek.svg' alt='Follow That Turtle Hide And Seek' width='100%' />
</div>
"@

@"
Let's see it as a pattern:
"@

@"
<div align='center'>
<img src='./Examples/FollowThatTurtleHideAndSeekPattern.svg' alt='Follow That Turtle Hide And Seek Pattern' width='100%' height='50%' />
</div>
"@
#endregion Turtles All The Way Down

#region Turtles in HTML
@"

### Turtles in HTML

SVG is HTML.

So, because our Turtle is built atop of an SVG path, our Turtle _is_ HTML.

Don't believe me?  Try this?

~~~PowerShell
turtle SierpinskiTriangle |
    Set-Turtle Stroke '#4488ff' | 
    Save-Turtle ./SierpinskiTriangle.html
~~~

Anything we do with our turtle should work within a webpage.

To include a Turtle in a page, we can simply stringify it:

~~~PowerShell
"`$(turtle SierpinskiTriangle)"
~~~

There are a few properties of the turtle that may be helpful:

* `.Canvas` returns the turtle rendered in an HTML canvas
* `.OffsetPath` returns the turtle as an offset path

"@
#endregion Turtles in HTML


#region Turtles in PNG
@"

### Turtles in Raster

Because our Turtle can be painted onto an HTML canvas, we can easily turn it into a raster format, like PNG.

This works by launching the browser in headless mode, rasterizing the image, and returning the bytes.

Any turtle can be saved as a `PNG`, `JPEG`, and `WEBP`.

~~~PowerShell
turtle SierpinskiTriangle |
    Set-Turtle Stroke '#4488ff' | 
    Save-Turtle ./SierpinskiTriangle.png
~~~

"@
#endregion Turtles in PNG

#region Call To Action
@"

### Turtles are Cool

You should now have some sense of how cool Turtle graphics can be, and how easy it is to get stared.

Play around.  Draw something.  Please provide feedback by filing an issue or starting a discussion.

Open an issue if you want a new shape or fractal.  

File a pull request if you have some cool changes to make.

Have fun!

Hope this helps!

"@
#endregion Call To Action


# "![SierpinskiTriangle](./Examples/EndlessSierpinskiTrianglePattern.svg)"


""

