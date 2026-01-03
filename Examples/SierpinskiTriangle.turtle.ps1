$myName = $MyInvocation.MyCommand.Name -replace '\.turtle\.ps1$'
$turtle = turtle id SierpinskiTriangle-15-5 SierpinskiTriangle 15 5 stroke '#4488ff'
$turtle | Save-Turtle "./$myName.svg" 
$turtle | Save-Turtle "./$myName.png" -Property PNG
