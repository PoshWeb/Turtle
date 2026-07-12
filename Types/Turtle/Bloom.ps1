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
$Spread = $(Get-Random -Minimum 2.3 -Maximum 4.2)
)

if (-not $this) {$this = turtle}

if ($petals -eq 0) { $petals = 1 }

$turtle = $this
foreach ($n in 1..([Math]::Abs($Petals))) {
    $turtle = $turtle.Circle($Radius).Rotate(360/$Petals).Forward($Spread)
}