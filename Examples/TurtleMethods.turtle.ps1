<#
.SYNOPSIS
    Turtle Methods
.DESCRIPTION
    Gets all the Turtle Methods.

    These describe moves the Turtle can make.
#>

$td = Get-TypeData -TypeName Turtle

if ($PSScriptRoot) { 
    Push-Location $PSScriptRoot

}

$table = @(
    '# Turtle Methods'

    'Every Move the Turtle can make'
    
    ''    

    "|name|"
    "|-|"
    $td.Members.Values | 
        Where-Object {
            $_ -is [Management.Automation.Runspaces.ScriptMethodData]
        } |         
        Sort-Object Name |
        Foreach-Object {
            $in = $_
            $description = if ($in.Script -match '(?m)^.\DESCRIPTION') {                
                $null, $description = $in.Script -replace '[\s\S]+(?m)^.\DESCRIPTION' -split '^(m)^\.', 2

            } else {
                ''
            }
            "|$($_.Name)|"
        }
)

🐢 markdown $table | 
    Save-Turtle ./TurtleMethods.md

if ($PSScriptRoot) {
    Pop-Location
}