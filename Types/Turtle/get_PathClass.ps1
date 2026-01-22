if ($this.'.PathClass') { return $this.'.PathClass'}

if ($this.stroke -match 'current|context') {
    $this.PathClass = 'foreground-stroke'    
}
    

return $this.'.PathClass'
