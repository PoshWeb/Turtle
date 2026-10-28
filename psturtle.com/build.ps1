<#
.SYNOPSIS
    Builds the website.
.DESCRIPTION
    Builds a static site using PowerShell.

    * The site will be configured using any `config.*` files.
    * Functions and filters will be loaded from any `functions.*` or `filters.*` files.
    * All files will be processed using `buildFile.ps1` (any `*.*.ps1` file should be run).
.EXAMPLE
    ./build.ps1
#>
param(
[string[]]
$FilePath,

[string]
$Root = $PSScriptRoot
)

# Push into the script root directory
if ($PSScriptRoot) { Push-Location $PSScriptRoot }

# Creation of a sitewide object to hold configuration information.
$Site = [Ordered]@{}
$Site.Files = 
    if ($filePath) { Get-ChildItem -Recurse -File -Path $FilePath } 
    else { Get-ChildItem -Recurse -File }

$Site.PSScriptRoot = "$PSScriptRoot"

#region Common Functions and Filters
# Any functions or filter file at the site root should be loaded.
$functionFileNames = 'functions', 'function', 'filters', 'filter'
$functionPattern   = "(?>$($functionFileNames -join '|'))\.ps1$"
$functionFiles     = Get-ChildItem -Path $Site.PSScriptRoot |
    Where-Object Name -Match $functionPattern

foreach ($file in $functionFiles) {
    # If we have a file with the name function or functions, 
    # we'll dot source it now so we can use the functions in the config
    . $file.FullName
}
#endregion Common Functions and Filters

# Set an alias to buildPage.ps1
Set-Alias BuildPage ./buildPage.ps1

# If we have a github event,
# save it to a variable and to the `$site`
$site.GitHubEvent = $gitHubEvent =
    if ($env:GITHUB_EVENT_PATH) {
        # all we need to do to serve it is copy it.
        Copy-Item $env:GITHUB_EVENT_PATH .\gitHubEvent.json

        # and we can assign it to a variable, so you we can use it in any files we build.
        Get-Content -Path .\gitHubEvent.json -Raw | ConvertFrom-Json
    }

# If we have a CNAME, read it, trim it, and update the site object.
if (Test-Path 'CNAME') {
    $Site.CNAME = $CNAME = (Get-Content -Path 'CNAME' -Raw).Trim()
    $Site.RootUrl = "https://$CNAME/"
} elseif (
    # otherwise, if we are in a directory that could be a domain
    ($site.PSScriptRoot | Split-Path -Leaf) -like '*.*'
) {
    # assume it _is_ the domain.
    $site.CNAME = $CNAME = ($site.PSScriptRoot | Split-Path -Leaf)
    $site.RootUrl = "https://$CNAME/"
}

# If we have a config.ps1 file,
if (Test-Path 'config.ps1') {
    # Get the script command
    $configScript = Get-Command -Name './config.ps1'
    # and install any requirements it has.
    $configScript | RequireModule
    # run it, and let it configure anything it chooses to.
    . $configScript
}
#endregion config

# Start the clock
$site['LastBuildTime'] = $lastBuildTime = [DateTime]::Now
#region Build Files

# Start the clock on the build process
$buildStart = [DateTime]::Now
Write-Host "Started Building Pages @ $buildStart"
# pipe every file we find to buildFile
$Site.Files | . buildPage
# and stop the clock
$buildEnd = [DateTime]::Now
Write-Host "Finished Building Pages @ $buildEnd ($($buildEnd - $buildStart))"

#endregion Build Files

# If we have changed directories, we need to push back into the script root directory.
if ($PSScriptRoot -and "$PSScriptRoot" -ne "$pwd") {
    Push-Location $psScriptRoot
}

if ($site.includes.'LastBuild.json' -is [Management.Automation.ExternalScriptInfo]) {    
    . $site.includes.'LastBuild.json' > ./lastBuild.json
}

if ($site.includes.'Sitemap.xml' -is [Management.Automation.ExternalScriptInfo]) {
    . $site.includes.'Sitemap.xml' > sitemap.xml
}

if ($site.includes.'Robots.txt' -is [Management.Automation.ExternalScriptInfo]) {
    . $site.includes.'Robots.txt' > robots.txt
}

if ($site.includes.'Index.rss' -is [Management.Automation.ExternalScriptInfo]) {
    New-Item -ItemType File -Path ./RSS/index.rss -Force -Value (
        . $site.includes.'Index.rss'
    )
}

#region archive.zip
if ($site.Archive) {
    # Create an archive of the current deployment.
    Compress-Archive -Path $pwd -DestinationPath "archive.zip" -CompressionLevel Optimal -Force
}
#endregion archive.zip
if ($PSScriptRoot) { Pop-Location }
