<#
.SYNOPSIS
    Gets our Turtle's path
.DESCRIPTION
    Gets the path data of this Turtle's movements.
    
    This is the shape this turtle will draw.
.NOTES
    Turtle Path data is represented as a
    [SVG path](https://developer.mozilla.org/en-US/docs/Web/SVG/Tutorials/SVG_from_scratch/Paths).
    
    This format can also be used as a [Path2D](https://developer.mozilla.org/en-US/docs/Web/API/Path2D/Path2D) in a Canvas element.

    It can also be used in WPF, where it is simply called [Path Markup](https://learn.microsoft.com/en-us/dotnet/desktop/wpf/graphics-multimedia/path-markup-syntax)
.LINK
    https://developer.mozilla.org/en-US/docs/Web/SVG/Tutorials/SVG_from_scratch/Paths
.LINK
    https://developer.mozilla.org/en-US/docs/Web/API/Path2D/Path2D
.LINK
    https://learn.microsoft.com/en-us/dotnet/desktop/wpf/graphics-multimedia/path-markup-syntax?wt.mc_id=MVP_321542    
.EXAMPLE
    turtle square 42 pathdata
#>
if ($this.'#PathData') { return $this.'#PathData'} 
@(    
    # Let's call this trick Schrödinger's rounding.
    # We want to be able to render our shapes with a custom precision
    # but we don't want to slow down in rounding or only be able to round once.
    
    # So we can round when we ask for the path data.
    # This is a much less common request than moving the turtle forward.
    $precision = $this.Precision
    filter roundToPrecision { [Math]::Round($_, $precision)}
    
    if ($null -ne $this.Start.X -and $null -ne $this.Start.Y) {
        if ($precision) {
            "m $($this.Start.x | roundToPrecision) $($this.Start.y | roundToPrecision)"
        } else {
            "m $($this.Start.x) $($this.Start.y)"
        }
        
    }
    else {
        @("m"
        # If the viewbox has been manually set 
        if ($this.'.ViewBox') {
            0, 0 # do not adjust our starting position
        } else {
            # otherwise, translate by the minimum point.
            if ($this.Minimum.X -lt 0) {
                if ($precision) {
                    -1 * $this.Minimum.X | roundToPrecision
                } else {
                    -1 * $this.Minimum.X
                }                
            }
            else { 0 }

            if ($this.Minimum.Y -lt 0) {
                if ($precision) {
                    -1 * $this.Minimum.Y | roundToPrecision
                } else {
                    -1 * $this.Minimum.Y
                }
                
            }
            else { 0 }
        }) -join ' '
    }
    
    # Walk over our steps
    foreach ($step in
        $this.Steps -join ' ' -replace ',',' ' -split '(?=[\p{L}-[E]])' -ne ''
    ) {
        # If our precision is zero or nothing, don't round 
        if (-not $precision) {
            $step
        } else {
            # Otherwise, pick out the letter
            $step.Substring(0,1)
            # and get each digit
            $digits = $step.Substring(1) -split '\s+' -ne '' -as [double[]]
            # and round them.
            foreach ($digit in $digits) {                
                [Math]::Round($digit, $precision)
            }            
        }
    }    
) -join ' '