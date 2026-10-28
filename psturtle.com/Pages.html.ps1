if (-not $page) {$page = [Ordered]@{}}

🐢 palette @{
    foreground = '#ffffff'
    background = '#000000'
} style ([Ordered]@{
    'body' = [Ordered]@{
        'color' = 'lightdark(var(--foreground),var(--background))'
        'background-color' = 'lightdark(var(--background),var(--foreground))'
    }    
})

$title = $page.Title = 'Turtles in a Page'

🐢 markdown "# $title"

🐢 markdown "## Writing Websites with Turtle"

🐢 text "Turtles are interesting creatures"

🐢 text "In PowerShell, Turtles are just objects that become elements"

🐢 text "This page is written in Turtle"


🐢 markdown @"
### How This Works

A virtual turtle is just an object in memory

When we show the turtle, we are simply turning it into a string.

Our Turtle can be any element
"@

$sampleStyles = {
    🐢 element "<b>Bold</b>"

    turtle element "<i>Italic</i>"

    Get-Turtle element "<u>Underline</u>"

    turtle element "<span>even</span>"

    🐢 element "<s>Strikeout</s>"
}

. $sampleStyles | . { process { $_ } }

🐢 markdown @"
## Turtle aliases

We can call Turtle with any of it's aliases. 

~~~PowerShell
🐢 element "<b>Bold</b>"

turtle element "<i>Italic</i>"

Get-Turtle element "<u>Underline</u>"

turtle element "<span>even</span>"

🐢 element "<s>Strikeout</s>"
~~~
"@

🐢 markdown @"
### Turtle markdown

Turtles can be markdown.

~~~PowerShell
🐢 markdown "# Hello World"
~~~
"@


🐢 markdown @"
### Turtle Style

Turtles can have style.

We can set the style with any object.  

We always get the style as a `<style></style>` element

This will output the turtle's style as CSS

~~~PowerShell
🐢 style @{".big" = @{'font-size'='2rem'}} css
~~~

~~~css
$(🐢 css @{".big" = @{'font-size'='2rem'}} css)
~~~

This will output a ``<style>`` element and a ``<h1>`` that uses it 

~~~PowerShell
`$((
    🐢 style @{".big" = @{'font-size'='2rem'}} style
).OuterXml)
`$(🐢 element '<h1 class="big">Big</h1>')
~~~

~~~html
$((
    🐢 style @{".big" = @{'font-size'='2rem'}} style
).OuterXml)
$(🐢 element '<h1 class="big">Big</h1>')
~~~

"@