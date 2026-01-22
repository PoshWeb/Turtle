<#
.SYNOPSIS
    Sets a Turtle's stroke color
.DESCRIPTION
    Sets one or more colors used to stroke the Turtle.    

    By default, this is transparent.

    If more than one value is provided, the stroke will be a gradient.
.EXAMPLE
    # Draw a blue square
    turtle square 42 stroke blue 
.EXAMPLE
    # Draw a PowerShell blue square
    turtle square 42 stroke '#4488ff'
.EXAMPLE
    # Draw a red, green, blue gradient
    turtle square 42 stroke red green blue show
.EXAMPLE
    # Draw a red, green, blue linear gradient
    turtle square 42 stroke red green blue linear show
.EXAMPLE
    turtle flower stroke red green blue strokerule evenodd show         
#>
param(
[PSObject[]]
$stroke = 'transparent'
)

# If we have no stroke information, return
if (-not $stroke) { return }

# If the stroke count is greater than one, try to make a graidnet
if ($stroke.Count -gt 1) {

    # Default to a radial gradient
    $gradientTypeHint = 'radial'
    # and create a collection for attributes
    $gradientAttributes = [Ordered]@{
        # default our identifier to the current id plus `stroke-gradient`
        # (so we could have multiple gradients without a collision)
        id="$($this.id)-stroke-gradient"
    }

    $stroke = @(foreach ($color in $stroke) {
        # If the value matches `linear` or `radial`
        if ($color -match '^(linear|radial)') {
            # take the hint and make it the right type of gradient.
            $gradientTypeHint = ($color -replace 'gradient').ToLower()
        }
        # If the color was `pad`, `reflect`, or `repeat`
        elseif ($Color -in 'pad', 'reflect', 'repeat') {
            # take the hint and set the spreadMethod
            $gradientAttributes['spreadMethod'] = $color
        }
        # If the color matched '^ra?n(?>dom|d|g)?'
        elseif ($color -match '^ra?n(?>dom|d|g)?') {
            # output the color
            "#{0:x6}" -f (Get-Random -max 0xffffff)
        }
        # If the stroke is a dictionary
        elseif ($color -is [Collections.IDictionary]) {
            # propagate the values into attributes.
            foreach ($gradientAttributeKey in $color.Keys) {
                $gradientAttributes[$gradientAttributeKey] = $color[$gradientAttributeKey]
            }
        }
        # Otherwise output the color
        else {
            $color
        }
    })
        
    # If we have no stroke colors after filtering, return
    if (-not $stroke) { return }    

    # If our count is one
    if ($stroke.Count -eq 1) {
        # it's not really going to be a gradient, so just use the one color.
        $this | Add-Member -MemberType NoteProperty -Name '.Stroke' -Value $stroke -Force
        return    
    }

    # Now we have at least two colors we want to be a gradient
    # We need to make sure the offset starts at 0% an ends at 100%
    # and so we actually need to divide by one less than our stroke color, so we end at 100%.
    $offsetStep = 1 / ($stroke.Count - 1)
    $gradientAttributes.id = 
        # default our identifier to the current id plus `stroke-gradient`
        # (so we could have multiple gradients without a collision)
        "$($this.id)-stroke-gradient-$($stroke -replace '^#' -replace '[\(\)\s]' -join '-')" 
    $Gradient = @(
        # Construct our gradient element.
        "<${gradientTypeHint}Gradient$(
            # propagate our attributes
            @(foreach ($gradientAttributeKey in $gradientAttributes.Keys) {
                " $gradientAttributeKey='$($gradientAttributes[$gradientAttributeKey])'"
            }) -join ''
        )>"
        @(
            # and put in our stop colors
            for ($strokeNumber = 0; $strokeNumber -lt $stroke.Count; $strokeNumber++) {
                "<stop offset='$($offsetStep * $strokeNumber * 100)%' stop-color='$($stroke[$strokeNumber])' />"
            }
        )        
        "</${gradientTypeHint}Gradient>"
    ) -join [Environment]::NewLine

    # add this gradient to our defines
    $this.Defines += $Gradient
    # and set stroke to this gradient.
    $stroke = "url(`"#$($gradientAttributes.id)`")"
}
if (-not $this.'.stroke') {
    $this | Add-Member -MemberType NoteProperty -Name '.Stroke' -Value $stroke -Force
} else {
    $this.'.stroke' = $stroke
}

if (($this.'.stroke' -notmatch '(?>currentColor|context)')) {
    $this.PathClass = @($this.PathClass) -ne 'foreground-stroke'
}