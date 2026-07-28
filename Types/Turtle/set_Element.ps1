<#
.SYNOPSIS
    Sets the Turtle element
.DESCRIPTION
    Sets the Turtle to an arbitrary element.

    This lets us write web pages and xml entirely in turtle.
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
    turtle element "
        <>
            <Example />
            <Links />
        </>
    " element
#>

param()

if (-not $this) {
    $this = turtle
}

# If we have not set an element, initialize it to a property bag.
if (-not $this.'#Element') {
    $this | Add-Member NoteProperty '#Element' -Value ([Ordered]@{
        ElementName=''
        Attribute=$this.Attribute
        Children=@()
    })
}

$unrolledArgs = $args |. {process { $_ }}

foreach ($element in $unrolledArgs){
    if ($element -is [string] -and 
        (-not ($element -as [xml])) -and 
        $element -notmatch '\s'
    ) {
        $this.'#Element'.ElementName = $Element
        continue
    }

    if ($element -is [xml] -or $Element -as [xml]) {
        if ($Element -isnot [xml]) {
            $element = $Element -as [xml]
        }
        $this.'#Element'.ElementName = $Element.ChildNodes[0].LocalName
        foreach ($attribute in $element.ChildNodes[0].Attributes) {
            $this.'#Element'.Attribute[$attribute.Name] = $attribute.Value
        }
        foreach ($grandchild in $element.ChildNodes[0].ChildNodes) {
            $this.'#Element'.Children += $grandchild
        }
        continue
    }
        
    if ($element -is [Collections.IDictionary]) {        
        $elementKeys = 'ElementName','Name','E'
        
        foreach ($potentialName in $elementKeys) {
            if ($element.$potentialName) {
                $this.'#Element'.ElementName = $element.$potentialName
                break
            }
        }

        $attributeKeys = 'Attribute', 'Attributes', 'A'
        foreach ($potentialAttributeName in $attributeKeys) {
            if ($element.$potentialAttributeName -is [Collections.IDictionary] -and 
                $element.$potentialAttributeName.Count) {
                foreach ($attributeName in $element.$potentialAttributeName.Keys) {
                    $this.'#Element'.Attribute[$attributeName] = $element.$potentialAttributeName[$attributeName]
                }
                break
            }
        }

        $childKeys = 'Child', 'Children', 'ChildNodes','Content', 'C'
        
        foreach ($potentialChildrenName in $childKeys) {
            $children = $element.$potentialChildrenName
            if (-not $children) { continue }
            $this.'#Element'.Children += $children
            break
        }

        $specialKeys = @(
            $elementKeys
            $attributeKeys
            $childKeys
        )
        
        foreach ($elementKey in $element.Keys) {
            if ($elementKey -in $specialKeys) { continue }
            $elementValue = $element[$elementKey]
            if ($elementValue -is [ValueType] -or (
                $elementValue -is [string] -and $elementValue -notmatch '[\r\n]'
            )) {
                $this.'#Element'.Attribute[$elementKey] = $elementValue
            }
        }
        continue        
    }

    
    if ($elementName) {
        $this.'#Element'.ElementName = $element
    } else {
        $this.'#Element' = $element
    }
}

return $this