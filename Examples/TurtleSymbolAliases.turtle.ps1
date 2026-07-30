<#
.SYNOPSIS
    Turtle Symbol Aliases
.DESCRIPTION
    Gets all the Turtle Symbol Aliases.

    These can be used in place of the corresponding method name.
.NOTES
    This information is collected into a simple markdown table.
#>

$td = Get-TypeData -TypeName Turtle

if ($PSScriptRoot) { 
    Push-Location $PSScriptRoot

}

$characterClasses = @(
    'S' # Symbol
    'IsHighSurrogates'
    'IsLowSurrogates'
    'IsVariationSelectors'
    'IsCombiningHalfMarks'
) -replace '^', '\p{' -replace '$','}' -join '' 

$table = @(
    "|symbol|method|"
    "|-|-|"
    $td.Members.Values | 
        Where-Object ReferencedMemberName | 
        Where-Object Name -Match "[$characterClasses]+" | 
        Sort-Object Name |
        Foreach-Object {
            "|$($_.Name)|$($_.ReferencedMemberName)|"
        }
)

🐢 markdown $table | 
    Save-Turtle ./TurtleSymbolAliases.md

if ($PSScriptRoot) {
    Pop-Location
}