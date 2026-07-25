function jump(distance) {
    return this.penUp().step(
        distance * Math.cos(this.heading * Math.PI / 180),
        distance * Math.sin(this.heading * Math.PI / 180)
    ).penDown()
}