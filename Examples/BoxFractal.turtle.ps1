#requires -Module Turtle
$boxFractalTurtle = Turtle id BoxFractal-15-5 BoxFractal 15 5 | 
    Set-Turtle Stroke '#4488ff'
$boxFractalTurtle | Save-Turtle "./BoxFractal.svg"
$boxFractalTurtle | Save-Turtle "./BoxFractal.png" -Property PNG

