<#
.SYNOPSIS
    Draws spokes of a wheel
.DESCRIPTION
    Draws spokes of a wheel, or sticks around a point.
.NOTES
    This was adapted from Cynthia Solomon's example on LogoThings
.LINK
    https://logothings.github.io/logothings/logo/Sticks.html
.EXAMPLE
    turtle spokes 42 4
.EXAMPLE
    turtle spokes 42 5
.EXAMPLE
    turtle spokes 42 6
.EXAMPLE
    turtle spokes 42 8   
.EXAMPLE
    turtle spokes 42 6 morph @(
        turtle spokes 42 6
        turtle rotate 90 spokes 42 6
        turtle rotate 180 spokes 42 6
        turtle rotate 270 spokes 42 6
        turtle spokes 42 6
    ) show
.EXAMPLE
    turtle spokes pathAnimation (
        [Ordered]@{
            type = 'rotate'   ; values = 0, 360 ;repeatCount = 'indefinite'; dur = "4.2s"
        }
    ) show
.EXAMPLE
    turtle viewbox 84 turtles @(
        turtle spokes 42 6 pathAnimation (
            [Ordered]@{
                type = 'rotate'   ; values = 0, 360 ;repeatCount = 'indefinite'; dur = "4.2s"
            }
        )
        turtle spokes 42 6 pathAnimation (
            [Ordered]@{
                type = 'rotate'   ; values = 360, 0 ;repeatCount = 'indefinite'; dur = "4.2s"
            }
        )                
    ) show
.EXAMPLE
    turtle viewbox 84 turtles @(
        turtle start 42 42 stroke red spokes 42 6 pathAnimation (
            [Ordered]@{
                type = 'rotate'   ; values = 0, 360 ;repeatCount = 'indefinite'; dur = "4.2s"
            }
        )
        turtle start 42 42 stroke red spokes 42 6 pathAnimation (
            [Ordered]@{
                type = 'rotate'   ; values = 360, 0 ;repeatCount = 'indefinite'; dur = "4.2s"
            }
        )
        turtle start 42 42 stroke green spokes 42 8 pathAnimation (
            [Ordered]@{
                type = 'rotate'   ; values = 0, 360 ;repeatCount = 'indefinite'; dur = "4.2s"
            }
        )
        turtle start 42 42 stroke green spokes 42 8 pathAnimation (
            [Ordered]@{
                type = 'rotate'   ; values = 360, 0 ;repeatCount = 'indefinite'; dur = "4.2s"
            }
        )
        turtle start 42 42 stroke blue spokes 42 10 pathAnimation (
            [Ordered]@{
                type = 'rotate'   ; values = 0, 360 ;repeatCount = 'indefinite'; dur = "4.2s"
            }
        )
        turtle start 42 42 stroke blue spokes 42 10 pathAnimation (
            [Ordered]@{
                type = 'rotate'   ; values = 360, 0 ;repeatCount = 'indefinite'; dur = "4.2s"
            }
        )
    ) show
#>
param(
# The radius of the spokes
[double]
$Radius = $(Get-Random -Min 42 -Max 84),

# The number of spokes or sticks to draw
[int]
$SpokeCount = $(3..12 | Get-Random)    
)

$spokeAngle = 360 / $SpokeCount

foreach ($n in 1..$([Math]::Abs($SpokeCount))) {
    $this = $this.Forward($radius).Backward($radius).Rotate($spokeAngle)
}
return $this