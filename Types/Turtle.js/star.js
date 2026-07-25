function star(size = 42, points = 6) {
    let angle = 360 / Math.round(points)
    let segmentLength = size*2/points
    for (let n =0; n < Math.abs(Math.round(points)); n++) {
        this.rotate(angle).forward(segmentLength).rotate(angle * -1).forward(segmentLength).rotate(angle)
    }    
    return this
}