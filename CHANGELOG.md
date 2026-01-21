## Turtle 0.2.2:

* New Shapes:  
  * `Turtle.ArcFlower` ( #358 )
  * `Turtle.Arcygon` ( #359 )
  * `Turtle.ClosePath` ( #277 )  
  * `Turtle.RightTriangle` ( #367 )
  * `Turtle.Rhombus` ( #372 )
  * `Turtle.StepCurve` ( #329 )
  * `Turtle.Triflower` ( #371 )
  * `Turtle.Lucky` draws a random shape (#366)  
* Font Settings:
  * `Turtle.FontWeight` ( Fixes #354, Fixes #381 )
  * `Turtle.FontVariant` ( Fixes #354, Fixes #380 )
  * `Turtle.FontStyle` ( Fixes #354, Fixes #379 )
  * `Turtle.FontSize` ( Fixes #354, Fixes #378 )
  * `Turtle.FontFamily` ( Fixes #354, Fixes #377 )
* Improvements
  * Turtle.PathAnimation outputs XML (#374)
  * Get-Turtle speed boost (#368)
  * Move-Turtle uses the script (#351)
  * Randomizing most default parameters (#363)
  * Turtle defaults IDs to timestamp ( #362 )
  * Fill and Stroke improvement ( Fixes #360, Fixes #361, Fixes #369 )    
    * Adding random support
    * Improving gradient support
    * Overwriting class if stroke is specified
* Fixes
  * Turtle.History compatibility fix ( #373 )
    * Turtle works on PowerShell 5.1!
  * Moore Curve Fixes ( #370 )

---

## Turtle 0.2.1:

* New Documentation:
  * Over 130 examples!
  * A Brief History of Turtles (#249)
* Website improvements
  * Copy Code Button! (#331)
  * Improved layout and new backgrounds (#333)
  * Improving build (#344)
  * Defaulting palette selection (#346)
* Major improvements
  * A turtle can now be any element!
  * Support for CSS keyframes, styles, and variables!
  * Vastly expanded SVG support, including bezier curves!
  * CircleArcs and Pie Graphs!  Improvements to circles.
* `Turtle` command improvements:
  * `Get-Turtle`
    * `Get-Turtle` help (#273) ( `turtle flower help` `turtle flower help examples`)
    * `Get-Turtle` now tracks commands (#250)
    * `Get-Turtle` now supports brackets (#255) and prebalances them (#262)
    * `Get-Turtle -AsJob` (#268)
    * `Get-Turtle` improved set errors (#252)
  * `Save-Turtle`
    * `Save-Turtle` saves as SVG by default (#259)
    * `Save-Turtle` autosaves by name (#269)
  * `Show-Turtle` will show the turtle (#257)  
* New methods:
  * `Turtle.a/Arc` (#231)
  * `Turtle.b/BezierCurve` (#228)
  * `Turtle.CircleArc` (#235)
  * `Turtle.c/CubicBezierCurve` (#230)
  * `Turtle.FractalShrub` (#332)
  * `Turtle.Leg` (#288)  
  * `Turtle.Pie/PieGraph` (#239)
  * `Turtle.q/QuadraticBezierCurve` (#229)
  * `Turtle.Repeat` (#256)
  * `Turtle.Spider` (#289)
  * `Turtle.Spiderweb` (#290)
  * `Turtle.Spokes` (#291)
  * `Turtle.Sun` (#297)
  * `Turtle.Show` (#258)  
* New properties:
  * `Turtle.get_ArgumentList` (#296)
  * `Turtle.get/set_Attribute` (#247)
  * `Turtle.get/set_Class` (#237)
  * `Turtle.get_Commands` (#250)
  * `Turtle.get_DataBlock` (#284)
  * `Turtle.get/set_Element` (#248)  
  * `Turtle.get/set_Defines` (#243)
  * `Turtle.get_ScriptBlock` (#253)   
  * `Turtle.get/set_Defines` (#243)
  * `Turtle.get/set_Keyframe(s)` (#251)
  * `Turtle.get_History` (#279)
  * `Turtle.get/set_Link/Href` (#241)
  * `Turtle.get/set_Locale` (#300)
  * `Turtle.get_Marker` (#227)
  * `Turtle.get/set_MarkerEnd` (#233)
  * `Turtle.get/set_MarkerMiddle` (#234)
  * `Turtle.get/set_MarkerStart` (#232)  
  * `Turtle.get/set_Opacity` (#293)
  * `Turtle.get/set_Precision` (#225)
  * `Turtle.ResizeViewBox` (#238)
  * `Turtle.get/set_Start` (#245)        
  * `Turtle.get/set_Style` (#254)
  * `Turtle.get/set_Variable` (#263)
  * `Turtle.get/set_Title` (#285)
* New pseudo type:
  * `Turtle.History`
    * `Turtle.History.ToString()` (#282)
    * `Turtle.History.DefaultDisplay` (#283)
  * `Turtle.js` (experimental)
    * Javascript version of turtle (#302)    
    * Initial Core Operations:
      * `Turtle.js.heading` (#303)
      * `Turtle.js.rotate` (#304)
      * `Turtle.js.forward` (#305) (#337) (#338)
      * `Turtle.js.isPenDown` (#306)
      * `Turtle.js.goTo` (#307)
      * `Turtle.js.step` (#308)
      * `Turtle.js.teleport` (#309) (#334)
      * `Turtle.js.steps` (#310)
      * `Turtle.js.min` (#311)
      * `Turtle.js.max` (#312)
      * `Turtle.js.resize` (#313)
      * `Turtle.js.x` (#314)
      * `Turtle.js.y` (#315)
      * `Turtle.js.width` (#316)
      * `Turtle.js.height` (#317)
      * `Turtle.js.pathData` (#318) (#339)
      * `Turtle.js.polygon` (#319) (#336) (#338)
      * `Turtle.js.penUp` (#322)
      * `Turtle.js.penDown` (#323)
      * `Turtle.js.parse` (#327)
      * `Turtle.js.go` (#330)
      * `Turtle.js.ToString.ps1()` (#320)
      * `Turtle.js.get_JavaScript.ps1` (#324)
    * Thanks @ninmonkey for early testing!
* Improved methods:
  * `Turtle.ArcLeft/ArcRight` allows StepCount (#272)
  * `Turtle.Circle` optimization (#287)
  * `Turtle.FractalPlant` improvement (#271)
  * `Turtle.HorizontalLine` is mapped to SVG `h` (#280)
  * `Turtle.VerticalLine` is mapped to SVG `v` (#281)  
* Improvemented Properties:
  * Adding `[OutputType([xml])]` to properties that output XML (#266)
  * `Turtle.get_Duration` defaults (#270)
  * `Turtle.get_Mask/PatternMask` returns only the mask (#261)  
  * `Turtle.set_BackgroundColor` applies to SVG directly (#260)  
  * `Turtle.get_Maximum` is a vector (#275)
  * `Turtle.get_Minimum` is a vector (#276)
  * `Turtle.get_Position` is a vector (#274)
  * `Turtle.set_Stroke` supports gradients (#295)
  * `Turtle.set_Fill` supports gradients (#294)
  * `Turtle.set_PathAnimation` will not overwrite a morph (#244)
  * `Turtle.get/set_PatternAnimation` uses duration (#299) and improved docs (#298)
  * `Turtle.get_TextElement` defaults to centered text (#265)
  * `Turtle.get_TextElement` improved color support (#292)
  * `Turtle.get_ViewBox` negative bounds (#286)
* More aliases:
  * Added Internationalized Aliases (i.e. `Turtle.BackgroundColour`) (#236)
  * SVG syntax aliases (#240)
* Fixed extra output in `Turtle.Pop` (#264)

---

## Turtle 0.2:

### Turtles All The Way Down 

A turtle can now contain `.Turtles`
Which can contain `.Turtles`
Which can contain `.Turtles`
Which can contain `.Turtles`...

* Turtles all the way down (#206)
  * `Turtle.get/set_Turtles` (#207)
  * `Turtle.get_SVG` supports children (#209)
  * `Turtle.get_Canvas` rasterization improvement (#210)
  * `Turtle.Towards()` multiple targets (#211) 
  * `Turtle.Distance()` multiple targets (#212)
* `Turtle.Morph` supports stepwise animation (#215)
* Small fixes
  * `Turtle.Step()` uses Add (#213)
  * `Turtle.set_Steps` initialization fix (#214)
  * `Turtle.set_Duration` anytime (#216)
  * `Turtle.get_SVG` empty viewbox support (#218)
  * `Turtle.get/set_SVGAttribute` (#219)
  * `Turtle.get/set_SVGAnimation` (#220)
  * `Turtle.get/set_PathTransform` (#217)
  * `Turtle.Forward()` removing rounding (#221)

---

## Turtle 0.1.10:

* Updated Methods
  * `Turtle.Star` even point fix (#190)
  * `Turtle.Polygon` partial polygon support (#194)
* New Shapes
  * `Turtle.Rectangle` (#192)
  * `Turtle.StarFlower` (#191)
  * `Turtle.GoldenFlower` (#193)
  * `Turtle.HatMonotile` (#196)
  * `Turtle.TurtleMonotile` (#195)
  * `Turtle.BarGraph` (#173)
* Added Demos
   * Intro To Turtles (#197)
   
---

## Turtle 0.1.9:

* Turtle Text Path Support
  * `Turtle.get/set_Text` controls the text (#167)
  * `Turtle.get/set_TextAttribute` sets text attributes (#168)
  * `Turtle.get/set_TextAnimation` animates text attributes (#171)
* `Get-Turtle` parameter improvements (#169, #170)
* `Get-Turtle` tracks invocation info (#157)

---

## Turtle 0.1.8:

* Turtle Performance
  * Improving `.Steps` performance (#159)
  * Reducing Turtle Verbosity (#160)
* New Moves:
  * Step (#161)
  * Forward,Teleport, and GoTo now use Step (#161)
* New Reflection Examples (#162)

---

## Turtle 0.1.7:

* Morphing Turtles
  * `Turtle.Morph` morphs shapes (#154)
  * `Turtle.get/set_Duration` control animation durations (#153)
  * [Lots of new examples](https://psturtle.com/Commands/Get-Turtle)
* New Fractals:
  * LevyCurve (#155)
  * Triplexity (#156)

---

## Turtle 0.1.6:

* Vastly expanded Get-Turtle examples (#149)
* Check out https://psturtle.com/Commands/Get-Turtle
* New L-Systems:
  * BoardFractal (#142)
  * CrystalFractal (#143)
  * RingFractal (#144)
  * TileFractal (#145)
  * Pentaplexity (#146)
* Fixing KochCurve parameter order (#147)
* Added New-Turtle docs (#148)


## Turtle 0.1.5:

* New Shapes:
  * Scissor draws a pair of lines at an angle (#128)
  * ScissorPoly draws a polygon out of scissors (#129)
* Fixes:
  * OffsetPath is now quoted (#130)
  * ArcLeft/Right distance fix (#131)

---

## Turtle 0.1.4

* `Turtle` Upgrades
  * `turtle` will return an empty turtle (#112)
  * `turtle` now splats to script methods, enabling more complex input binding (#121)
  * `LSystem` is faster and more flexible (#116)
* New Properties:
  * `get/set_Opacity` (#115)
  * `get/set_PathAnimation` (#117)
  * `get/set_Width/Height` (#125)
* New Methods:
  * `HorizontalLine/VerticalLine` (#126)
  * `Petal` (#119)
  * `FlowerPetal` (#124)
  * `Spirolateral` (#120)
  * `StepSpiral` (#122)
* Fixes:
  * `Turtle.Towards()` returns a relative angle (#123)

---

## Turtle 0.1.3

* Fixing `Get-Turtle` inline sets (#108, #107)
* Fixing `.PNG/JPEG/WEBP` to no longer try to use msedge (#110)
* Adding `Turtle.get/set_FillRule` to get or set the fill rule for the turtle. (#109)

---

## Turtle 0.1.2

* `Get-Turtle/Turtle` can now get or set properties or methods
* New Methods:
  * `Turtle.Distance()` determines the distance to a point
  * `Turtle.Towards()` determines the angle to a point
  * `Turtle.Home()` sends the turtle to 0,0
  * `Turtle.lt/rt` aliases help original Logo compatibility
  * `Turtle.Save()` calls Save-Turtle
* Explicitly exporting commands from module

---

## Turtle 0.1.1

* Updates:
  * `Turtle.get/set_ID` allows for turtle identifiers
  * `Turtle.ToString()` stringifies the SVG  
* Fixes:
  * Fixing GoTo/Teleport (#90)
  * Fixing Position default (#85) (thanks @ninmonkey !)
  * Fixing Turtle Action ID (#89)
* New:
  * `Turtle.Push()` pushes position/heading to a stack (#91)
  * `Turtle.Pop()` pops position/heading from a stack (#92)
  * `Turtle.get_Stack` gets the position stack (#93)
* New Fractals:
  * `BinaryTree()` (#94)
  * `FractalPlant()` (#95)

---

## Turtle 0.1

* Initial Release
* Builds a Turtle Graphics engine in PowerShell
* Core commands
  * `Get-Turtle` (alias `turtle`) runs multiple moves
  * `New-Turtle` create a turtle
  * `Move-Turtle` performas a single move
  * `Set-Turtle` changes a turtle
  * `Save-Turtle` saves a turtle

~~~PowerShell
turtle Forward 10 Rotate 120 Forward 10 Roate 120 Forward 10 Rotate 120 |
    Set-Turtle Stroke '#4488ff' |
    Save-Turtle ./Triangle.svg
~~~

* Core Object
  * `.Heading` controls the turtle heading
  * `.Steps` stores a list of moves as an SVG path
  * `.IsPenDown` controls the pen
  * `.Forward()` moves forward at heading
  * `.Rotate()` rotates the heading
  * `.Square()` draws a square
  * `.Polygon()` draws a polygon
  * `.Circle()` draws a circle (or partial circle)
* LSystems
  * Turtle can draw a L system.  Several are included:
    * `BoxFractal`
    * `GosperCurve`
    * `HilbertCurve`
    * `KochCurve`
    * `KochIsland`
    * `KochSnowflake`
    * `MooreCurve`
    * `PeanoCurve`
    * `SierpinskiTriangle`
    * `SierpinskiCurve`
    * `SierpinskiSquareCurve`
    * `SierpinskiArrowheadCurve`
    * `TerdragonCurve`
    * `TwinDragonCurve`
       
~~~PowerShell
turtle SierpinskiTriangle 10 4 |
    Set-Turtle Stroke '#4488ff' |
    Save-Turtle ./SierpinskiTriangle.svg    
~~~

