<#
.SYNOPSIS
    A Brief History of Turtles
.DESCRIPTION
    A Brief History of Turtles, Robots, Graphics, and Technology
.NOTES
    ## A Brief History of Turtles

    The following is a brief and humorous introduction to Turtles, Turtle Robots, Turtle Graphics, vector motion, 
    and their long-term impact upon technology and the world around us.

    It is infused with personal opinion and attempts at light humor.  Please be kind.
#>
param()

$myHelp = Get-Help $MyInvocation.MyCommand.ScriptBlock.File

$title          = $myHelp.Synopsis
$description    = $myHelp.Description.text -join [Environment]::NewLine
$myNotes        = $myHelp.Notes.alertset.alert.text -join [Environment]::NewLine

if ($page -is [Collections.IDictionary]) {
    $page.Title = $title
    $page.Description = $description
}

if ($PSScriptRoot) { Push-Location $PSScriptRoot }

ConvertFrom-Markdown -InputObject @"

$myNotes

$(
    @(
        Get-ChildItem -Path ./History -Filter Turtles-*.md |
            Where-Object { $_.Name -match '-\d.md$'} |
            Get-Content -Raw
    ) -join (
        ([Environment]::NewLine * 2) + '---' + ([Environment]::NewLine * 2)
    )
)

"@ | Select-Object -ExpandProperty HTML

if ($PSScriptRoot) { Pop-Location }