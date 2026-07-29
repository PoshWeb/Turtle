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
.EXAMPLE
    # If we just define text and ask for an element, we get a paragraph (`<p>`)
    turtle text "hello world" element
.EXAMPLE
    # If we just define markdown and ask for an element, we get an `<article>`
    turtle markdown "# hello world" element
#>
param()

# The Turtle can be rendered in many elements.

# We can render the turtle in an arbitrary 

filter asXmlOrText {
    $asXml = $_ -as [xml]
    if ($asXml) { $asXml } else { $_ }
}

filter addAttributes {
    if (-not $this.Attribute.Count) { return }
    ' ' + (@(foreach ($attr in $this.Attribute.GetEnumerator()) {
        if ($attr.Key -match '/') { continue }
        "$($attr.Key)='$(
            [Web.HttpUtility]::HtmlAttributeEncode($attr.Value)
        )'"
    }) -join ' ')
}

$turtleStyle = $this.Style

# If we have set an element
if ($this.'#Element') {

    # make this little filter to recursively turn the element back into markup
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
        elseif ($in -is [string]) {
            $in
        }
        elseif ($in -is [object[]]) {
            foreach ($inin in $in) {
                "$inin"
            }
        }
    }

    $elementMarkup = $this.'#Element' | toElement

    return $elementMarkup | asXmlOrText
}
elseif ($this.Markdown) {
    $article = "<article$(addAttributes)>$(
        $this.Markdown -join [Environment]::NewLine |
            ConvertFrom-Markdown |
                Select-Object -ExpandProperty Html
    )</article>"
    return $article | asXmlOrText
}
elseif ($this.Text -and -not $this.Steps) {
    $paragraph = "<p$(addAttributes)>$([Security.SecurityElement]::Escape($this.Text))</p>"
    return $paragraph | asXmlOrText
}
elseif ($turtleStyle -and -not $this.Steps) {
    # Fun factoid:
    # Most of CSS will work in XML, but not all.
    # Any syntax references (i.e. `<color>`) do not work if XML encoded.
    # Therefore, we should return this element as string
    return "<style>$($turtleStyle.style)</style>"
}
else {
    return $this.SVG
}

return
