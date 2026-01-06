<#
.SYNOPSIS
    Draws a pie graph using turtle graphics.
.DESCRIPTION
    This script uses turtle graphics to draw a pie graph based on the provided data.
.EXAMPLE
    turtle PieGraph 400 80 20 save ./80-20.svg
.EXAMPLE
    turtle PieGraph 400 5 10 15 20 15 10 5 | Save-Turtle ./PieGraph.svg
.EXAMPLE
    turtle PieGraph 400 @{value=20;fill='red'} @{value=40;fill='blue'} save ./PieGraphColor.svg   
.EXAMPLE
    turtle PieGraph 400 @(
        5,10,15,20,15,10,5 | Sort-Object -Descending
    ) | Save-Turtle ./PieGraphDescending.svg
.EXAMPLE
    turtle rotate (Get-Random -Max 360) PieGraph 400 @(
        5,10,15,20,15,10,5 | Sort-Object -Descending
    ) | Save-Turtle ./PieGraphDescendingRotated.svg
.EXAMPLE
    turtle PieGraph 200 (
        @(1..50) | 
            Get-Random -Count (Get-Random -Minimum 5 -Maximum 20)
    ) save ./RandomPieGraph.svg
.EXAMPLE
    turtle rotate -90 piegraph 100 @(
        $allTokens = Get-Module Turtle |
            Split-Path |
            Get-ChildItem -Filter *.ps1 | 
            Foreach-Object { 
                [Management.Automation.PSParser]::Tokenize(
                    (Get-Content -Path $_.FullName -Raw), [ref]$null
                )
            }
        $allTokens |
            Group-Object Type -NoElement | 
            Sort-Object Count -Descending |
            Add-Member ScriptProperty Fill {
                "#{0:x6}" -f (Get-Random -Maximum 0xffffff)
            } -Force -PassThru |
             Add-Member ScriptProperty Link {
                "https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.pstokentype?view=powershellsdk-7.4.0#system-management-automation-pstokentype-$($this.Name.ToLower())"
            } -Force -PassThru
        
    ) save ./TurtlePSTokenCountPieGraph.svg
.EXAMPLE
    turtle rotate -90 piegraph 100 @(
        $allTokens = Get-Module Turtle |
            Split-Path |
            Get-ChildItem -Filter *.ps1 | 
            Foreach-Object { 
                [Management.Automation.PSParser]::Tokenize(
                    (Get-Content -Path $_.FullName -Raw), [ref]$null
                )
            }
        $allTokens |
            Group-Object Type |
            Select-Object Name, @{
                Name='TotalLength'
                Expression = {
                    $total = 0
                    foreach ($item in $_.Group) {
                        $total+=$item.Length
                    }
                    $total
                }
            } | 
            Sort-Object TotalLength -Descending |
            Add-Member ScriptProperty Fill {
                "#{0:x6}" -f (Get-Random -Maximum 0xffffff)
            } -Force -PassThru |
             Add-Member ScriptProperty Link {
                "https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.pstokentype?view=powershellsdk-7.4.0#system-management-automation-pstokentype-$($this.Name.ToLower())"
            } -Force -PassThru
        
    ) save ./TurtlePSTokenLengthPieGraph.svg
.EXAMPLE
    turtle rotate -90 piegraph 100 @(
        $allTypes = Get-Module Turtle |
            Split-Path |
            Get-ChildItem -Filter *.ps1 | 
            Get-Command -Name { $_.FullName } |
            Foreach-Object { 
                $_.ScriptBlock.Ast.FindAll({
                    param($ast)
                    $ast -is [Management.Automation.Language.TypeExpressionAst]
                }, $true)
            } |
            Foreach-Object {
                $_.Extent -replace '^\[' -replace '\]$' -as [type]
            }
        $allTypes |
            Group-Object FullName | 
            Sort-Object Count -Descending |
            Add-Member ScriptProperty Fill {
                "#{0:x6}" -f (Get-Random -Maximum 0xffffff)
            } -Force -PassThru |
            Add-Member ScriptProperty Title {
                $this.Name
            } -Force -PassThru |
            Add-Member ScriptProperty Link {
                "https://learn.microsoft.com/en-us/dotnet/api/$($this.Name.ToLower())?wt.mc_id=MVP_321542"
            } -Force -PassThru
    ) save ./TurtleDotNetTypesPieGraph.svg
.EXAMPLE
    $n = Get-Random -Min 5 -Max 10
    turtle width 200 height 200 morph @(
        turtle PieGraph 200 200 @(1..50 | Get-Random -Count $n)
        turtle PieGraph 200 200 @(1..50 | Get-Random -Count $n)
        turtle PieGraph 200 200 @(1..50 | Get-Random -Count $n)
    ) save ./RandomPieGraphMorph.svg
.EXAMPLE
    turtle PieGraph 200 (
        @(1..50;-1..-50) | 
            Get-Random -Count (Get-Random -Minimum 5 -Maximum 20)
    ) save ./RandomPieGraphWithNegative.svg
.EXAMPLE
    $randomNegativePie = turtle PieGraph 200 (
            @(1..50;-1..-50) | 
                Get-Random -Count 10
        )
    turtle viewbox 200 morph @(
        $randomNegativePie
        turtle PieGraph 200 200 (
            @(1..50;-1..-50) | 
                Get-Random -Count 10
        )
        $randomNegativePie
    ) save ./RandomPieGraphWithNegativeMorph.svg
.EXAMPLE
    # Multiple pie graphs
    turtle PieGraph 400 (1,2,4,8,4,2,1) jump 800 rotate 180 PieGraph 400 (1,2,4,8,4,2,1) save ./pg.svg
#>
param(
# The radius of the bar graph
[double]$Radius,

# The points in the bar graph.  
# Each point will be turned into a relative number and turned into an equal-width bar.
[Parameter(ValueFromRemainingArguments)]
[PSObject[]]
$GraphData
)


if (-not $radius) {
    $radius = Get-Random -Min 42 -Max 84    
}

# If there were no points, draw a random number of slices
if (-not $GraphData) {
    $GraphData = foreach ($n in Get-Random -min 3 -max 12) {
        Get-Random -Max 42
    }
}

filter IsPrimitive {$_.GetType -and $_.GetType().IsPrimitive}

# To make a pie graph we need to know the total, and thus we need to make a couple of passes
[double]$Total = 0.0

$sliceObjects = [Ordered]@{}
$richSlices = $false
$Slices = @(
    $dataPointIndex = 0
    foreach ($dataPoint in $GraphData)
    {        
        # If the data point is a number (or other primitive data)
        if ($dataPoint | IsPrimitive)
        {
            $Total += $dataPoint # add it to the total
            $dataPoint -as [double] # and output it
            $sliceObjects["slice$($sliceObjects.Count)"] = $dataPoint
        }
        # Otherwise, if the data point has a value that is a number
        elseif ($dataPoint.value | IsPrimitive)
        {            
            $Total += $dataPoint.value # add it to the total
            $dataPoint.value -as [double] # and output that
            $richSlices = $true
            $sliceObjects["slice$($sliceObjects.Count)"] = $dataPoint
        }
        elseif ($dataPoint -is [Collections.IDictionary]) {
            foreach ($key in $dataPoint.Keys) {
                if ($dataPoint[$key] | IsPrimitive) {
                    $Total += $dataPoint[$key] # add it to the total
                    $dataPoint[$key] -as [double] # and output that
                    $sliceObjects["slice$($sliceObjects.Count)"] = $dataPoint[$key]
                }
            }
            
            $richSlices = $true
        }
        elseif ($DataPoint -is 'Microsoft.PowerShell.Commands.GroupInfo') {
            $total += $dataPoint.Count
            $dataPoint.Count
            $sliceObjects["slice$($sliceObjects.Count)"] = $dataPoint
            $richSlices = $true
        }
        elseif ($dataPoint -isnot [string]) {
            foreach ($prop in $dataPoint.psobject.properties) {
                if ($dataPoint.($prop.Name) | IsPrimitive) {
                    $Total += $dataPoint.($prop.Name) # add it to the total
                    $dataPoint.($prop.Name) -as [double] # and output that
                    $sliceObjects["slice$($sliceObjects.Count)"] = $dataPoint
                }
            }
            $richSlices = $true
        }
    }
)

if ($Slices.Length -eq 1 -and -not $richSlices) {

    # If we provide a single number, we will auto-slice the pie
    # If the number is between 0 and 1, we want to show a fraction
    if ($slices[0] -ge 0 -and $slices[0] -le 1) {        
        # Set the total to one
        $total = 1
        # and make two pie slices.
        $slices = $slices[0], (1- $slices[0])
    } else {
        # Otherwise, we want mostly equal pie slices
        # (mostly is in case of a decimal value)
        # Get the floor of our slice,
        $floor = [Math]::Floor($slices[0])
        # and determine the remainder.
        $remainder = $slices[0] - $floor
        # Then create N equal slices.
        $Slices = @(,1 * $floor)
        # If there was a remainder
        if ($remainder) {
            # create a small slice.
            $slices += $remainder
        }
        # Retotal our pie
        $total = 0.0
        foreach ($slice in $slices) {
            $total += $slice
        }        
    }    
}

# Turn each numeric slice into a ratio
$relativeSlices =
    foreach ($slice in $Slices) { $slice/ $total }

# If we have no ratios, we have nothing to graph, and we are done here.
if (-not $relativeSlices) { return $this }

# Next let's figure out the maximum delta x and delta y
$dx = $this.X + $Radius
$dy = $this.Y + $Radius
# and resize our viewbox with respect to our radius
$null = $this.ResizeViewBox($Radius)

# If we are not rendering "rich" slices, we can draw the arcs as one path
if (-not $richSlices) {
    # and we do not need to teleport
    for ($sliceNumber =0 ; $sliceNumber -lt $Slices.Length; $sliceNumber++) {
        # Turn each ratio into an angle        
        $Angle = $relativeSlices[$sliceNumber] * 360        
        $this = $this. 
                # Draw an arc of that angle,
                CircleArc($Radius, $Angle).
                # then rotate by the angle.
                Rotate($angle)
    }
}
else {
    # Otherwise, we are making multiple turtles    
    $nestedTurtles = [Ordered]@{}
    # The idea is the same, but the implementation is more complicated
    $heading = $this.Heading
    if (-not $heading) { $heading = 0.0 }    
    # Calulate the midpoint of the circle
    for ($sliceNumber =0 ; $sliceNumber -lt $Slices.Length; $sliceNumber++) {
        $Angle = $relativeSlices[$sliceNumber] * 360
        $sliceName = "slice$sliceNumber"
        # created a nested turtle at the midpoint
        $nestedTurtles["slice$sliceNumber"] = turtle start $dx $dy
        # with the current heading
        $nestedTurtles["slice$sliceNumber"].Heading = $this.Heading
        # and arc by the angle
        $null = $nestedTurtles["slice$sliceNumber"].CircleArc($Radius, $Angle)

        # If the slice was of a dictionary
        if ($sliceObjects[$sliceName] -is [Collections.IDictionary])
        {
            # set any settable properties on the turtle
            foreach ($key in $sliceObjects[$sliceName].Keys) {
                # that exist in both the turtle and the dictionary
                if ($nestedTurtles[$sliceName].psobject.properties[$key].SetterScript) {
                    $nestedTurtles[$sliceName].$key = $sliceObjects[$sliceName][$key]
                }
            }
        }
        # If the slice was not a string
        elseif ($sliceObjects[$sliceName] -isnot [string])
        {
            # Set any settable properties on the turlte
            foreach ($key in $sliceObjects[$sliceName].psobject.properties.Name) {
                # that exist in both the turtle and the slice object.
                if ($nestedTurtles[$sliceName].psobject.properties[$key].SetterScript) {
                    $nestedTurtles[$sliceName].$key = $sliceObjects[$sliceName].$key
                }
            }
        }
        
        # Now rotate our own heading, even though we are not drawing anything.
        $null = $this.Rotate($angle)
    }
    # and set our nested turtles.
    $this.Turtles = $nestedTurtles
    # $null = $this.ResizeViewBox($Radius)
}
 
return $this