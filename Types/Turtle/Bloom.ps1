<#
.SYNOPSIS
    Draws a Bloom
.DESCRIPTION
    Draws a Bloom of overlapping circles.
.NOTES
    Inspired by Bloom in NeedleScript
.LINK
    https://www.needlescript.com/
#>
param(
# The number of petals in the bloom.
[int]
$Petals = $(Get-Random -Minimum 4 -Maximum 24),

# The radius of each circle.
[double]
$Radius = $(Get-Random -Minimum 23 -Maximum 42),

# The spread between circles.
[double]
$Spread = $(Get-Random -Minimum 2.3 -Maximum 4.2),

# The extent of a circle to draw.
# Using a partial extent may result in incomplete shapes.
[double]
$Extent = 1.0,

# If true, will leap between petals, rather than draw a line.
[bool]
$Leap
)

if (-not $this) {$this = turtle}

if ($petals -eq 0) { $petals = 1 }

$turtle = $this
foreach ($n in 1..([Math]::Abs($Petals))) {
    $turtle = $turtle.Circle($Radius, $Extent).Rotate(360/$Petals)
    if ($leap -and $turtle.IsPenDown) {
        $turtle = $turtle.PenUp().Forward($spread).PenDown()
    } else {
        $turtle = $turtle.Forward($spread)
    }    
}

return $turtle