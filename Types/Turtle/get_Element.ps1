<#
.SYNOPSIS
    Gets a Turtle as an Element    
.DESCRIPTION
    We can treat any Turtle as any arbitrary markup element.

    To do this, all we need to do is set an element name, and, optionally, add some attributes or children.
.EXAMPLE
    # Any bareword can become the name of an element, as long as it is not a method name
    turtle element div element
.EXAMPLE
    # We can provide anything that will cast to XML as an element
    turtle element '<div/>' element
.EXAMPLE
    # We can provide an element and attributes
    turtle element '<div class='myClass' />' element
.EXAMPLE
    # We can put a turtle inside of an aribtrary element
    turtle SpiderWeb element '<div />'
#>

# If we have set an element name
if ($this.'.Element'.ElementName) {

    # make this little filter to recursively turn the element back into XML
    filter toElement {
        $in = $_
        # If the input was a dictionary with an element name
        if ($in -is [Collections.IDictionary] -and $in.ElementName) {
            # start the markup
            "<$($in.ElementName)$(
                # and pop in any element attributes
                foreach ($attributeCollection in 'attr','attribute','attributes') {
                    if (-not $in.$attributeCollection) { continue }
                    if ($in.$attributeCollection -is [Collections.IDictionary]) {
                        foreach ($attributeName in $in.$attributeCollection.Keys) {
                            if ($attributeName -match '/') { continue }
                            ' ', $attributeName,"='",$in.$attributeCollection[$attributeName],"'" -join ''
                        }
                    } elseif ($in.$attributeCollection -is [string]) {
                        $in.$attributeCollection
                    }
                    break
                }
            )>$(
                # Now include any child elements.

                # If this defines any steps or text
                if ($this.Steps -or $this.Text) {
                    $this.SVG.OuterXml # we will need SVG
                } 
                elseif ($this.Markdown) {
                    $this.Markdown -join [Environment]::NewLine |
                        ConvertFrom-Markdown |
                            Select-Object -ExpandProperty Html
                }
                elseif (
                    # Otherwise, if the Turtle has turtles
                    $this.Turtles.Count
                ) {
                    # Go to each turtle
                    foreach ($child in $this.Turtles.Values) {

                        # Get it's element
                        $childElement = $child.Element

                        # That element could be XML or an XML Fragment
                        if ($childElement.OuterXml) {
                            # if so, that's our child element
                            $childElement.OuterXml
                        } elseif ($childElement.Markdown) {
                            "<article>$(
                                $childElement.Markdown -join [Environment]::Newline |
                                    ConvertFrom-Markdown
                            )</article>"
                        } elseif ($childElement) {
                            # It could also be another series of elements
                            # Stringify them
                            "$childElement"
                        }
                        else {
                            # Otherwise, presume the child did not expose an element
                            # (aka, it wasn't a Turtle)
                            # and output the child as a string.
                            "$child"
                        }                        
                    }
                }
                @(foreach ($childCollection in 'child','ChildNodes','Children','Content') {
                    if (-not $in.$childCollection) {
                        continue
                    }
                    foreach ($child in $in.$childCollection) {
                        # strings are directly included
                        if ($child -is [string]) {
                            $child
                        } elseif ($child -is [xml] -or $child -is [xml.xmlElement]) {
                            # xml elements will embed themselves
                            $child.OuterXml
                        } elseif ($child -is [Collections.IDictionary] -and $child.ElementName) {
                            # and dictionaries with an element name will recurisvely call ourselves.
                            $child | & $MyInvocation.MyCommand.ScriptBlock
                        } 
                        elseif ($child -is [Xml.XmlText]) {
                            [Security.SecurityElement]::Escape($child.InnerText)
                        }
                        else {
                            # Any other input will be stringified
                            "$child"
                        }
                    }
                    break
                }) -join ([Environment]::NewLine)
            )</$($in.ElementName)>"
        }
        if ($_ -is [string]) {
            $_
        }
    }

    $elementMarkup = $this.'.Element' | toElement
    $elementXml = $elementMarkup -as [xml]
    if ($elementXml) {
        $elementXml
    } else {
        $elementMarkup
    }
    return
}
elseif ($this.Markdown) {
    $article = "<article>$(
        $this.Markdown -join [Environment]::NewLine |
            ConvertFrom-Markdown |
                Select-Object -ExpandProperty Html
    )</article>"
    $articleXml = $article -as [xml]
    if ($articleXml) {
        $articleXml
    } else {
        $article
    }
    return 
}
else {
    return $this.SVG    
}

return
