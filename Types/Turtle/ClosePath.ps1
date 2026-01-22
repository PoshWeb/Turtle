<#
.SYNOPSIS
    Closes a path
.DESCRIPTION
    Closes a path and resets the position to the last move command (Start or Teleport)
.EXAMPLE
    turtle forward 42 rotate 90 forward 42 closePath rotate 90 forward 42 rotate 90 forward 42 closePath show
#>
param()
$this.Steps.Add("z")
$history =$this.History
if ($history) {
    $change = $this.History[-1]
    $this.Position = $change.Delta.X, $change.Delta.Y
} else {
    $this.Position = 0, 0
}


