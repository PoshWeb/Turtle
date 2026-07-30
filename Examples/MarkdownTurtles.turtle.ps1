<#
.SYNOPSIS
    Markdown Turtles
.DESCRIPTION
    A Quick Demonstration of Markdown Turtles
#>

🐢 markdown @"
# Markdown Turtles

Turtles can be made of Markdown!

We simple say:

~~~PowerShell
turtle markdown `$Markdown
~~~

This set the Turtle's `.Markdown` property.

If no graphics, text, or custom element are present, then the Turtle will stringify to HTML.

"@ | Save-Turtle ./MarkdownTurtles.md