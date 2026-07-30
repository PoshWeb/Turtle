#requires -Module Turtle, Reptile

Push-Location $PSScriptRoot

Reptile -Initialize {
    Import-Module Turtle -Global
    $env:TURTLE_BOT = $true
    Set-Alias Random Get-Random
    function RandomColor { "#{0:x6}" -f (Get-Random -Max 0xffffff) }
    function RandomAngle {Get-Random -Min -360 -Max 360 }

    function RandomPercent { "$(Get-Random -Min 0.01 -Max 99.99)%" }

    function ColorWheel { 
        "<style>"
        ".colorWheel {"
        $randomOffset = Get-Random -Min -360 -Max 360
        @(foreach ($n in 0..8) {
                "hsl($($randomOffset + ($n * 45)) 100% 50%)"
        }) -join ','
        "}"
        "</style>"
            
        "<div style='width:100%;height:100%;border-radius:50%;background:conic-gradient($(
            @(foreach ($n in 0..8) {
                "hsl($($randomOffset + ($n * 45)) 100% 50%)"
            }) -join ','
        ))'></div>"  
    }
    
    function say {
        $allInput = @($input) + @($args)
        foreach ($message in $allInput) {
            "<h1>$([Web.HttpUtility]::HtmlEncode($message))</h1>"
        }
    }

    function tips {        
        $tips = @(
            
            '`colorwheel` draws a color wheel'

            '`Get-Random` gets random numbers (or random items)'

            'You can multiply lists to repeat them:  `turtle @("rotate", (360/5), "forward", 42 * 5)`'

            "There are many types of flower (flower, triflower, petalflower, goldenflower)"
            
            'Turtle can do math.  Try./ `turtle rotate (360/4) forward 42`'

            'Turtle can make patterns.  Just add `pattern` to the end of a command.'
        )
        
        "<h3>$($tips | 
            Get-Random | 
            ConvertFrom-Markdown | 
            Select-Object -ExpandProperty html
        )</h3>"
    }
} -Repl (./TurtleShell.html.ps1) -SupportedCommand @(    
    'Turtle', 'Get-Turtle', '🐢'

    'Get-Random', 'Random', 'RandomColor', 'RandomAngle', 'RandomPercent'

    'ColorWheel'

    'Say'

    'tip','tips'
)

Pop-Location