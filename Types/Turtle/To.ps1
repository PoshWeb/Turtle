<#
.SYNOPSIS
    To defines something for a Turtle to do.
.DESCRIPTION
    To defines a procedure any turtle can follow.
.NOTES
    To is a keyword that allows you to define a function in the original Logo language.

    There are two ways to define new "To" operations:

    * A List of Parameters and Commands
    * A PowerShell script

    Our Turtle is primarily extended by PowerShell, 
    but we still want anyone using Turtle to be able to define a new behavior.
.EXAMPLE
    turtle to [hexagon] :size 10 [ repeat 6 [ forward :size rotate 60 ] ] 
    turtle hexagon
.EXAMPLE
    turtle to [octogon] :size 10 [ repeat 8 [ forward :size rotate 45 ] ] 
    turtle octogon
.EXAMPLE
    turtle to [menu] {
        param() $this.Element ="<menu>$($args)</menu>"; return $this
    }
    turtle menu "<button>1</button>" "<button>2</button>" "<button>3</button>"
.EXAMPLE
    
#>
param()

# If there is no turtle, create one
if (-not $this) { 
    $this = turtle
}

# We need to determine the function name
$functionName = $null

# any any parameters it might have had
$toParameters = [Ordered]@{}

# To do this, collect all of our unrolled arguments,
$toArgs = @($args | . { process { $_ }})

# split off the first word,
$firstWord, $restOfWords = $toArgs
# and force all other words into an array.
$restOfWords = @($restOfWords)

# Debracket the first word
$toName = $firstWord -replace '^\[' -replace '\]$'

# and check for balance and script blocks
$bracketDepth = 0
$argsEnd = 0

# Go word-by word
for ($wordNumber = 0; $wordNumber -lt $restOfWords.Length; $wordNumber++) {
    $word = $restOfWords[$wordNumber]

    # If a word is a script block
    if ($restOfWords[$wordNumber] -is [ScriptBlock]) {
        # then it's a `To` defined in PowerShell.
        
        $simpleUpdate = @{
            TypeName = $this.pstypenames[0]
            Force = $true
            ErrorAction = 'Ignore'
            MemberName = $toName
            Value = $restOfWords[$wordNumber]
            MemberType = 'ScriptMethod'
        }

        # If we are using Turtle in data language mode, 
        # we will not be able to construct a script block.

        # If we _could_ define a ScriptBlock, we can just define a new action in Turtle         
        Update-TypeData @simpleUpdate

        return
    }


    # If the word is a string
    if ($word -is [string]) {
        # increment and decrement bracket depth
        $bracketDepth += ($word -replace '[^\[]').Length
        $bracketDepth -= ($word -replace '[^\]]').Length
        # and if we are at 1, mark the end of the args
        # (everything beyond this point should be a definition)
        if ($bracketDepth -eq 1) {            
            $argsEnd = $wordNumber - 1
        }
    }        
}

# If we were unbalanced,
if ($bracketDepth -ne 0) {
    throw "Unbalanced" # throw.
}

# Back over the arguments (this time, let's get our parameters)
for ($argNumber =0 ; $argNumber -lt $toArgs.Length; $argNumber++) {
    $arg = $toArgs[$argNumber]

    # skip non-string arguments
    if ($arg -isnot [string]) {
        continue
    }
    # if we haven't set a function name yet
    if (-not $functionName) {
        # strip brackets from the first argument
        $functionName = $arg -replace '[\[\]]'
        continue
    }
    
    # If the argument looks like a variable
    if ($arg -match '[\:\$]') {
        # split off a potential type and key
        $argKey, $argType = $arg -split '[\:\$]' -ne ''

        # look ahead for the next argument.
        # (this would be the default value)
        $nextArg = $toArgs[$argNumber + 1]
        
        # If the default value is a primitive
        if ($null -ne $nextArg -and 
            $nextArg.GetType().IsPrimitive
        ) {
            # make it a double.
            $toParameters[$arg -replace '^:', '$'] = $nextArg -as [double]
            $argNumber++
        }
        # Otherwise, take non-null defaults and save them 
        elseif ($null -ne $nextArg) {
            $toParameters[$arg -replace '^:', '$'] = $nextArg
        }
        # and make a null into a default parameter of zero.
        else {
            $toParameters[$arg -replace '^:', '$'] = 0
        }
        continue
    }        
    else {
        break
    }    
}

if (-not $functionName) {
    throw "no function name"
    return
}


# Any remaining arguments are our definition
$toDefinition = @($toArgs[$argNumber..($toArgs.Length - 1)])

# We just need to strip the first and last bracket (if present)
if ($toDefinition[0] -match '^\[') {
    $toDefinition = @(
        $toDefinition[0] -replace '^\['
        $toDefinition[1..$($toDefinition.Length)]
    ) -ne ''
}

if ($toDefinition[-1] -match '\]$') {
    $toDefinition = @(
        $toDefinition[0..$($toDefinition.Length - 2)]
        $toDefinition[-1] -replace '\]'        
    )
}


# Next up we want to create a script method to implement our `To`
# We want help to work, so we escape a number of pieces of information.
$psTypeName = $this.pstypenames[0] -replace "'","''"
$escapedMethodName = "'$($functionName -replace "'","''")'"
$escapedMethodComment = "$($functionName -replace '#>', '# >')"
$escapedParameters = foreach ($key in $toParameters.Keys) {
    "$($key -replace '\$',':' -replace '#>', '# >') $(
        $toParameters[$key]
    )"
}

# The scriptblock starts with some inline help
# and then hard-codes two pieces of information:
# * The `$methodName`
# * The `$psTypeName`
$scriptBlock = "
<#
.SYNOPSIS
    To $escapedMethodComment
.DESCRIPTION
    turtle to $escapedMethodComment $escapedParameters $($toDefinition -replace '#>', '# >')
.EXAMPLE
    turtle $escapedMethodName
#>
`$methodName = $escapedMethodName
`$psTypeName = '$psTypeName'
" + {
    # Every "To" actually does the same thing
    # It looks up a list of parameters in .ToDo
    $ToDo = $this.ToDo.$methodName
    $toParameters = $ToDo.Parameters
    # and tries to map any parameters
    $mappedParameters = [Ordered]@{} + $toParameters
    
    $argList = @($args)
    
    # For the moment, only positional parameters are supported.
    $unboundArgs = @(for ($argNumber = 0 ; $argNumber -lt $argList.Length; $argNumber++ ) {
        # So we simply look for the name of each parameter.
        $toParameterName = @($toParameters.Keys)[$argNumber] -replace '[\$\:]'
        # and if we found one
        if ($toParameterName) {
            # we map that parameter to the Nth argument.
            $mappedParameters[$toParameterName] = $argList[$argNumber]
        } else {
            break
        }
    })


    # Then we go look up the list of commands
    $commandList = @(foreach ($command in $ToDo.Commands) {        
        if ($command -is [string] -and 
            $command -match '^[\:\$]'
        ) {  
            $argName = $command -replace '[\:\$]'            
            if ($argName -eq 'args') {
                $argList
            }
            elseif ($mappedParameters.Contains("`$$argName")) {
                $mappedParameters["`$$argName"]
            } else {
                Write-Warning "Unknown variable $command"
            }            
        } else {
            $command
        }
    })

    $this.Go($commandList)    
}

if (-not $this.ToDo) {
    Update-TypeData -TypeName Turtle -MemberName ToDo -MemberType NoteProperty -Value ([Ordered]@{}) -Force
}

$this.ToDo.$functionName = [Ordered]@{
    Commands = $toDefinition
    Parameters = $toParameters
}

Update-TypeData -TypeName Turtle -MemberType ScriptMethod -MemberName $functionName -Force -Value ([ScriptBlock]::Create(
    $scriptBlock
))

return 
