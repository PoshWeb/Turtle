<#
.SYNOPSIS
    Preview Turtle
.DESCRIPTION
    Generates a preview build of the Turtle website
#>
if (-not (Test-Path "./psturtle.com")) {
    throw "Website note found"
}

Push-Location ./psturtle.com
. .\build.ps1
Pop-Location
