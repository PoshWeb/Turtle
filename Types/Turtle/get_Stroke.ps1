<#
.SYNOPSIS
    Gets a Turtle's stroke color
.DESCRIPTION
    Gets one or more colors used to stroke the Turtle.    

    By default, this is transparent.

    If more than one value is provided, the stroke will be a gradient.
.EXAMPLE
    # Draw a blue square
    turtle square 42 stroke blue 
.EXAMPLE
    # Draw a PowerShell blue square
    turtle square 42 stroke '#4488ff'
.EXAMPLE
    # Draw a red, green, blue gradient
    turtle square 42 stroke red green blue
.EXAMPLE
    # Draw a red, green, blue linear gradient
    turtle square 42 stroke red green blue linear
.EXAMPLE
    turtle flower stroke red green blue 
#>
if ($this.'#Stroke') {
    return $this.'#Stroke'
} else {
    return 'currentcolor'
}