@{    
    # Version number of this module.
    ModuleVersion = '0.2.2'
    # Description of the module
    Description = "Turtle Graphics in PowerShell"
    # Script module or binary module file associated with this manifest.
    RootModule = 'Turtle.psm1'
    # ID used to uniquely identify this module
    GUID = '71b29fe9-fc00-4531-82ca-db5d2630d72c'
    # Author of this module
    Author = 'James Brundage'    

    # Company or vendor of this module
    CompanyName = 'Start-Automating'
    # Copyright statement for this module
    Copyright = '2025 Start-Automating'
    # Type files (.ps1xml) to be loaded when importing this module
    TypesToProcess = @('Turtle.types.ps1xml')

    FunctionsToExport = 
        'Get-Turtle',
        'Move-Turtle',
        'New-Turtle',
        'Save-Turtle',
        'Set-Turtle',
        'Show-Turtle'
    # Format files (.ps1xml) to be loaded when importing this module
    # FormatsToProcess = @()
    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    VariablesToExport = '*'
    AliasesToExport = 'Turtle','🐢'
    PrivateData = @{
        PSData = @{
            # Tags applied to this module. These help with module discovery in online galleries.
            Tags       = 'PowerShell', 'Turtle', 'Graphics', 'TurtleGraphics', 'SVG', 'Drawing', 'L-System', 'Fractal'
            # A URL to the main website for this project.
            ProjectURI = 'https://github.com/PowerShellWeb/Turtle'
            # A URL to the license for this module.
            LicenseURI = 'https://github.com/PowerShellWeb/Turtle/blob/main/LICENSE'
            ReleaseNotes = @'
## Turtle 0.2.2:

* New Shapes:  
  * `Turtle.ArcFlower` ( #358 )
  * `Turtle.Arcygon` ( #359 )
  * `Turtle.ClosePath` ( #277 )  
  * `Turtle.RightTriangle` ( #367 )
  * `Turtle.Rhombus` ( #372 )
  * `Turtle.StepCurve` ( #329 )
  * `Turtle.Triflower` ( #371 )
  * `Turtle.Lucky` draws a random shape (#366)  
* Font Settings:
  * `Turtle.FontWeight` ( Fixes #354, Fixes #381 )
  * `Turtle.FontVariant` ( Fixes #354, Fixes #380 )
  * `Turtle.FontStyle` ( Fixes #354, Fixes #379 )
  * `Turtle.FontSize` ( Fixes #354, Fixes #378 )
  * `Turtle.FontFamily` ( Fixes #354, Fixes #377 )
* Improvements
  * Turtle.PathAnimation outputs XML (#374)
  * Get-Turtle speed boost (#368)
  * Move-Turtle uses the script (#351)
  * Randomizing most default parameters (#363)
  * Turtle defaults IDs to timestamp ( #362 )
  * Fill and Stroke improvement ( Fixes #360, Fixes #361, Fixes #369 )    
    * Adding random support
    * Improving gradient support
    * Overwriting class if stroke is specified
* Fixes
  * Turtle.History compatibility fix ( #373 )
    * Turtle works on PowerShell 5.1!
  * Moore Curve Fixes ( #370 )

---

Additional history available in the [CHANGELOG](https://github.com/PowerShellWeb/Turtle/blob/main/CHANGELOG.md)

Please:

* [Like](https://github.com/PowerShell/Turtle)
* [Share](https://psturtle.com/)
* Subscribe
  * [psturtle.com](https://bsky.app/profile/psturtle.com)
  * [mrpowershell.com](https://bsky.app/profile/mrpowershell.com)
  * [StartAutomating](https://github.com/StartAutomating)
  * [PowerShellWeb](https://github.com/PowerShellWeb)
* Sponsor [StartAutomating](https://github.com/sponsors/StartAutomating)
'@        
        }
    }

    # HelpInfo URI of this module
    # HelpInfoURI = ''

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''
}

