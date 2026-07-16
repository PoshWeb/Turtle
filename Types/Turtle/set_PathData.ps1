<#
.SYNOPSIS
    Sets our Turtle's path
.DESCRIPTION
    Sets the path data of this Turtle's movements.
    
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
param($value)

$unrolledValue = $value | . { process  { $_ }}

$this | Add-Member NoteProperty '#PathData' -Force -PassThru  -Value "$($unrolledValue -join ' ')"
