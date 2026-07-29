function Save-Turtle {
    <#
    .SYNOPSIS
        Saves a turtle.
    .DESCRIPTION
        Saves Turtle graphics to a file.
    .EXAMPLE
        turtle SierpinskiTriangle 42 4 |
            Save-Turtle ./SierpinskiTriangle-42-4.svg
    .EXAMPLE
        # We can save a turtle as a pattern by using `-Property Pattern`
        turtle Flower 42 |
            Save-Turtle ./Flower-42.svg -Property Pattern
    .EXAMPLE
        # We can also save a turtle as a pattern by naming the file with `Pattern` in it.
        turtle Flower 42 10 6 36 |
            Save-Turtle ./HexFlowerPattern.svg
    .EXAMPLE
        Move-Turtle BoxFractal 15 5 |
            Set-Turtle Stroke '#4488ff' |
            Save-Turtle ./BoxFractal.png
    #>
    param(
    # The file path to save the turtle graphics pattern.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Path')]
    [string]
    $FilePath,

    # The property of the turtle to save.
    [ArgumentCompleter({
        param ( $commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters )        
        $turtleType = Get-TypeData -TypeName Turtle
        $propertyNames = @(foreach ($memberName in $turtleType.Members.Keys) {
            if ($turtleType.Members[$memberName] -is [System.Management.Automation.Runspaces.ScriptPropertyData]) {
                $memberName
            }
        })
                
        if ($wordToComplete) {
            return $propertyNames -like "$wordToComplete*"            
        } else {
            return $propertyNames
        }
    })]
    [string]
    $Property = 'SVG',

    # The turtle input object.
    [Parameter(ValueFromPipeline)]
    [Alias('Turtle')]
    [PSObject]
    $InputObject
    )

    process {
        # If there is no input, return
        if (-not $inputObject) { return }
        
        # Auto detect property names from file names
        $defaultToProperty =
            switch -regex ($FilePath) {
                '\.(?>markdown|md)$' { 'Markdown' }
                '\.(?>html|xml)$' { 'Element' }
                '\.css$' { 'CSS' }
                '\.png$' { 'PNG' } 
                '\.jpe?g$' { 'JPEG' }
                '\.webp$' { 'WEBP' }
                'PatternMask' { 'PatternMask'; break }
                'Mask' { 'Mask'; break }
                'Pattern' { 'Pattern'; break }
                'Symbol' { 'Symbol'; break }
                default { 'SVG' }
            }

        # If we have not provided a property and we know of a viable default, use that
        if ($defaultToProperty -and -not $PSBoundParameters['Property']) {
            $property = $PSBoundParameters['Property'] = $defaultToProperty
        }        
        
        # Get the value of our property
        $toExport = $inputObject.$Property        
        
        # If there is nothing there, return
        if (-not $toExport) { return }

        # Find the file path
        $unresolvedPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($FilePath)
        # and create a file
        $null = New-Item -ItemType File -Force -Path $unresolvedPath
        # If we are exporting XML
        if ($toExport -is [xml])
        {
            # save it to that path
            $toExport.Save("$unresolvedPath")
        }
        # If we are outputting bytes
        elseif ($toExport -is [byte[]])
        {
            # write them to the file
            [IO.File]::WriteAllBytes("$unresolvedPath", $toExport)            
        }
        # If we are outputting anything else
        else
        {
            # simply redirect to the file
            $toExport > $unresolvedPath
        }

        # If the last command worked
        if ($?) {
            # return the file
            return (Get-Item -Path $unresolvedPath)
        }
    }
}
