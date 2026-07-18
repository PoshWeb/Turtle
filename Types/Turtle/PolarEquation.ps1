
<#

.SYNOPSIS    
    Draws a polar equation.    
.DESCRIPTION
    Instructs our turtle to draw a polar equation.
    
    The first output of the equation should always be the current position, and the heading should moved throughout the drawing.

    This way, if our turtle stops drawing, it will be at the right position and heading to continue drawing from here.    
.EXAMPLE    
    turtle PolarEquation 100 { $Radius } |
        Save-Turtle ./PolarCircle.svg
.EXAMPLE    
    turtle PolarEquation 100 {
        $Radius * [Math]::Cos($Frequency * $Step * $Radian)
    } @{Frequency=2.0} |
        Save-Turtle .\PolarRose.svg
        
.EXAMPLE
    turtle rotate 45 forward 100 PolarEquation 100 {
        $Radius * [Math]::Cos($Frequency * $Angle * [Math]::PI/180)
    } @{Frequency=2.0} forward 100 |
        Save-Turtle .\PolarRoseAndSpokes.svg
.EXAMPLE    
    # Cartoid    
    turtle PolarEquation 100 {    
        $Radius * [Math]::sin(    
            ($Angle * $Radian) / 2    
        )                                    
    } @{} 90
.EXAMPLE
    turtle rotate 90 PolarEquation 100 {    
        $Radius * [Math]::sin(    
            ($Angle * $Radian) / 2    
        )                                    
    } @{} 90 morph @(
        turtle rotate 90 PolarEquation 100 {    
            $Radius * [Math]::sin(    
                ($Angle * $Radian) / 2    
            )                                    
        } @{} 90
        turtle rotate 90 PolarEquation -100 {    
            $Radius * [Math]::sin(    
                ($Angle * $Radian) / 2    
            )                                    
        } @{} 90
        turtle rotate 90 PolarEquation 100 {    
            $Radius * [Math]::sin(    
                ($Angle * $Radian) / 2    
            )                                    
        } @{} 90
    ) show
.EXAMPLE    
    # Lemniscate    
    turtle PolarEquation 100 {
        $Radius/2 * [Math]::Pow(    
            [Math]::Cos($StepRadian), 4      
        )                                    
    }
.EXAMPLE
    turtle PolarEquation 100 { $Radius } morph @(
        turtle PolarEquation 100 { $Radius } @{} 90
        turtle PolarEquation 100 { $Radius * [Math]::Cos($Frequency * $Step * $Radian) } @{Frequency=2.0} 90     
        turtle PolarEquation 100 { $Radius * [Math]::Cos($Frequency * $Step * $Radian) } @{Frequency=4.0} 90
        turtle PolarEquation 100 { $Radius * [Math]::Cos($Frequency * $Step * $Radian) } @{Frequency=6.0} 90
        turtle PolarEquation 100 { $Radius } @{} 90
    )
.EXAMPLE
    turtle PolarEquation 100 { $Radius } morph @(
        turtle PolarEquation 100 { $Radius } @{} 90
        turtle PolarEquation 100 { $Radius * [Math]::Cos($Frequency * $Step * $Radian) } @{Frequency=3.0} 90     
        turtle PolarEquation 100 { $Radius * [Math]::Cos($Frequency * $Step * $Radian) } @{Frequency=4.0} 90
        turtle PolarEquation -100 { $Radius * [Math]::Cos($Frequency * $Step * $Radian) } @{Frequency=5.0} 90
        turtle PolarEquation 100 { $Radius * [Math]::Cos($Frequency * $Step * $Radian) } @{Frequency=4.0} 90
        turtle PolarEquation -100 { $Radius * [Math]::Cos($Frequency * $Step * $Radian) } @{Frequency=3.0} 90
        turtle PolarEquation 100 { $Radius } @{} 90
    )
#>
            
    
param(
# The radius of the polar path    
[Parameter(ValueFromPipelineByPropertyName)]
[Alias('R')]
[double]
$Radius = $(Get-Random -Min 23 -Max 42),

# The equation to draw the polar path, as a _limited_ PowerShell script.
# For simplicity, translatability, and security, only Math expressions are allowed.
# No loops are allowed, no commands are allowed, no assignments are allowed.
[ValidateScript({
    [ScriptBlock]$scriptBlock = [ScriptBlock]::Create($_)
    if ($scriptBlock -isnot [ScriptBlock]) { return $false }
    $astConditions = {
        param($ast)

        # No commands allowed
        if ($ast -is [Management.Automation.Language.CommandAst]) {
            throw "No Commands Allowed!"
        }

        # Only Math allowed
        if ($ast -is [Management.Automation.Language.TypeExpressionAst] -and $(
            $reflectionType = $ast.TypeName.GetReflectionType()
            $reflectionType -ne [Math]
        )) {
            throw "$($reflectionType) not allowed.  Only [Math] Allowed."
        }
        # No assignments allowed
        if ($ast -is [Management.Automation.Language.AssignmentStatementAst]) {
            throw "No Assignments Allowed!"
        }
        # Only static members allowed
        if ($ast -is [Management.Automation.Language.InvokeMemberExpressionAst] -and 
            -not $ast.Static) {
            throw "Only static members allowed"
        }
        # No string expansion
        if ($ast -is [Management.Automation.Language.ExpandableStringExpressionAst]) {
            throw "No Expandable Strings Allowed!"
        }
        # No loop statements
        if ($ast -is [Management.Automation.Language.LoopStatementAst]) {
            throw "No Loops Allowed!"
        }
        return $true
    }
    $scriptBlockAst = $scriptBlock.Ast
    foreach ($astCondition in $astConditions) {
        $foundResults = $scriptBlockAst.FindAll($astCondition, $true)
        if (-not $foundResults) { return $false }
    }
    return $true
})]
[Alias('Formula')]
[string]
$Equation = { $Radius },

# Any polar equation variables
[Collections.IDictionary]
$Variable = [Ordered]@{},

# The number of steps to draw.  By default, 180
[int]$StepCount = 180,

# The extent of the polar equation
# This is the percentage of the equation to render.
[double]$Extent = 1
)


$turtle = if ($this) { $this } else { turtle }

# Declare this relatively simple function to calculate a polar coordinate.
function 𝜑 {
    param($radius, $angle)
    $radius * [math]::round([math]::cos($angle * [Math]::PI / 180),10)
    $radius * [math]::round([math]::sin($angle * [Math]::PI / 180),10)
}

foreach ($variableName in $variable.Keys) {
    if ($variable -match ':') {
        Write-Error "Will not access providers"
        return
    }
    if (-not (
        $variable[$variableName] -is [double] -or
        $variable[$variableName] -is [float] -or
        $variable[$variableName] -is [int]
    )) { 
        Write-Warning "$variableName must be a number"
        continue
    }
    $ExecutionContext.SessionState.PSVariable.Set($variableName, $variable[$variableName])
}

$centerX          = $turtle.Position.X
$centerY          = $turtle.Position.Y

$radian = [Math]::PI / 180

Write-Verbose "Drawing Polar Equation $equation of radius $radius"
$localEquation = [ScriptBlock]::Create("$Equation")

$FirstStep = $true
$translateX = 0
$translateY = 0

$originalHeading = @($turtle.Heading)[0]

$extentAngle = 360 * $Extent 

$angleStep = $extentAngle/$StepCount

for ($angle = $originalHeading; [Math]::Abs($angle - $originalHeading) -le [Math]::Abs($extentAngle); $angle += $angleStep) {
    $step = $angle
    $StepRadian = $angle * [Math]::PI / 180
    # Calculate the radius of the formula at this moment
    $momentRadius = . $localEquation

    # Calculate the point of the formula
    $momentX, $momentY = 𝜑 $momentRadius $angle
           
    $relativeX = ($momentX * -1) - $centerX
    $relativeY = ($momentY * -1) - $centerY

    # If this is the first step, we will make subsequent calculations relative to this point
    if ($firstStep) {
        $translateX = $CenterX + $relativeX
        $translateY = $CenterY + $relativeY
        $firstStep = $false
        # continue
    }
            
    $turtle = $turtle.GoTo(
        $translateX + ($momentX),
        $translateY + ($momentY)
    )        
}

return $turtle