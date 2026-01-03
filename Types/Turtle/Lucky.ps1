$luckyArgs = @(
    'rotate' 
    (Get-Random -Minimum 0 -Maximum 360)    
    "flower", "starflower", "goldenflower",    
    "arcygon", "polygon", 
    "square", "circle", "rectangle", 'righttriangle',
    "sierpinskitriangle","sierpinskiarrowheadcurve",
    "hilbertcurve", "moorecurve", "flowerpetal",
    "fractalplant","fractalshrub",
    'Spiderweb','pentaplexity',
    "kochisland","kochsnowflake",
    'ringfractal','crystalfractal','boardfractal',
    'bargraph','piegraph' | 
        Get-Random
    if ($true, $true, $false | Get-Random) {
        'fill'    
        foreach ($n in 1..(Get-Random -Minimum 2 -Maximum 3)) {
            'random'        
        }    
        if ($true, $false, $false | Get-Random) {
            'fillrule'
            'evenodd'
        }
    }
    
    'stroke'
    @(
        foreach ($n in 1..(Get-Random -Min 2 -Maximum 3)) {
            'random'
        }
    )     
)

$id = $luckyArgs -join '-'
turtle id $id title $($luckyArgs -join ' ') @luckyArgs
