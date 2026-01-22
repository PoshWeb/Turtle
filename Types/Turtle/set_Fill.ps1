<#
.SYNOPSIS
    Sets a Turtle's fill color
.DESCRIPTION
    Sets one or more colors used to fill the Turtle.    

    By default, this is transparent.

    If more than one value is provided, the fill will be a gradient.
.EXAMPLE
    # Draw a blue square
    turtle square 42 fill blue 
.EXAMPLE
    # Draw a PowerShell blue square
    turtle square 42 fill '#4488ff'
.EXAMPLE
    # Draw a red, green, blue gradient
    turtle square 42 fill red green blue show
.EXAMPLE
    # Draw a red, green, blue linear gradient
    turtle square 42 fill red green blue linear show
.EXAMPLE
    turtle flower fill red green blue fillrule evenodd show         
#>
param(
[PSObject[]]
$Fill = 'transparent'
)

# If we have no fill information, return
if (-not $fill) { return }

# If the fill count is greater than one, try to make a graidnet
if ($fill.Count -gt 1) {

    # Default to a radial gradient
    $gradientTypeHint = 'radial'
    # and create a collection for attributes
    $gradientAttributes = [Ordered]@{
        # default our identifier to the current id plus `fill-gradient`
        # (so we could have multiple gradients without a collision)
        id="$($this.id)-fill-gradient"
    }

    $fill = @(foreach ($color in $fill) {
        # If the value matches `linear` or `radial` 
        if ($color -match '^(linear|radial)') {
            # take the hint and make it the right type of gradient.
            $gradientTypeHint = ($color -replace 'gradient').ToLower()
        }
        # If the color was `pad`, `reflect`, or `repeat`
        elseif ($color -in 'pad', 'reflect', 'repeat') {
            # take the hint and set the spreadMethod
            $gradientAttributes['spreadMethod'] = $color
        }
        # If the color matched '^ra?n(?>dom|d|g)?'
        elseif ($color -match '^ra?n(?>dom|d|g)?') {
            # output the color
            "#{0:x6}" -f (Get-Random -max 0xffffff)
        }
        # If the fill is a dictionary
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
        
    # If we have no fill colors after filtering, return
    if (-not $fill) { return }

    # If our count is one
    if ($fill.Count -eq 1) {
        # it's not really going to be a gradient, so just use the one color.
        $this | Add-Member -MemberType NoteProperty -Name '.Fill' -Value $Fill -Force
        return    
    }

    # Now we have at least two colors we want to be a gradient
    # We need to make sure the offset starts at 0% an ends at 100%
    # and so we actually need to divide by one less than our fill color, so we end at 100%.
    $offsetStep = 1 / ($fill.Count - 1)
    $gradientAttributes.id = 
        # default our identifier to the current id plus `fill-gradient`
        # (so we could have multiple gradients without a collision)
        "$($this.id)-fill-gradient-$($fill -replace '^#' -replace '[\(\)\s]' -join '-')" 
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
            for ($fillNumber = 0; $fillNumber -lt $fill.Count; $fillNumber++) {
                "<stop offset='$($offsetStep * $fillNumber * 100)%' stop-color='$($fill[$fillNumber])' />"
            }
        )        
        "</${gradientTypeHint}Gradient>"
    ) -join [Environment]::NewLine

    # add this gradient to our defines
    $this.Defines += $Gradient
    # and set fill to this gradient.
    $fill = "url(`"#$($gradientAttributes.id)`")"
}
if (-not $this.'.Fill') {
    $this | Add-Member -MemberType NoteProperty -Name '.Fill' -Value $Fill -Force
} else {
    $this.'.Fill' = $Fill
}