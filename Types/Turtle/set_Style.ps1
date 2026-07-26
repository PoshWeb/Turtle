<#
.SYNOPSIS
    Sets a Turtle's Style
.DESCRIPTION
    Sets any CSS styles associated with the Turtle.

    These styles will be declared in a `<style>` element, just beneath a Turtle's `<svg>`
.EXAMPLE
    turtle style '.myClass { color: #4488ff}' style
.EXAMPLE
    turtle style abc
.EXAMPLE
    turtle style "@import url('https://fonts.googleapis.com/css?family=Abel')" text 'Hello World' textattribute @{
        'font-family'='Abel';'font-size'='3em'
    } fill 'red'
#>
param(
[PSObject[]]
$Style
)

filter toCss {
    # Capture the input,
    $in = $_    
    # know myself,
    $mySelf = $MyInvocation.MyCommand.ScriptBlock
    # and determine our depth
    $depth = 0
    # (with a little callstack peeking).    
    foreach ($frame in Get-PSCallStack) {
        if ($frame.InvocationInfo.MyCommand.ScriptBlock -eq $mySelf) {
            $depth++
        }
    }
    # Always substract one so we don't indent the root.
    $depth--
    
    if ($in -is [string]) {
        $in # Directly output strings
    } elseif ($in -is [Collections.IDictionary]) {
        # Join dictionaries by semicolons and indentation
        ($in.GetEnumerator() | & $mySelf) -join (
            ';' + [Environment]::NewLine + (' ' * 2 * $depth)
        )
    } elseif ($in.Key -and $in.Value) {
        # Key/value pairs containing dictionaries
        if ($in.Value -is [Collections.IDictionary]) {
            # become `selector { rules }`
            (
                "$($in.Key) {", (
                    (' ' * 2) + ($in.Value | & $mySelf)
                ) -join (
                    [Environment]::NewLine + (' ' * 2 * $depth)
                )
            ) + (
                    [Environment]::NewLine + (' ' * 2 * ($depth - 1))
            ) + '}'
        } 
        elseif ($in.Value -is [TimeSpan]) {
            "$($in.Key):$($in.Value.TotalSeconds)s"
        }
        else {
            # Other key/value pairs are placed inline
            "$($in.Key):$($in.Value)"
        }
    }     
    elseif ($in -is [PSObject]) {
        # turn non-dictionaries into dictionaries
        $inDictionary = [Ordered]@{}
        foreach ($property in $in.psobject.properties) {
            $inDictionary[$property.Name] = $in.($property.Name)
        }
        if ($inDictionary.Count) {
            # and recurse.
            $inDictionary | & $mySelf
        }
    }
}

if (-not $this.'#Style') {
    $this | Add-Member NoteProperty '#Style' @() -Force 
}
$this.'#Style' += $style |toCss

