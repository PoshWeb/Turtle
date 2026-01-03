$luckyArgs = @(
    'rotate' 
    (Get-Random -Minimum 0 -Maximum 360)    
    "arcygon", "flower", "starflower", "square", 
        "circle", "rectangle", "sierpinskitriangle", 
            "polygon", "flowerpetal" | Get-Random
    'fill'
    @(
        foreach ($n in 1..(Get-Random -Min 2 -Maximum 3)) {
            'random'
        }
    )
    'stroke'
    @(
        foreach ($n in 1..(Get-Random -Min 2 -Maximum 3)) {
            'random'
        }
    ) 
    @(
        if ($true, $false, $false | Get-Random) {
            'fillrule'
            'evenodd'
        }
    )
)
turtle @luckyArgs
