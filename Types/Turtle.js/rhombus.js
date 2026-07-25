function rhombus(side1 = 42, side2 = 42, angle = 42) {
    return this.
        forward(side1).rotate(angle).
        forward(side2).rotate(180-angle).
        forward(side1).rotate(angle).
        forward(side2).rotate(180-angle)
}
