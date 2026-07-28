<#
.SYNOPSIS
    Gets a Turtle's Style
.DESCRIPTION
    Gets any CSS styles associated with the Turtle.

    These styles will be declared in a `<style>` element, just beneath a Turtle's `<svg>`
.EXAMPLE
    turtle style '.myClass { color: #4488ff}' style
#>
param()

# If we don't already have a list of styles
if (-not $this.'#style') {
    # Initialize one
    $this | Add-Member NoteProperty '#style' @() -Force
}


# Several parts of <style> come from properties.
# This will apply these properties before applying any custom styles

# These include:
# * `.Keyframe`
$keyframe = $this.Keyframe
# * `.Variable`
$myVariables = $this.Variable
# * `.Palette`
$palette = $this.Palette

if ($palette) {
    filter GetLuma {
        $colorString = $_
        # Convert the background color to a uint32
        $rgb = ($colorString -replace "#", "0x" -replace ';') -as [int32]
                
        # Get each value as a percent:        
        $r = ([float][byte](($rgb -band 0xff0000) -shr 16)/255)
        $g = ([float][byte](($rgb -band 0x00ff00) -shr 8)/255)
        $b = ([float][byte]($rgb -band 0x0000ff)/255)
                            
        # Calculate the luma of the background color
        0.2126 * $R + 0.7152 * $G + 0.0722 * $B    
    } 
    
    $measureLumas = 
        @($palette.Values) -match '^#' | 
            GetLuma |
                Measure-Object -Minimum -Maximum -Average -StandardDeviation
    
}

# Variables can have any type
$cssTypePattern = '^(?<type>\<[\w-].+?\>)[\:\=]?'

$myCssVariables = @(    
    if ($palette) {
        # First up: palettes.
        foreach ($color in $palette.Keys) {
            # Declare a CSS property for each item in the palette.
            # Palettes (mostly) presume a type
            "@property --$($color -replace '^--'){ syntax: '$(            
                [Security.SecurityElement]::Escape($(            
                    if ($palette[$color] -match '^\s{0,}[''"]') {
                        '*'
                    } 
                    elseif ($palette[$color] -match '^\s{0,}\#[a-f0-9]+\s{0,}$') {
                        '<color>'
                    }
                    elseif ($palette[$color].GetType().IsPrimative) {
                        '<number>'
                    }
                    else {
                        '<color>'
                    } 
                ))
            )';initial-value: $(
                if ($palette[$color] -is [bool]) {
                    $palette[$color] -as [int]
                } else {
                    $palette[$color]
                }            
            );inherits:true}"
        }        
    }
    

    # Next up, actual variables.
    foreach ($variableKey in $myVariables.Keys -match '^--') {
        $variableValue = $myVariables[$variableKey]
        if ($variableValue -match $cssTypePattern) {
            $variableValue = $variableValue -replace $cssTypePattern
            "@property $variableKey { syntax: '$(
                [Security.SecurityElement]::Escape($matches.type)
            )';initial-value:$($variableValue -replace $cssTypePattern)}"
        }
        "$variableKey",':', $variableValue -join ''
    }
)

$styleElementParts = @(
if ($palette) {              
    ":root {"        
        "  color-scheme: $(
            if ($measureLumas.Maximum -ge 0.4) { 'light' }
        ) $(
            if ($measureLumas.Minimum -lt 0.4) { 'dark' }
        );"

        # Declare palette variables explicitly, 
        # in case `syntax: '<color>'` was unrecognized.
        foreach ($color in $palette.Keys) {
            "  --$($color -replace '^--'): $($palette[$color]);"
        }
    "}"
}
if ($myCssVariables) {
    $myCssVariables -join (';' + [Environment]::NewLine)
}

foreach ($keyframeName in $keyframe.Keys) {
    $keyframeKeyframes = $keyframe[$keyframeName]
    "@keyframes $keyframeName {"
    foreach ($percent in $keyframeKeyframes.Keys) {
        "  $percent {"
        $props = $keyframeKeyframes[$percent]
        foreach ($prop in $props.Keys) {
            $value = $props.$prop
            "    ${prop}: $value;"
        }
        "  }"
    }
    "}"
    ".$keyframeName {"
    "    animation-name: $keyframeName;"
    "    animation-duration: $($this.Duration.TotalSeconds)s;"
    "    animation-iteration-count: infinite;"
    "}"
}
if ($this.'#Style') {
    "$($this.'#Style' -join (';' + [Environment]::NewLine))"
}
) 

if ($styleElementParts) {
    # Style elements are one of the only places where we can be reasonably certain there will not be child elements
    try {
        # so if we have an error with unescaped content
        return [xml]@("<style>"
            ($styleElementParts -join [Environment]::NewLine -replace '\};','}')
        "</style>")    
    } catch {
        # catch it and escape the content
        return [xml]@(
            "<style>"
                [Security.SecurityElement]::Escape(
                    ($styleElementParts -join [Environment]::NewLine -replace '\};','}')
                )
            "</style>"
        )
    }
} else {
    return ''
}

return $this.'#Style'