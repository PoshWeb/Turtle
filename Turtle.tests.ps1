describe Turtle {
    it "Draws things with simple commands" {
        $null = $turtle.Clear().Square()
        $turtleSquaredPoints = $turtle.Points       
        $turtleSquaredPoints.Length | Should -Be 8    
        [int]($turtleSquaredPoints | 
            Measure-Object -Sum | 
            Select-Object -ExpandProperty Sum) | 
            Should -Be 0
    } 

    it 'Can draw an L-system, like a Sierpinski triangle' {
        $turtle.Clear().SierpinskiTriangle(200, 2, 120).points.Count |
            Should -Be 54
    }

    it 'Can rasterize an image, with a little help from chromium' {
        $png = New-Turtle | Move-Turtle SierpinskiTriangle 15 5 | Select-Object -ExpandProperty PNG
        $png[1..3] -as 'char[]' -as 'string[]' -join '' | Should -Be PNG
    }

    it 'Can draw an arc' {
        $Radius = 1
        $t = turtle ArcRight $Radius 360
        $Heading = 180.0
        [Math]::Round($t.Width,1) | Should -Be ($Radius * 2)
        [Math]::Round($t.Height,1) | Should -Be ($Radius * 2)
        [Math]::Round($t.Heading,1) | Should -Be 360.0

        $Radius = 1
        $Heading = 180.0
        $t = turtle ArcRight $Radius 180
        [Math]::Round($t.Width,1) | Should -Be $Radius
        [Math]::Round($t.Height,1) | Should -Be ($Radius * 2)
        [Math]::Round($t.Heading,1) | Should -Be $Heading

        $Radius = 1
        $Heading = 90.0
        $t = turtle ArcRight $Radius $Heading
        [Math]::Round($t.Width,1) | Should -Be $Radius
        [Math]::Round($t.Height,1) | Should -Be $Radius
        [Math]::Round($t.Heading,1) | Should -Be $Heading        
    }


    context 'Turtle Directions' {
        it 'Can tell you the way towards a point' {
            $turtle = turtle
            $turtle.Towards(0,1) | should -be 90
            $turtle.Towards(1,1) | Should -be 45
            $turtle.Towards(1,0) | should -be 0
            $turtle.Towards(-1,1) | Should -be 135
            $turtle.Towards(-1,0) | Should -be 180
            $turtle.Towards(0,-1) | Should -be -90
        }

        it 'Will return a relative heading' {
            $turtle = turtle
            $turtle = $turtle.Rotate($turtle.Towards(1,1))
            $turtle = $turtle.Forward($turtle.Distance(1,1))
            $turtle.Heading | Should -be 45
            [Math]::Round($turtle.Position.X,$turtle.Precision) | Should -be 1
            [Math]::Round($turtle.Position.Y,$turtle.Precision) | Should -be 1
            $turtle = $turtle.Rotate($turtle.Towards(2,2))
            $turtle = $turtle.Forward($turtle.Distance(2,2))
            $turtle.Heading -as [float] | Should -be 45
            [Math]::Round($turtle.Position.X,$turtle.Precision) | Should -be 2
            [Math]::Round($turtle.Position.Y,$turtle.Precision) | Should -be 2
        }
    }

    context 'Turtle Security' {
        it 'Can run in a data block' {
            $dataBlockTurtle = data -supportedCommand turtle, Get-Random {
                turtle rotate 45 forward (Get-Random -Min 21 -Max 42)
            }
            $dataBlockTurtle.Heading | Should -Be 45
        }
        it 'Will not show a turtle in non-interactive mode' {
            if ([Environment]::UserInteractive -and -not $env:GITHUB_WORKFLOW) {
                Write-Warning "Cannot test non-iteractivity interactively"
            } else {
                $dataBlockTurtle = data -supportedCommand turtle, Get-Random {
                    turtle rotate 45 forward (Get-Random -Min 21 -Max 42) show
                }
                $dataBlockTurtle.Heading | Should -Be 45   
            }
        }
    }

    context 'Turtle OFS compatibility' {
        it 'Warns and sets global OFS when imported with a custom global OFS' {
            $originalOFS = $global:OFS
            try {
                Remove-Module Turtle -ErrorAction Ignore
                $global:OFS = '|||'

                $importOutput = & {
                    Import-Module (Join-Path $PSScriptRoot 'Turtle.psd1') -Force
                } 3>&1
                $importWarnings = @($importOutput | Where-Object { $_ -is [Management.Automation.WarningRecord] })

                ($importWarnings.Message -join "`n") | Should -Match 'Setting \$global:OFS'
                $global:OFS | Should -Be ' '

                $svg = (turtle square 10).SVG.OuterXml
                $svg | Should -Not -Match '\|\|\|'
                $svg | Should -Match 'viewBox=.0 0 '
            }
            finally {
                $global:OFS = $originalOFS
                Remove-Module Turtle -ErrorAction Ignore
                Import-Module (Join-Path $PSScriptRoot 'Turtle.psd1') -Force | Out-Null
            }
        }
    }
}

