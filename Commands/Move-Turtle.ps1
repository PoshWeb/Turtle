function Move-Turtle {
    <#
    .SYNOPSIS
        Moves a turtle.
    .DESCRIPTION        
        Moves a turtle by invoking a method with any number of arguments.

        This represents a single movement of the turtle.

        To move the turtle multiple times in one command, use `Get-Turtle`.
    .EXAMPLE
        New-Turtle | 
            Move-Turtle Forward 10 |
            Move-Turtle Right 90 |
            Move-Turtle Forward 10 |
            Move-Turtle Right 90 |
            Move-Turtle Forward 10 |
            Move-Turtle Right 90 |
            Move-Turtle Forward 10 |
            Move-Turtle Right 90 |
            Save-Turtle "./Square.svg"
    .LINK
        Get-Turtle
    .LINK
        Set-Turtle
    #>
    [CmdletBinding(PositionalBinding=$false)]
    param(
    # The method used to move the turtle.
    # Any method on the turtle can be called this way.
    [Parameter(Position=1,ValueFromPipelineByPropertyName)]
    [ArgumentCompleter({
        param ( $commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters )
        if (-not $script:TurtleTypeData) {
            $script:TurtleTypeData = Get-TypeData -TypeName Turtle
        } 
        $methodNames = @(foreach ($memberName in $script:TurtleTypeData.Members.Keys) {
            if ($script:TurtleTypeData.Members[$memberName] -is
                [Management.Automation.Runspaces.ScriptMethodData]) {
                $memberName
            }
        })
                
        if ($wordToComplete) {
            return $methodNames -like "$wordToComplete*"
        } else {
            return $methodNames
        }
    })]
    [string]
    $Method = 'Forward',

    # The arguments to pass to the method.
    [Parameter(ValueFromRemainingArguments,ValueFromPipelineByPropertyName)]
    [PSObject[]]
    $ArgumentList = 1,

    # The turtle input object.
    # If not provided, a new turtle will be created.
    [Parameter(ValueFromPipeline)]
    [PSObject]
    $InputObject
    )

    process {
        if (-not $PSBoundParameters.InputObject) {            
            $InputObject = $PSBoundParameters['InputObject'] = [PSCustomObject]@{PSTypeName='Turtle'}            
        }        
        
        $inputMethod = $inputObject.psobject.Methods[$method]
        if (-not $inputMethod) {
            Write-Error "Method '$method' not found on Turtle object."
            return
        }
        
        if ($inputMethod.Script) {
            $this = $InputObject
            & $inputMethod.Script @ArgumentList
        }        
    }
}
