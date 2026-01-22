<#
.SYNOPSIS
    Draws a arm or a leg
.DESCRIPTION
    Instructs our Turtle to draw an arm or a leg.

    Each segment of the arm or leg can be considered a pair of vectors.

    Each pair will represent a leg length followed by a leg angle.
.EXAMPLE
    turtle push leg 42 90 42 90 pop push rotate -15 leg 42 90 42 90 pop rotate -30 leg 42 90 42 90
.EXAMPLE
    turtle rotate 90 rotate -15 push leg 21 15 pop rotate 30 push leg 21 -15 pop show 
#>
param()

$pairs = @()
$pair = @()
foreach ($arg in $args) {
    if ($arg -is [ValueType]) {
        if ($arg -is [Numerics.Vector2] -or 
            $arg -is [Numerics.Vector3] -or 
            $arg -is [Numerics.Vector4]
        ) {
            $pair += $arg.X
            $pair += $arg.Y
        } else {
            $pair += $arg
        }
        
    }
    elseif ($arg -as [double]) {
        $pair += $arg
    }
    if ($pair.Count -eq 2) {
        $pairs += ,$pair
        $pair = @()
    }
}

if (-not $pairs) {
    $pairs += ,@(
        Get-Random -Minimum 50 -Maximum 100
        Get-Random -Minimum 30 -Maximum 90
    )
    $pairs += ,@(
        Get-Random -Minimum 50 -Maximum 100
        Get-Random -Minimum 30 -Maximum 90
    )
}

foreach ($pair in $pairs) {
    $this = $this.Forward($pair[0]).Rotate($pair[1])
}
return $this
