$commandsPath = Join-Path $PSScriptRoot Commands
:ToIncludeFiles foreach ($file in (Get-ChildItem -Path "$commandsPath" -Filter "*-*" -Recurse)) {
    if ($file.Extension -ne '.ps1')      { continue }  # Skip if the extension is not .ps1
    foreach ($exclusion in '\.[^\.]+\.ps1$') {
        if (-not $exclusion) { continue }
        if ($file.Name -match $exclusion) {
            continue ToIncludeFiles  # Skip excluded files
        }
    }     
    . $file.FullName
}

if ($global:OFS -ne ' ') {
    Write-Warning "Turtle requires `$OFS to be a single space for SVG serialization. Setting `$global:OFS to ' '."
    $global:OFS = ' '
}

$myModule = $MyInvocation.MyCommand.ScriptBlock.Module
$ExecutionContext.SessionState.PSVariable.Set($myModule.Name, $myModule)
$myModule.pstypenames.insert(0, $myModule.Name)

New-PSDrive -Name $MyModule.Name -PSProvider FileSystem -Scope Global -Root $PSScriptRoot -ErrorAction Ignore

if ($home) {
    $MyModuleProfileDirectory = Join-Path ([Environment]::GetFolderPath("LocalApplicationData")) $MyModule.Name
    if (-not (Test-Path $MyModuleProfileDirectory)) {
        $null = New-Item -ItemType Directory -Path $MyModuleProfileDirectory -Force
    }
    New-PSDrive -Name "My$($MyModule.Name)" -PSProvider FileSystem -Scope Global -Root $MyModuleProfileDirectory -ErrorAction Ignore
}

# Set a script variable of this, set to the module
# (so all scripts in this scope default to the correct `$this`)
$script:this = $myModule

#region Custom
#endregion Custom

Export-ModuleMember -Alias * -Function * -Variable $myModule.Name


