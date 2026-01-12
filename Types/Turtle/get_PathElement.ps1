<#
.SYNOPSIS
    Gets the Turtle Path Element
.DESCRIPTION
    Gets the Path Element of a Turtle.

    This contains the path of the Turtle's motion.
.EXAMPLE
    turtle forward 42 rotate 90 forward 42 pathElement
#>
[OutputType([xml])]
param()
# Set our core attributes
$coreAttributes = [Ordered]@{
    id="$($this.id)-path"
    d="$($this.PathData)"
    stroke=
        if ($this.Stroke) { $this.Stroke } 
        else { 'currentColor' }
    'stroke-width'=
        if ($this.StrokeWidth) { $this.StrokeWidth } 
        else { '0.1%' }
    fill="$($this.Fill)"
    class=$($this.PathClass -join ' ')
    'transform-origin'='50% 50%' 
}
# If someone decides to override any of these attributes, they are welcome to (at their own aesthetic risk)
foreach ($pathAttributeName in $this.PathAttribute.Keys) {
    $coreAttributes[$pathAttributeName] = $($this.PathAttribute[$pathAttributeName])
}

# Path attributes can be defined within .SVGAttribute or .Attribute
$prefix = [Regex]::new('^/?path/', 'IgnoreCase')
foreach ($collection in $this.SVGAttribute, $this.Attribute) {
    if (-not $collection) { continue }
    foreach ($key in $collection.Keys -match $prefix) {
        $coreAttributes[$attributeName -replace $prefix] = $collection[$attributeName]
    }
}

# Create the elements in an array, and cast it to XML.
[xml]@(
"<path$(
    foreach ($attributeName in $coreAttributes.Keys) {
        " $attributeName='$($coreAttributes[$attributeName])'"
    }
)>"
if ($this.Title) { "<title>$([Security.SecurityElement]::Escape($this.Title))</title>" }
if ($this.PathAnimation) {$this.PathAnimation.OuterXml}
"</path>"
)