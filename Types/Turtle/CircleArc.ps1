<#
.SYNOPSIS
    Draws a Circle Arc
.DESCRIPTION
    Draws a Circular Arc.

    The Turtle heading will not change, and the Turtle will end up at it's original position.
.EXAMPLE
    Turtle CircleArc
.EXAMPLE
    Turtle @(
        'CircleArc',42, 90,
        'Rotate', 90 * 4
    ) save ./Quadrants.svg
.EXAMPLE
    Turtle @(
        'CircleArc',42, 60,
        'Rotate', 60 * 6
    ) save ./Sextants.svg
.EXAMPLE
    Turtle @(
        'CircleArc',42, 45,
        'Rotate', 45 * 8
    ) save ./Octants.svg
#>
param(
# The radius of the circle
[double]
$Radius = $(
    (Get-Random -Min 42 -Max 84) *(1,-1|Get-Random)
),

# The angle of the arc 
[double]
$Angle =  $(
    (Get-Random -Min 30 -Max 90) *(1,-1|Get-Random)
)
)

# If we wanted an angle that was a multiple of 360
# we actually want to just draw a circle
if ([Math]::Round($Angle % 360, $this.Precision) -eq 0) {
    # We start at the center
    $centerX = $this.X
    $centerY = $this.Y

    # Jump to an edge
    $this = $this.Jump($Radius)
    
    # and track the delta
    $DeltaX = $this.X - $centerX
    $DeltaY = $this.Y - $centerY


    return $this.
        # Arcing to the opposite of that delta (*2) takes us to the far edge
        Arc($Radius, $Radius, 0, $false, $false, $DeltaX * -2, $DeltaY * -2).
        # And Arcing back takes us to our original position along the edge
        Arc($Radius, $Radius, 0, $false, $false, $DeltaX * 2, $DeltaY * 2).
        # Jump back and we are back in the center of the circle.
        Jump(-$radius)                
}

# For a normal circular arc, start by pushing our location onto the stack
$this = $this.Push()
# Draw a line to the edge of the circle
$null = $this.Forward($Radius)
# This will be the wedge end
$WedgeEndX = $this.Position.X
$WedgeEndY = $this.Position.Y
# Go back to the center, rotate, and move forward by the radius.
$null = $this.Forward(-$radius)
$null = $this.Rotate($Angle).Forward($radius)
# now we can compute the distance to the end of the wedge
$DeltaX = $WedgeEndX - $this.Position.X
$DeltaY = $WedgeEndY - $this.Position.Y
# and draw an arc to this location
$this = $this.Arc($Radius, $Radius, 0, ($Angle -gt 180), $false, $DeltaX, $DeltaY)
# and then pop our position back
$null = $this.Pop()
# and return this
$null = $this.ResizeViewBox($Radius)
return $this

