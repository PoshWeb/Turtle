<#
.SYNOPSIS
    Draws a spirolateral
.DESCRIPTION
    Draws a spirolateral
.LINK
    https://en.wikipedia.org/wiki/Spirolateral
.EXAMPLE
    turtle spirolateral save ./Spirolateral.svg
.EXAMPLE
    turtle spirolateral 50 144 8 save ./Spirolateral-144-8.svg
.EXAMPLE
    turtle spirolateral 50 60 10 save ./Spirolateral-60-10.svg
.EXAMPLE
    turtle spirolateral 50 120 6 @(1,3) save ./Spirolateral-120-6-1_3.svg
.EXAMPLE
    turtle spirolateral 50 90 11 @(3,4,5) save ./Spirolateral-90-11-3_4_5.svg
.EXAMPLE
    turtle @('spirolateral',50,60,6,@(1,3),'rotate', 60 * 6 ) save ./Spirolateral-x6.svg
#>
param(
# The base length of each side (this will be multiplied by the step number)
[double]
$Side = $(
    (Get-Random -Min 42.0 -Maximum 84.0) * (1,-1 | Get-Random)
),

# The angle of the turn
[double]
$Angle = $(
    (Get-Random -Min 10.0 -Maximum 120.0) * (1,-1 | Get-Random)
),

# The step count.
# This is the number of times the steps will be repeated.
[int]
$StepCount = 0,

# The step numbers that are left turns (counter-clockwise).
# This allows the creation of general spirolaterals
[Parameter(ValueFromRemainingArguments)]
[int[]]
$LeftTurnSteps
)

if ($Angle -eq 0) { return $this }

# If no step count was provided
if ($StepCount -eq 0) {
    # pick a random number of rotations
    $revolutions = (Get-Random -Minimum 1 -Max 16)
    # and figure out how many steps at our angle it takes to get there.
    foreach ($n in 2..$revolutions) {
        $revNumber = ($revolutions * 360)/$Angle
        $StepCount = [Math]::Ceiling($revNumber)
        if ([Math]::Floor($revNumber) -eq $revNumber) {
            break
        }
    }    
}


$stepNumber = 1

# Figure out our total turn per loop
$totalTurn = 0.0
for ($stepNumber = 1; $stepNumber -le [Math]::Abs($StepCount); $stepNumber++) {    
    if ($LeftTurnSteps -contains $stepNumber) {
        $totalTurn -= $angle        
    } else {
        $totalTurn += $angle        
    }
}

$rotations = 0
foreach ($n in 1..32) {
    $rotations = ($n * 360)/$totalTurn    
    if ([Math]::Floor($rotations) -eq $rotations) {
        break
    }
}
$rotations = [Math]::Ceiling($rotations)


foreach ($rotation in 1..$rotations) {
    $null = for ($stepNumber = 1; $stepNumber -le [Math]::Abs($StepCount); $stepNumber++) {
        $null = $this.Forward($side * $stepNumber)
        if ($LeftTurnSteps) {
            if ($LeftTurnSteps -contains $stepNumber) {
                $totalTurn -= $angle
                $this.Left($angle)
            } else {
                $totalTurn += $angle
                $this.Right($angle)
            }
        } else {
            $totalTurn += $angle
            $this.Right($angle)
        }
    }
}

    
    
<#} until (
    (-not ([Math]::Round($totalTurn, 1) % 360 )) -and 
    $majorStepCount -le [Math]::Abs($StepCount)
)#>

return $this
