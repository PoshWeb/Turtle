<#
.SYNOPSIS
    Includes Help Content
.DESCRIPTION
    Includes the Help for a Command.
#>
param(
# The command
[PSObject]
$Command,

# If set, will invoke examples.
# This can be as dangerous as your examples.
[switch]
$InvokeExample,

# If set, will not show the command name
[switch]
$HideName,

# The identifier for the palette `<select>`.
[string]
$SelectPaletteId = 'SelectPalette'
)

# Try to get command help
$CommandHelp = Get-Help -Name $Command -ErrorAction Ignore
# If we cannot get help, return
if (-not $CommandHelp) { return }

# If the help was a string
if ($CommandHelp -is [string]) {
    # return preformatted text.
    return "<pre>$([Web.HttpUtility]::HtmlEncode($CommandHelp))</pre>"
}

# Get the core parts of help we need.
$synopsis = $CommandHelp.Synopsis
$description = $CommandHelp.description.text -join [Environment]::NewLine
$notes = $CommandHelp.alertSet.alert.text -join [Environment]::NewLine

filter looksLikeMarkdown {
    if (
        # If it's got a markdown-like link
        $_ -match '\[[^\]]+\]\(' -or 
        # Or any of the lines start with markdown special characters
        $_ -split '(?>\r\n|\n)' -match '\s{0,3}[\#*~`]'
    ) {
        # it's probably markdown
        $_
    }    
}

filter looksLikeTags {
    if ($_ -match '^\s{0,}<') {
        $_
    }
}

# Display the command name, synopsis, and description
if (-not $HideName) {
    "<h1>$([Web.HttpUtility]::HtmlEncode(
        $CommandHelp.Name -replace '(?:.+?/){0,}' -replace '\.ps1$' -replace '\..+?$'
    ))</h1>"
}

if ($synopsis) {
    if ($synopsis | looksLikeMarkdown) {
        (ConvertFrom-Markdown -InputObject $synopsis).Html
    }
    elseif ($synopsis | looksLikeTags) {
        $synopsis
    } else {
        "<h2>$([Web.HttpUtility]::HtmlEncode($synopsis))</h2>"
    }
}

if ($description) {
    if ($description | lookslikeMarkdown) {
        (ConvertFrom-Markdown -InputObject $description).Html
    } 
    elseif ($description | looksLikeTags) {
        $description
    }
    else {
        "<h3>$([Web.HttpUtility]::HtmlEncode($description))</h3>"        
    }
}

if ($notes) {
    # If there were notes, convert them from markdown
    (ConvertFrom-Markdown -InputObject $notes).Html
}

#region Grid Styles
"<style>"
".example-grid {    
    text-align: center;
}"
".example {    
    text-align: center;    
}"
".example-code {
    text-align: center;    
    font-size: .9rem;
    margin-left: auto;
    margin-right: auto;
}"

"code { text-align: left}"

".example-menu { text-align: right; margin-top: -.5rem; margin-bottom: -.5rem }"
".copy-button { float: right; }"

".example-outputs {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 1rem;
    margin: 0.8rem;
    padding: 0.2rem;
    width: 90%;
    margin-left: auto;
    margin-right: auto;
}"
".example-output { text-align: center }"
"
pre {
    position: relative;  
}
"
"</style>"
#endregion Grid Styles

$exampleCount = @($CommandHelp.examples.example).Length
$progress = [Ordered]@{id=Get-Random}
$progress.Activity = "$($command) examples"
# Create a grid for examples
"<div class='example-grid'>"
$exampleNumber = 0
# Walk over each example
foreach ($example in $CommandHelp.examples.example) {    
    $exampleNumber++
    
    # Combine the code and remarks
    $exampleLines = 
        @(
            $example.Code
            foreach ($remark in $example.Remarks.text) {
                if (-not $remark) { continue }
                $remark
            }
        ) -join ([Environment]::NewLine) -split '(?>\r\n|\n)' # and split into lines

    # Anything until the first non-comment line is a markdown predicate to the example
    $nonCommentLine = $false
    $markdownLines = @()

    $progress.PercentComplete = $exampleNumber * 100 / $exampleCount
    $progress.Activity = "$($command) examples $exampleNumber"
    $progress.Status = "$($exampleLines[0])"
    Write-Progress @progress
        
    # Go thru each line in the example as part of a loop
    $codeBlock = @(foreach ($exampleLine in $exampleLines) {
        # Any comments until the first uncommentedLine are markdown
        if ($exampleLine -match '^\#' -and -not $nonCommentLine) {
            $markdownLines += $exampleLine -replace '^\#' -replace '^\s+'
        } else {
            $nonCommentLine = $true
            $exampleLine
        }
    }) -join [Environment]::NewLine
    
    # Join all of our markdown lines together
    $Markdown = $markdownLines -join [Environment]::NewLine
        
    # and start our example div
    "<div class='example'>"
        # If we had markdown, output it
        if ($markdown) {
            (ConvertFrom-Markdown -InputObject $Markdown).Html
        }

        $exampleCode = 
            try {
                [scriptblock]::Create($codeBlock)
            } catch {
                Write-Warning "Unable to convert $($example.code) to a script"
                continue
            }
            
        # followed by our sample code
        "<div class='example-code'>"
            "<pre>"
                "<code class='language-powershell'>" + 
                    [Web.HttpUtility]::HtmlEncode($codeBlock) + 
                "</code>"
            "</pre>"
        "</div>"    
    
        # If we do not want to invoke examples, we can continue to the next example.
        if (-not $InvokeExample) { 
            "</div>"
            "<hr/>"
            continue
        }        
        # Otherwise, try to make our example a script block
        
        
        if (-not $global:ExampleOutputCache) {
            $global:ExampleOutputCache = [Ordered]@{}
        }
        if (-not $global:ExampleOutputCache[$codeBlock]) {            
            $global:ExampleOutputCache[$codeBlock] = @(. $exampleCode)
        }
        # then run it and capture the output
        $exampleOutputs = $global:ExampleOutputCache[$codeBlock]
        
        # Keep track of our example output count
        $exampleOutputNumber = 0
        # and start walking thru the list
        "<div class='example-outputs'>"
        foreach ($exampleOutput in $exampleOutputs) {
            $exampleOutputNumber++
            # Each output goes in a div
            "<div class='example-output'>"
            # if the output was a file
            if ($exampleOutput -is [IO.FileInfo]) {
                # and that file is SVG
                if ($exampleOutput.Extension -eq '.svg') {
                    # include it inline.
                    Get-Content $exampleOutput.FullName -Raw
                }
            } else {
                # If the output was a turtle object
                if ($exampleOutput.pstypenames -contains 'Turtle') {
                    # set it's ID
                    $exampleOutput.ID = "$($Command)-Example-$exampleCounter"
                    if ($exampleOutputs.Length -gt 1) {
                        # If we have more than out output,
                        # attach our example counter
                        $exampleOutput.ID += "-$($exampleOutputNumber)"
                    }
                }            
                # Include our example output inline
                if ($exampleOutput.ToHtml.Invoke) {
                    $exampleOutput.ToHtml()
                } else {
                    "$exampleOutput"
                }            
            }    
            "</div>"
        }
        "</div>"
        "<hr/>"
    "</div>"    
}
"</div>"

$progress.Remove('PercentComplete')
$progress['Completed'] = $true
Write-Progress @progress

@"
<script>
document.querySelectorAll('pre > code').forEach(element => {
    const copyCodeButton = document.createElement('div')
    copyCodeButton.classList.add('copy-button')
    copyCodeButton.onclick = () => navigator.clipboard.writeText(element.innerText)
    copyCodeButton.innerHTML = ``$(. /_includes/FeatherIcon -Icon 'clipboard')``
    element.parentNode.prepend(copyCodeButton)
});
</script>
"@