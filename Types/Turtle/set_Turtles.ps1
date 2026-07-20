<#
.SYNOPSIS
    Sets a Turtle's Turtles
.DESCRIPTION
    Sets the Turtles contained within a Turtle object.

    These turtles may also contain turtles...
    which may also contain turtles... 
    which may also contain turtles...
    which may also contain turtles...
    all the way down.
.EXAMPLE
    turtle square 42 turtles @{
        circle = turtle circle 21        
    } save ./InscribedSquare.svg     
.EXAMPLE
    turtle square 42 turtles @{
        square = 
            turtle teleport 4 4 square 34 turtles @{
                square = turtle teleport 8 8 square 26 turtles @{
                    square = turtle teleport 8 8 square 26 turtles @{
                        square = turtle teleport 12 12 square 18 turtles @{
                            square = turtle teleport 16 16 square 10
                        }
                    }
                }
            }        
    } save ./SquaresWithinSquares.svg
#>
param(
[PSObject]
$Value
)

# If we don't already have a turtles dictionary
if ($this -and -not $this.'.Turtles') {
    # now is the time to create one.
    $this | Add-Member NoteProperty '.Turtles' ([Ordered]@{}) -Force 
}

# Go over each value
foreach ($v in $value) {
    # If the value was a dictionary
    if ($v -is [Collections.IDictionary]) {
        # merge it into our turtle dictionary
        foreach ($key in $v.Keys) {
            $this.'.Turtles'[$key] = $V[$key]
        }    
    } elseif ($v.pstypenames -contains 'Turtle') {
        # If it was a turtle, just add it

        # If the turtle had a non-timestamp id, use it
        if ($v.ID -notmatch 'turtle-\d{18,}') {
            $this.'.Turtles'[$v.ID] = $v
        } else {
            # otherwise, provide it an auto incremented ID
            $this.'.Turtles'["Turtle$($this.'.Turtles'.Count + 1)"] = $v
        }        
    } elseif ($v -is [int]) {
        # If the provided a number, let's create that many turtles.
        # Note: the automatic placement of these turtles might be nice, and may be added in the future.
        foreach ($n in 1..([Math]::Abs($value))) {
            $this.'.Turtles'["Turtle$($this.'.Turtles'.Count + 1)"] = turtle
        }    
    }
}

return $this.'.Turtles'