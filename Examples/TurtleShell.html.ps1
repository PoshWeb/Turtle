param(
[string]
$Lucky = @'
turtle lucky
'@,

[PSObject[]]
$Examples = @(

# Any example code to render.

# Examples can use the command attribute to specify the command they run.

"<details name='examples'>"
"<summary>Examples</summary>"


#region Basic Examples

@"
<button class='reptile' id='circle' command='turtle circle 42 fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)'>Circle</button>
<button class='reptile' id='pie' command='turtle rotate (randomangle) pie 42 3 fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)'>Pie</button>
<button class='reptile' id='square' command='turtle rotate (randomangle) square 42 fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)'>Square</button>
<button class='reptile' id='rectangle' command='turtle rotate (randomangle) rectangle 42 fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)'>Rectangle</button>
<button class='reptile' id='star' command='turtle rotate (randomangle) star 42 (5,6,7,8,9 | Get-Random) fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)'>Star</button>
<button class='reptile' id='flower' command='turtle rotate (randomangle) flower 42 fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)'>Flower</button>
<button class='reptile' id='starflower' command='turtle rotate (randomangle) starflower 42 fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)'>Starflower</button>
<button class='reptile' id='stepspiral' command='turtle rotate (randomangle) stepspiral fill random random stroke random random'>Stepspiral</button>
"@

#endregion Basic Examples

#region Sector Examples
"
<blockquote>
<details open><summary>Sectors</summary>
"

@"
<button class='reptile' id='quadrants' command="turtle rotate (randomangle) @(
    'CircleArc',42, 90, 'Rotate', 90 * 4
) fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)">Quadrants</button>

<button class='reptile' id='antiquadrants' command="turtle rotate (randomangle) @(
    'CircleArc',42, -90, 'Rotate', 90 * 4
) fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)">Antiquadrants</button>

<button class='reptile' id='sextants' command="turtle rotate (randomangle) @(
    'CircleArc',42, 60, 'Rotate', 60 * 6
) fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)">Sextants</button>

<button class='reptile' id='antisextants' command="turtle rotate (randomangle) @(
    'CircleArc',42, -60, 'Rotate', 60 * 6
) fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)">Antisextants</button>

<button class='reptile' id='octants' command="turtle rotate (randomangle) @(
    'CircleArc',42, 45, 'Rotate', 45 * 8
) fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)">Octants</button>

<button class='reptile' id='antioctants' command="turtle rotate (randomangle) @(
    'CircleArc',42, -45, 'Rotate', 45 * 8
) fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)">Antioctants</button>
"@

"
</details>

</blockquote>
"
#endregion Sector Examples
#region Pie Examples
"<blockquote>"

"<details open><summary>Pies</summary>"

@"
<button class='reptile' id='pie3' command="
turtle rotate (randomangle) pie 42 3 fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)
">3 slices</button>

<button class='reptile' id='pie4' command="
turtle rotate (randomangle) pie 42 4 fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)
">4 slices</button>

<button class='reptile' id='pie5' command="
turtle rotate (randomangle) pie 42 5 fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)
">5 slices</button>

<button class='reptile' id='pie6' command="
turtle rotate (randomangle) pie 42 6 fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)
">6 slices</button>

<button class='reptile' id='pie7' command="
turtle rotate (randomangle) pie 42 7 fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)
">7 slices</button>

<button class='reptile' id='pie8' command="
turtle rotate (randomangle) pie 42 8 fill (randomcolor) (randomcolor) stroke (randomcolor) (randomcolor)
">8 slices</button>

"@

"</details>"

"</blockquote>"
#endregion Pie Examples
#region Polygon Examples
"<blockquote>"

"<details open><summary>Polygons</summary>"

@"
<button class='reptile' id='polygon3' command="
turtle rotate polygon 42 3 fill random random stroke random random
">Triangle</button>

<button class='reptile' id='polygon4' command="
turtle rotate polygon 42 4 fill random random stroke random random
">Square</button>

<button class='reptile' id='polygon5' command="
turtle rotate polygon 42 5 fill random random stroke random random
">Pentagon</button>

<button class='reptile' id='polygon6' command="
turtle rotate polygon 42 6 fill random random stroke random random
">Hexagon</button>

<button class='reptile' id='polygon7' command="
turtle rotate polygon 42 7 fill random random stroke random random
">Septagon</button>

<button class='reptile' id='polygon8' command="
turtle rotate polygon 42 8 fill random random stroke random random
">Octagon</button>

<button class='reptile' id='polygon9' command="
turtle rotate polygon 42 9 fill random random stroke random random
">Nonagon</button>

"@

"</details>"

"</blockquote>"
#endregion Pie Examples

)

)


"<html>"
"<head>"
"<title>TurtleShell</title>"
"</head>"
"<body>"
"<style>"

"
.invisible { display: none }
"

# Repl Input Grid

# A repl's input can be thought of as a simple grid:

"
.repl-command-grid {
    display: grid;
    text-align: center;
    grid-template-areas: 'variables' 'command' 'go'; 
    place-content: center; 
    place-items: center;
    grid-template-rows: auto auto auto;
    grid-template-columns: 1fr;
    gap: 0.5rem;
    padding: 0.5rem;
}
"

"
.repl-command { grid-area: command; width: 100%; }
.repl-go { grid-area: go; width: 50%; text-align: center; }
.repl-variables { grid-area: variables; width: 100%; }
"
"

"
"body { background-color: black; max-width: 100vw; height: 100vh; color: white; }"
".outputGrid {
    display: grid; 
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); 
    gap: 2.5em; 
    margin: 2.5em; 
    place-self: center;
    place-items: center;
}"
"table { width: 100%; border: 1px solid; }"
"th, td { border: 1px solid;}"

"output { display: block; }"

"button, summary { font-size: 1.25rem; padding: 0.25rem; }"
@"
.current-tabs {
    position: sticky;
    top: 1%;
    left: 1%;
    display: flex;
    flex: auto;
    flex-direction: column;    
}
"@
"</style>"

@"
<menu class='tabs'>
</menu>
"@

"
<div class='repl-command-grid'>
<details class='invisible repl-variables'><summary>Variables</summary></details>
<textarea class='repl-command' id='command' autocomplete='repl-command' rows='3' spellcheck='false'>
$Lucky
</textarea>
<button class='repl-go' id='go'>Go Turtle!</button>
</div>
"
"<menu>"
"<menu>"

@"
<button class='reptile' id='feelinglucky' command="$([Web.HttpUtility]::HtmlAttributeEncode($Lucky))">Lucky</button>
"@
"</menu>"
"<menu>"
$Examples
"</menu>"
"</details>"
"<output id='output'></output>"
"<ol id='output-item-list'>"    
"</ol>"

$scaleAnimation = "{ scale: ['100%', '105%','100%'] }, 67"

$TurtleShellJS = [Ordered]@{
    "getVariables" = "function(inputId) {

const inputElement = document.getElementById(inputId)
if (! inputElement) { return }
if (! inputElement.previousElementSibling) { return }

const variables = {}
for (const element of [
    ...inputElement.previousElementSibling.childNodes
]) {
    if (element === inputElement) { continue }
    if (element.name && element.value) {
        variables[element.name] = element.value
    }
}

return variables
}
"    
    "onInput" = "function() {
    console.log(this.value)
    
    // First we need to find all of the matching variable names
    const toAdd = []
    for (const match of [
        ...this?.value?.matchAll(/(?:\:|-{2}|\$|\@)(?<name>\w+)/g)
    ]) {
        toAdd.push(match.groups.name)
    }

    // If the length was zero
    if (toAdd.length == 0) {
        // make the previous sibling invisible
        this.previousElementSibling.classList.add('invisible')             
        return
    }

    // Then we need to figure out what changed
    const newVariables = []
    const removedVariables = []
    const uniqueVariables = []

    if (this.dataset?.variableNames) {
        
        if (this.dataset?.variableNames != toAdd.join(' ')) {
            var oldNames = this.dataset?.variableNames.split(' ')
            for (let index = 0; index < toAdd.length; index++) {
                if (index < oldNames.length) {
                    if (oldNames[index] != toAdd[index]) {
                        uniqueVariables.push({
                            name:toAdd[index], new:false, old: oldNames[index]
                        })
                    } else {
                        uniqueVariables.push({
                            name:toAdd[index], new:false
                        })
                    }
                } else {                    
                    uniqueVariables.push({name:toAdd[index], new:true})      
                }                    
            }            
        }                        
    } else {                
        for (const variableName of toAdd) {
            uniqueVariables.push({name:variableName, new:true})
        }
    }
    this.dataset['variableNames'] = toAdd.join(' ')
    this.previousElementSibling.classList.remove('invisible')
    for (const uniqueVariable of uniqueVariables) {
        if (uniqueVariable.new) {
            // new variable, create a new element
            const newInput = document.createElement('input')
            newInput.name = uniqueVariable.name
            newInput.id = this.id + '-' + uniqueVariable.name

            const newLabel = document.createElement('label')
            newLabel.setAttribute('for', newInput.id)
            newLabel.innerText = uniqueVariable.name

            this.previousElementSibling.appendChild(newLabel)
            this.previousElementSibling.appendChild(newInput)            
        }
        
        if (uniqueVariable.old) {
            // Variable with old name, rename
            const oldId = this.id + '-' + uniqueVariable.old
            const newId = this.id + '-' + uniqueVariable.name
            for (const childNode of [
                ...this.previousElementSibling.childNodes
            ]) {
                if (childNode.name == uniqueVariable.old) {
                    childNode.setAttribute('name', uniqueVariable.name)
                    childNode.setAttribute('id', newId)
                }
                if (childNode.getAttribute('for') == oldId) {
                    childNode.setAttribute('for', newId)
                    childNode.innerText = uniqueVariable.name
                }
            }
        }
    }
    console.log(uniqueVariables)
}"
    "go" = @"
async function() {
    let inputId = ''
    let inputScript = ''
    
    if (event?.target?.animate) {
        event.target.animate($scaleAnimation);
    }

    if (
        event?.target?.getAttribute && 
        event?.target?.getAttribute('command')
    ) {
        inputScript = event.target.getAttribute('command')
        
        inputId = turtleShell.newShell(inputScript)

        const outputId = inputId.replace(/^command/i, 'output')

        const out = document.getElementById(outputId)
        
        const response = await fetch(
            window.location.href,
            {method: 'POST',body: inputScript}
        )

        out.innerHTML = await response.text()

        out.animate({ scale: ['0%', '100%'] }, 67);        

        const inputElement = document.getElementById(inputId)
        if (inputElement) {
            inputElement.removeAttribute('disabled')
        }
        const goElement = document.getElementById(
            inputId.replace(/^command/i, 'go')
        )
        if (goElement) {
            goElement.removeAttribute('disabled')
        }
        return
    }
    if (event?.target?.previousSibling?.value && 
        event?.target?.previousSibling?.id.match(/^command/i)) {
        inputId = event?.target?.previousSibling?.id
        const outputId = inputId.replace(/^command/i, 'output')    
    }
    
    if (! inputScript && inputId == 'command' || ! inputId) {
        const repl = document.getElementById('command')
        
        repl.animate($scaleAnimation)

        inputId = turtleShell.newShell(
            repl.value, turtleShell.getVariables(repl.id)
        )
        document.getElementById(inputId).addEventListener('input',turtleShell.onInput)
        inputScript = repl.value                
    } else {
        const repl = document.getElementById(inputId)
        repl.setAttribute('disabled', 'true')
        inputScript = repl?.value
    }
        
    if (! inputScript) { return }

    const outputId = inputId.replace(/^command/i, 'output')
    const out = document.getElementById(outputId)
    const goElement = document.getElementById(
        inputId.replace(/^command/i, 'go')
    )
    if (goElement) {    
        goElement.setAttribute('disabled', 'true')
        
    }
    const inputElement = document.getElementById(inputId)    
    
    const requestBody = {
        command: inputScript
    }

    if (inputElement) {
        inputElement.animate($scaleAnimation);        
        const variables = turtleShell.getVariables(inputId)
        if (variables) {
            for (const variableName of Object.keys(variables)) {                
                requestBody[variableName] = variables[variableName]
            }
        }        
    }
    
    const response = await fetch(window.location.href,
        {
            headers: {"Content-Type": "application/json"},
            method: 'POST',
            body: JSON.stringify(requestBody)
        }
    )
    out.innerHTML = await response.text()
    out.animate({ scale: ['0%', '100%'] }, 67);
    
    if (inputElement) {
        inputElement.removeAttribute('disabled')
        inputElement.animate($scaleAnimation);
    }    
    if (goElement) {
        goElement.removeAttribute('disabled')
    }
}
"@
    "newShell" = @"    
        function (input, variables = {}) {

const now = new Date()

const outputItemList = document.getElementById('output-item-list')

const newListDetails = document.createElement('details')
newListDetails.setAttribute('open', '')

const newListSummary = document.createElement('summary')

newListSummary.innerText = outputItemList.childNodes.length
newListDetails.appendChild(newListSummary)
const newListGrid = document.createElement('div') 
newListGrid.classList.add('repl-command-grid')
newListDetails.appendChild(newListGrid)

const newListVariableArea = document.createElement('details')

const newListVariableSummary = document.createElement('summary')

newListVariableSummary.innerText = 'variables'

if (! variables || Object.keys(variables).length == 0) {
     newListVariableArea.classList.add('invisible')
}

newListVariableArea.classList.add('repl-variables')

for (const variableName of Object.keys(variables)) {
    
    const newInput = document.createElement('input')
    newInput.name = variableName
    newInput.value = variables[variableName]    
    newInput.id = 'command' + now.getTime() + '-' + variableName

    const newLabel = document.createElement('label')
    newLabel.setAttribute('for', newInput.id)
    newLabel.innerText = variableName

    newListVariableArea.appendChild(newLabel)
    newListVariableArea.appendChild(newInput)    
}

newListVariableArea.appendChild(newListVariableSummary)
newListGrid.appendChild(newListVariableArea)

const newListInput = document.createElement('textarea')
const inputLines = input.split(/(\r\n|\n|\r)/)

newListInput.setAttribute('spellcheck','false')
newListInput.setAttribute('autocomplete','repl-command')    
newListInput.setAttribute('rows',inputLines.length - 1)
newListInput.setAttribute('disabled', 'true')

newListInput.classList.add('repl-command')    
newListInput.id = 'command' + now.getTime()
newListInput.value = input
newListGrid.appendChild(newListInput)

const newListOutput = document.createElement('output')
newListOutput.id = newListInput.id.replace(/^command/i, 'output')

const newGoButton = document.createElement('button')    
newGoButton.id = newListInput.id.replace(/^command/i, 'go')
newGoButton.innerText = 'Go Turtle' 
newGoButton.classList.add('repl-go')
newGoButton.addEventListener('click', this.go)
newGoButton.setAttribute('disabled', 'true')
newListGrid.appendChild(newGoButton)                    
newListDetails.appendChild(newListOutput)

const topToBottom = true;
if (topToBottom && outputItemList.firstChild) {
    outputItemList.insertBefore(newListDetails, outputItemList.firstChild)
} else {
    outputItemList.appendChild(newListDetails)
}

newListDetails.animate({ scale: ['0%', '100%'] }, 67);

return newListInput.id
}
"@
}



"<script type='module'>"

@"

const turtleShell = {    
    $(
        @(foreach ($key in $TurtleShellJS.Keys) {
            "$($key): $($TurtleShellJS[$key])"
        }) -join (',' + [Environment]::NewLine + (' ' * 4))
    )
}

"@

@" 
for (const replInput of [
    ...document.querySelectorAll('.repl-command')
]) {
    replInput.addEventListener('input', turtleShell.onInput)
}

for (const goButton of [
    ...document.querySelectorAll('.reptile')
]) {
    goButton.addEventListener('click', turtleShell.go)
}

document.getElementById('go').addEventListener('click', turtleShell.go)
"@
""
"</script>"
"</body>"
"</html>"