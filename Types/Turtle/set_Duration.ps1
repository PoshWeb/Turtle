<#
.SYNOPSIS
    Sets the duration
.DESCRIPTION
    Sets the default duration used for morphs and other animations.
#>
param(
# The value to set
$value
)

foreach ($v in $value) {
    if ($v -is [double] -or $v -is [int]) {
        $this | Add-Member NoteProperty '.Duration' ([TimeSpan]::FromSeconds($v)) -Force
    } elseif ($v -as [TimeSpan]) {
        $this | Add-Member NoteProperty '.Duration' ($v -as [Timespan]) -Force
    } else {
        Write-Warning "'$Value' is not a number or timespan"
    }
}

if (($this.'.Duration' -is [TimeSpan]) -and $this.PathAnimation) {    
    foreach ($animationXML in $this.PathAnimation) {
        $animationXML = $animationXML -as [xml]
        if (-not $animationXML) { continue }
        if ($animationXML.animate.attributeName -eq 'd') {
            $animationXML.animate.dur = "$(($this.'.Duration').TotalSeconds)s"
        }
    }    
}