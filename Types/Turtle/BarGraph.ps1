<#
.SYNOPSIS
    Draws a bar graph using turtle graphics.
.DESCRIPTION
    This script uses turtle graphics to draw a bar graph based on the provided data.
.EXAMPLE
    turtle barGraph 100 100 5 10 15 20 15 10 5
.EXAMPLE
    turtle barGraph 200 200 (
        @(1..50;-1..-50) | 
            Get-Random -Count (Get-Random -Minimum 5 -Maximum 20)
    ) save ./RandomBarGraph.svg
.EXAMPLE
    turtle rotate 90 barGraph 200 200 (
        @(1..50;-1..-50) | 
            Get-Random -Count (Get-Random -Minimum 5 -Maximum 20)
    ) save ./RandomVerticalBarGraph.svg
.EXAMPLE
    turtle rotate 45 barGraph 200 200 (
        @(1..50;-1..-50) | 
            Get-Random -Count (Get-Random -Minimum 5 -Maximum 20)
    ) save ./RandomDiagonalBarGraph.svg
.EXAMPLE
    $sourceData = @(1..50;-1..-50)
    $itemCount  = (Get-Random -Minimum 5 -Maximum 20) 
    $points     = $sourceData | Get-Random -Count $itemCount
    turtle bargraph 200 200 $points morph @(
        turtle bargraph 200 200 $points
        turtle bargraph 200 200 ( $sourceData | Get-Random -Count $itemCount )
        turtle bargraph 200 200 $points
    ) save ./RandomBarGraphMorph.svg
#>
param(
# The width of the bar graph
[double]$Width,
# The height of the bar graph.
# Please note that in the case of negative values, the effective height is twice this number.
[double]$Height,

# The points in the bar graph.  
# Each point will be turned into a relative number and turned into an equal-width bar.
[Parameter(ValueFromRemainingArguments)]
[double[]]$Points
)

if ($width -and -not $Height) {
    $height = $width
} elseif ($height -and -not $Width) {
    $width = $height
} elseif (-not $width -and -not $height) {
    $width = (Get-Random -Min 10 -Max 100) * (1,-1| Get-Random)
    $height = (Get-Random -Min 10 -Max 100)
}


# If there were no points, we are drawing nothing, so return ourself.
if (-not $points) { 
    $points = foreach ($n in 1..(Get-Random -Min 4 -Max 20)) {
        Get-Random -Min 0 -Max 100
    }
}

# Divide the width by the number of points to get a very snug bar graph
$barWidth = $width / $points.Length

# Find the maximum and minimum values in the points
$min, $max = 0, 0
foreach ($point in $points) {
    if ($point -gt $max) { $max = $point}
    if ($point -lt $min) { $min = $point}
}

# This gives us the range.
$range = $max - $min

# If the range is zero, we're drawing a flatline.
if ($range -eq 0) {
    # so just draw that line and return.
    return $this.Forward($width)
}

# Now that we've normalized the range, we can draw the bars.
for ($pointIndex =0 ; $pointIndex -lt $points.Length; $pointIndex++) {
    # Each point is essentially telling us the height
    $point = $points[$pointIndex]
    # which we can turn into a relative value
    $relativeHeight = (
        # by subtracting the minimum and dividing by the range
        (($point - $min) / $range)
    ) * $height
    # If the point was negative, we need to flip the height    
    if ($point -lt 0) { $relativeHeight *= -1}
    # Now we can draw the bar
    $this = $this.
        # Turn outward and draw the side
        Rotate(-90).Forward($relativeHeight).
        # Turn and draw the top
        Rotate(90).Forward($barWidth).
        # Turn and draw the other side
        Rotate(90).Forward($relativeHeight).
        # Turn back to the original direction
        Rotate(-90)
}
return $this



