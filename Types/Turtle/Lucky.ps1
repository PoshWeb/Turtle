$luckyArgs = @(
    'rotate' 
    (Get-Random -Minimum 0 -Maximum 360)    

    $shapes = @(
        "flower", "starflower", "goldenflower", 'triflower',    
        "arcygon", "polygon", 
        "square", "circle", "rectangle", 'righttriangle',
        "sierpinskitriangle","sierpinskiarrowheadcurve",
        "hilbertcurve", "moorecurve", "flowerpetal",    
        'Spiderweb','pentaplexity',"kochsnowflake",
        'TurtleMonotile','HatMonotile',
        'bargraph','piegraph'
    )
    $shapes | 
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
$title = $luckyArgs -join ' '
if ($this.id -notmatch 'turtle-?\d+') {
    $id = $this.id, $id -join '-'
    $title = $this.title, $title -join ' '
}
$this | turtle id $id title $title @luckyArgs
