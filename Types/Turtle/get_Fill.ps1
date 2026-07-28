<#
.SYNOPSIS
    Gets a Turtle's fill color
.DESCRIPTION
    Gets one or more colors used to fill the Turtle.    

    By default, this is transparent.

    If more than one value is provided, the fill will be a gradient.
.EXAMPLE
    # Draw a blue square
    turtle square 42 fill blue 
.EXAMPLE
    # Draw a PowerShell blue square
    turtle square 42 fill '#4488ff'
.EXAMPLE
    # Draw a red, green, blue gradient
    turtle square 42 fill red green blue show
.EXAMPLE
    # Draw a red, green, blue linear gradient
    turtle square 42 fill red green blue linear show
.EXAMPLE
    turtle flower fill red green blue fillrule evenodd show
#>
if ($this.'#fill') { 
    return $this.'#fill'
}
return 'transparent'