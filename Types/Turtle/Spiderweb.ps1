<#
.SYNOPSIS
    Draws a spiderweb with a Turtle
.DESCRIPTION
    Tells our Turtle to draw a spiderweb.

    This will draw any number of spokes, and draw a polygon between each spoke at regular intervals
.EXAMPLE
    # Draw a random spiderweb
    turtle spiderweb
.EXAMPLE
    # Draw a spider web with a radius six
    # containing six rings
    # along six spokes
    turtle spiderweb 6 6 6 show
.EXAMPLE
    # Draw a random spiderweb
    turtle rotate (
        Get-Random -Max 360
    ) web 42 (
        Get-Random -Min 3 -Max 13
    ) (
        Get-Random -Min 3 -Max 13
    ) save ./RandomWeb.svg show
.EXAMPLE
    turtle rotate (
        Get-Random -Max 360
    ) web 42 (
        Get-Random -Min 3 -Max 13
    ) (
        Get-Random -Min 3 -Max (13 * 3)
    ) pathAnimation (
        [Ordered]@{
            type = 'rotate'   ; values = 0, 360 ;repeatCount = 'indefinite'; dur = "41s"
        }
    ) save ./RandomWebRotate.svg show
.EXAMPLE
    turtle viewbox 1080 start (1080/2) (1080/2) web (1080/2) (
        Get-Random -Min 3 -Max 13
    ) (
        Get-Random -Min 3 -Max (13 * 3)
    ) backgroundcolor 'black' stroke 'yellow' pathclass 'yellow-stroke' save ./RandomWebColor.svg save ./RandomWebColor.png 
.EXAMPLE
    turtle rotate (
        Get-Random -Max 360
    ) web 42 (
        Get-Random -Min 3 -Max 13
    ) (
        Get-Random -Min 3 -Max (13 * 3)
    ) pathAnimation (
        [Ordered]@{
            type = 'rotate'   ; values = 0, 360 ;repeatCount = 'indefinite'; dur = "41s"
        }
    ) backgroundcolor 'black' stroke 'yellow' pathclass 'yellow-stroke' save ./RandomWebRotateColor.svg show
.EXAMPLE
    turtle rotate (
        Get-Random -Max 360
    ) web 42 (
        Get-Random -Min 3 -Max 13
    ) (
        Get-Random -Min 3 -Max (13 * 3)
    ) morph save ./RandomWebStepMorph.svg
.EXAMPLE
    $spokes = Get-Random -Min 3 -Max 13
    $rings =  Get-Random -Min 3 -Max (13 * 3)
    turtle web 42 $spokes $rings morph @(
        turtle web 42 $spokes $rings 
        turtle rotate (
            Get-Random -Max 360
        ) web 42 $spokes $rings 
        turtle web 42 $spokes $rings 
    ) save ./RandomWebMorph.svg
.EXAMPLE
    $spokes = Get-Random -Min 3 -Max 13
    $rings =  Get-Random -Min 3 -Max (13 * 3)
    turtle web 42 $spokes $rings morph @(
        turtle web 42 $spokes $rings 
        turtle rotate (
            Get-Random -Max 360
        ) web 42 $spokes $rings 
        turtle web 42 $spokes $rings 
    ) backgroundcolor 'black' stroke 'yellow' pathclass 'yellow-stroke' save ./RandomWebMorphColor.svg
        
#>
param(
# The radius of the web
[double]
$Radius = (Get-Random -Min 42 -Maximum 84),

# The number of spokes in the web.
[int]
$SpokeCount = (Get-Random -Min 5 -Max 13),

# The number of rings in the web.
[int]
$RingCount = (Get-Random -Min 5 -Max 13)
)


# If there were no spokes or rings, return this
if ($spokeCount -eq 0 ) { return $this }
if ($RingCount -eq 0 ) { return $this }


# Determine the angle of the spokes
$spokeAngle = 360 / $SpokeCount

# And draw each spoke.
foreach ($n in 1..$([Math]::Abs($SpokeCount))) {
    $this = $this.Forward($radius).Backward($radius).Rotate($spokeAngle)
}

# Now we have the structure of our web, and we are at the center.
$center = 
    [Numerics.Vector2]::new($this.X, $this.Y)


# Each ring we want to grow the in radius
$radiusStep = $radius  / $RingCount
$inRadius = 0

# Starting from the center, we want to try to make a series of rings to each next point in the web
foreach ($ringNumber in 1..$([Math]::Abs($RingCount))) {
    $inRadius+=$radiusStep
    # First, move along our spoke
    $null = $this.Forward($radiusStep)

    # Then get our bearings
    $heading = $this.Heading

    # and imagine points around a circle, along each of our spokes
    $webPoints = @(
        foreach ($spokeNumber in 1..$SpokeCount) {        
            $heading += $spokeAngle                    
            [Numerics.Vector2]::new(
                $center.X + $inRadius * [math]::cos($heading * [Math]::PI / 180),
                $center.Y + $inRadius * [math]::sin($heading * [Math]::PI / 180)
            )        
        }    
    )

    # Now that we have the points, 
    foreach ($point in $webPoints) {
        # our turtle spider can 
        $this = $this.Rotate(
            # rotate towards the point
            $this.Towards($point.X, $point.Y)
        ).Forward(
            # and close the distance.
            $this.Distance($point.X, $point.Y)
        )
    }

    # Reset our bearings and head up to the next ring.
    $this.Heading = $heading        
}

# Now that we've drawn our web, return ourself.
return $this