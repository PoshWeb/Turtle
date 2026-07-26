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
    $this | Add-Member NoteProperty '#style' @() -Force
}

$keyframe = $this.Keyframe
$myVariables = $this.Variable
$cssTypePattern = '^(?<type>\<[\w-].+?\>)[\:\=]?'
$myCssVariables = foreach ($variableKey in $myVariables.Keys -match '^--') {
    $variableValue = $myVariables[$variableKey]            
    if ($variableValue -match $cssTypePattern) {
        $variableValue = $variableValue -replace $cssTypePattern
        "@property $variableKey { syntax: '$(
            [Security.SecurityElement]::Escape($matches.type)
        )'; initial-value: $($variableValue -replace $cssTypePattern)}"
    }
    "$variableKey",':', $variableValue -join ''
}
$styleElementParts = @(
if ($myCssVariables) {
    "#$($this.id)-path, #$($this.id)-text {"
        ($myCssVariables -join (';' + [Environment]::NewLine + (' ' * 4)))
    "}"            
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
        $styleElementParts -join [Environment]::NewLine -replace '\};','}'
        "</style>")    
    } catch {
        # catch it and escape the content
        return [xml]@(
            "<style>"
                [Security.SecurityElement]::Escape(
                    $styleElementParts -join [Environment]::NewLine -replace '\};','}'
                )
            "</style>"
        )
    }
} else {
    return ''
}

return $this.'#Style'