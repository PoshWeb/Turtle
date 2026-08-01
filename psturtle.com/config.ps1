<#
.SYNOPSIS
    Configures the site
.DESCRIPTION
    Configures the site.  
    
    At the point this runs, a $Site dictionary should exist, and it should contain a list of files to build.

    Any *.json, *.psd1, or *.yaml files in the root should have already been loaded into the $Site dictionary.

    Any additional configuration or common initialization should be done here.
#>

param()

#region Core
if ($psScriptRoot) {Push-Location $psScriptRoot}
if (-not $Site) { $Site = [Ordered]@{} }
$parentFolderManifest =
    Get-ChildItem -File -Path .. |
    Where-Object Extension -eq .psd1 |
    Select-String 'ModuleVersion\s{0,}='

if ($parentFolderManifest) {
    $ImportedParentModule = Import-Module -Name ../ -PassThru -Global
    if ($ImportedParentModule) {
        $site.Module = $ImportedParentModule
    }
}

if ($psScriptRoot -and -not $site.PSScriptRoot) {
    $site.PSScriptRoot = $PSScriptRoot
}
#endregion Core

#region Exclude
if ($site.Exclude -isnot [Collections.IDictionary] ) {
    $site.Exclude = [Ordered]@{}
}
$site.Exclude.Wildcards = '*.functions.ps1', '*.function.ps1', '*.filters.ps1`', '*.filter.ps1', '*.turtle.ps1'
$site.Exclude.Patterns = 'build\\.[^\\.]+\\.ps1$'
#endregion Exclude

#region _
if ($site.PSScriptRoot) {
    $underbarItems = 
        Get-ChildItem -Path $site.PSScriptRoot -Filter '_*' -Recurse

    $underbarFileQueue = [Collections.Queue]::new()

    foreach ($underbarItem in $underbarItems) {
        $relativePath = $underbarItem.FullName.Substring($site.PSScriptRoot.Length + 1)
        if ($underbarItem -is [IO.FileInfo]) {
            $underbarFileQueue.Enqueue($underbarItem)
        }
        else {
            foreach ($childItem in $underbarItem.GetFileSystemInfos()) {
                if ($childItem -is [IO.FileInfo]) {
                    $underbarFileQueue.Enqueue($childItem)
                }
            }            
        }
    }

    foreach ($underbarFile in $underbarFileQueue.ToArray()) {
        $relativePath = $underbarFile.FullName.Substring($site.PSScriptRoot.Length + 1)
        $pointer = $site
        $hierarchy = @($relativePath -split '[\\/]')
        for ($index = 0; $index -lt ($hierarchy.Length - 1); $index++) {
            $subdirectory = $hierarchy[$index] -replace '_'
            if (-not $pointer[$subdirectory]) {
                $pointer[$subdirectory] = [Ordered]@{}
            }
            $pointer = $pointer[$subdirectory]
        }
                        
        $propertyName = $hierarchy[-1] -replace '\.ps1$'
        
        $getFile = @{LiteralPath=$underbarFile.FullName}
        $fileData  =
            switch -regex ($underbarFile.Extension) {
                '\.ps1$' {
                    if ($hierarchy -contains '_includes') {
                        Set-Alias "/_includes/$($underbarFile.Name -replace '\.ps1$')" $underbarFile.Fullname
                    }
                    $ExecutionContext.SessionState.InvokeCommand.GetCommand($underbarFile.FullName, 'ExternalScript')
                }
                '\.(css|html|txt)$' { Get-Content @getFile }
                '\.json$' { Get-Content @getFile | ConvertFrom-Json }
                '\.jsonl$' { Get-Content @getFile | ConvertFrom-Json }
                '\.psd1$' { Get-Content @getFile -Raw | ConvertFrom-StringData }
                '\.(?>ps1xml|xml|svg)$' { (Get-Content @getFile -Raw) -as [xml] }
                '\.(?>yaml|toml)$' { Get-Content @getFile -Raw }
                '\.csv$' { Import-Csv @getFile }
                '\.tsv$' { Import-Csv @getFile -Delimiter "`t" }
            }        
        if (-not $fileData) { continue }
        switch ($underbarFile.Extension) {
            .toml { RequireModule PSToml; $fileData = $fileData | ConvertFrom-Toml }
            .yaml { RequireModule YaYaml; $fileData = $fileData | ConvertFrom-Yaml }
        }

        if ($fileData) {
            $pointer[$propertyName] = $fileData
        }
    }
}
#region _

#region Site Metadata
$Site.Title = 'Turtle'
$Site.Description = 'Turtles in a PowerShell'
#endregion Site Metadata

#region Site Icons
$Site.Icon  = [Ordered]@{
    'BlueSky' = $site.includes.'BlueSky.svg'.OuterXml
    'GitHub' = . /_includes/FeatherIcon 'GitHub'
    'RSS' = . /_includes/FeatherIcon  'RSS'
    'Settings' = . /_includes/FeatherIcon  'Settings'
    'Help' = . /_includes/FeatherIcon 'Help-Circle'
}
#endregion Site Icons

#region Site Menus
$Site.Logo = 
    @(
        <#{             
            $flowerSides = 3..12 | Get-Random
            turtle Flower 42 (15,20,30,60,72 | Get-Random) $flowerSides 
        }
                
        {
            turtle SierpinskiTriangle 42 4
        }#>

        {
            turtle rotate -90 TurtleMonotile 42 pathclass foreground-fill foreground-stroke
        }

        {
            turtle rotate -90 TurtleMonotile 42 fill '#4488ff', '#224488' linear stroke '#224488' '#4488ff' linear
        }

        {
            turtle rotate -90 TurtleMonotile 42 fill '#224488' '#4488ff' linear stroke '#4488ff' '#224488' linear
        }

        {
            turtle rotate -90 TurtleMonotile 42 fill '#228844' '#448822' linear stroke '#448822' '#228844' linear
        }

        {
            turtle rotate -90 TurtleMonotile 42 fill '#448822' '#228844' linear  stroke '#228844' '#448822' linear
        }
    )

$site.Logo = . ($site.Logo | Get-Random)
$Site.Logo.ID = 'Turtle-Logo' 

<# $Site.Logo = $Site.Logo | Set-Turtle PathAnimation @{
    type = 'rotate'   ; values = 0, 360 ;repeatCount = 'indefinite'; dur = "31s"; additive = 'sum'; id ='rotate-logo'
} #>

$site.Taskbar = [Ordered]@{
    'BlueSky' = 'https://bsky.app/profile/psturtle.com'
    'GitHub' = 'https://github.com/PoshWeb/Turtle'
    'RSS' = 'https://psturtle.com/RSS/index.rss'
    'Help' = '/Commands/Get-Turtle'
}

$env:TURTLE_BOT = $true

$Site.Palette = "Andromeda"

#endregion Site Menus

#region Site Background

$doodle = @(
    'forward', 100,'right', 90 * 2
    'forward', 50,'right', 90 * 2
    'forward', 100,'right', 90
    'forward', 25, 'right', 90 * 2
    'forward', 50
)

# Randomizing site background a bit
$backgroundPatternAnimations = 
    [Ordered]@{
        type = 'scale'    ; values = 0.66,0.33, 0.66 ; repeatCount = 'indefinite' ;dur = "337s"; additive = 'sum';id ='scale-pattern'
    }, [Ordered]@{
        type = 'rotate'   ; values = 0, 360 ;repeatCount = 'indefinite'; dur = "523s"; additive = 'sum'; id ='rotate-pattern'
    }

$sitebackgrounds = @(

    {turtle Flower 84 60 6}

    {turtle Flower 84 (360/8) 8}

    {turtle SierpinskiTriangle 15 4 }
    
    {turtle SierpinskiArrowheadCurve 15 4}

    {turtle KochSnowflake 4.2 4}
    
    {turtle KrishnaAnklets 4.2 4}
    
    {turtle BoxFractal 4.2 4}

    # {turtle Flower 15 5 40 72}

    {turtle Flower 15 9 40 40}

    {turtle rotate 72 square 84 jump 84}

    {turtle rotate 20 @('circle',15,0.5,'circle',15,-0.5, 'rotate', 90 * 4)}

    {turtle @('rotate', 90, 'circle',42,0.25,'circle',42,-0.25 * 4)}

    {turtle @('rotate', 45, 'circle',21,0.25,'circle',21,-0.25 * 8)}

    {turtle rotate (360/5) @('circle',15,0.5,'circle',15,-0.5, 'rotate', 72 * 5)}
    
    {
        turtle square 42 @('rotate', -60, 'forward',42, 'rotate', 120, 'forward',42, 'rotate', 30 * 4)
    }

    { 
        # Golden triangle/square star
        $goldenRatio = (1 + [Math]::sqrt(5))/2
        turtle @('rotate', -60, 'forward',(42*$goldenRatio), 'rotate', 120, 'forward',(42*$goldenRatio), 'rotate', 30 * 4)
    }

    {
        # Golden hexagon
        $goldenRatio = (1 + [Math]::sqrt(5))/2
        $BaseSideCount = 6
        turtle @(
            'rotate', (360/$BaseSideCount/-2)
            foreach ($n in 1..$BaseSideCount) {
                'forward'
                42 * $goldenRatio
                'rotate'
                360/$BaseSideCount
            }
        ) * 2
        
    }

    {
        # Golden hex flowers
        $goldenRatio = (1 + [Math]::sqrt(5))/2
        $BaseSideCount = 6
        turtle (@(
            'rotate', (360/$BaseSideCount/-2)
            foreach ($n in 1..$BaseSideCount) {
                'forward'
                42 * $goldenRatio
                'rotate'
                360/$BaseSideCount
            }
            'rotate', (360/($BaseSideCount)/4)
        ) * ($BaseSideCount * 4))
    }

    {        
        turtle @($doodle * 4)
    }

    {        
        turtle ($doodle,'right','10', 'forward', '50' * 36)
    }

    {
        turtle ($doodle,'left','45', 'forward', '100' * 8)
    }

    {
        turtle ($doodle,'left','30', 'forward', '75' * 3)
    }

    {
        turtle @('StepSpiral',23, 90, 4, 'rotate',90 * 4)
    }

    {
        turtle spirolateral 42 60 8
    }

    {
        turtle rotate -30 @('spirolateral',23,60,6,@(1,3),'rotate', 60 * 6 )
    }

    {
        turtle spirolateral 23 90 11 @(3,4,5) 
    }

    {
        turtle spirolateral 23 120 6 @(1,3)
    }

    {
        turtle spirolateral 23 144 8
    }
    
    {
        turtle @('StepSpiral',23, 60, 4 * 3)
    }

    {
        turtle @('StepSpiral',23, 120, 16, 18)
    }

    {
        turtle @('StepSpiral',23, 60, 16, 19 * 6)
    }

    {
        turtle @('ArcRight', 23, 60, 'ArcLeft', 23, 160 * 24)
    }

    {
        turtle Pentaplexity 23 4
    }

    {
        turtle BoardFractal 23 4        
    }

    {
        turtle CrystalFractal 23 4
    }

    {
        turtle FlowerPetal 
    }
    
    {
        turtle (
            @(                
                'circlearc', 21, -60,
                'rotate',60,
                'forward',42  * 6 
                
                'rotate', 30
            ) * 12
        )
    }

    { 
        turtle StarFlower
    }

    {
        $spokes = Get-Random -Min 3 -Max 13
        $rings =  Get-Random -Min 3 -Max (13 * 3)
        turtle web 42 $spokes $rings morph @(
            turtle web 42 $spokes $rings 
            turtle rotate (
                Get-Random -Max 360
            ) web 42 $spokes $rings 
            turtle web 42 $spokes $rings 
        )
    }

    {
        Turtle @(
            'CircleArc',42, -90,
            'Rotate', 90 * 4
        )
    }

    {
        Turtle @(
            'CircleArc',42, -60,
            'Rotate', 60 * 6
        )
    }

    {
        Turtle @(
            'CircleArc',42, -45,
            'Rotate', 45 * 8
        )
    }
)

$siteBackground = $sitebackgrounds | Get-Random
$backgroundTurtle = . $siteBackground
$site.Background = $backgroundTurtle |
    Set-Turtle PatternAnimation $backgroundPatternAnimations |
    Set-Turtle PathAttribute @{opacity=.1} |
    Select-Object -ExpandProperty Pattern

$pngPreviewFile = 'Preview.png'
$previewImages = @(
    { turtle KochSnowflake 42 }
    { turtle @('rotate', 45, 'SierpinskiTriangle',42,4 * 24) }
    { turtle Pentaplexity 42 3 }
    { turtle RingFractal 42 4 }
    { turtle BoardFractal 42 4 }
    { turtle Flower 84 15 (3..12 | Get-Random) 24 }
    { turtle spirolateral 200 120 50 @(1,3) }
    { turtle FlowerPetal 100 20 (20..72 | Get-Random) 18 }
    { turtle @('circle',100,0.5,'rotate',90 * 8)}
)

$previewImage = $previewImages  |Get-Random 
$savedPreview = . $previewImage |
    Set-Turtle Stroke '#4488ff' |
    Save-Turtle -FilePath "./$pngPreviewFile"

$site.Image = "$($site.RootUrl)$($savedPreview.Name)"
#endregion Site Background


#region Highlight Settings
$site.HighlightJS = [Ordered]@{Languages=@('powershell')}
#endregion Highlight Settings

#region Google Analytics
$site.AnalyticsID = 'G-G9D8TQ3G2L' # replace with your Google Analytics ID
#endregion Google Analytics

if ($PSScriptRoot) { Pop-Location }