<#
.SYNOPSIS
    Turtle Properties
.DESCRIPTION
    Gets all the Turtle Properties.

    These control the Turtle's state.
#>

$td = Get-TypeData -TypeName Turtle

if ($PSScriptRoot) { 
    Push-Location $PSScriptRoot

}

$table = @(
    '# Turtle Properties'

    'Every Property of the Turtle'
    
    ''    

    "|name|CanRead|CanWrite|"
    "|-|-|-|"
    $td.Members.Values | 
        Where-Object {
            $_ -is [Management.Automation.Runspaces.ScriptPropertyData]
        } |         
        Sort-Object Name |
        Foreach-Object {            
            "|$($_.Name)|$(
                $($_.GetScriptBlock -as [bool])
            )|$(
                $($_.SetScriptBlock -as [bool])
            )|"
        }
)

🐢 markdown $table | 
    Save-Turtle ./TurtleProperties.md

if ($PSScriptRoot) {
    Pop-Location
}