<#
.SYNOPSIS
    Simple palette example
.DESCRIPTION
    Creates a single color page using a palette.
#>
🐢 palette @{'blue' = '#4488ff'} style @{
    'body' = @{
        'background-color' =  'var(--blue)'
    }
} | Save-Turtle ./SimplePalette.html