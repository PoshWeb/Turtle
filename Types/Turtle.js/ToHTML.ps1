<#
.SYNOPSIS
    A Tiny Turtle
.DESCRIPTION
    A minimal implementation of Turtle graphics in PowerShell and JavaScript, with and a speed test.
.EXAMPLE
    ./TinyTurtle.html.ps1 > ./TinyTurtle.html
#>

[string] $commandsToParse = $this.ArgumentList.ForEach({ "'{0}'" -f $_ }) -join ', '

@"
<div><turtle>
<svg width='100%' height='100%' id='$( $this.Id )'>
    <path id='turtle-path'
        fill = '$( $this.Fill )'
        stroke = '$( $this.Stroke )'
        stroke-width = '$( $this.StrokeWidth )'
        stroke-linecap = 'round'
    ></path>
    <text id='counter' font-size='12px' x='50%' y='50%' text-anchor='middle' dominant-baseline='middle'></text>
</svg>
</turtle>
<script>
let counter = 0;
let time = new Date()
function draw() {
    requestAnimationFrame(draw)
    const turtle = $this
    const cmds = [ ${commandsToParse} ]
    const actions = turtle.parse( ...cmds )
    actions.forEach( (action) => { turtle.go( action.method, action.arguments ) } )

    let turtleElement = document.querySelector('turtle')
    let svg = turtleElement.querySelector('#stage')
    svg.setAttribute('viewBox', ``0 0 `${turtle.width} `${turtle.height}``)
    let path = turtleElement.querySelector('#turtle-path')
    path.setAttribute('d', turtle.pathData())
    counter++

    document.getElementById('counter').textContent =
        ```${Math.round(counter/((new Date() - time)/1000)*100)/100} fps``
}
draw()
</script>
"@
