<#
.SYNOPSIS
    Sets a Turtle's Markdown
.DESCRIPTION
    Sets the Markdown property of a Turtle.
#>
param()

$unrolledArgs = @($args | . { process { $_ } })
if (-not $this) { $this = turtle }
$this | Add-Member NoteProperty '#Markdown' $unrolledArgs -Force
