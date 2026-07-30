@{
    # SVG Path Compatibility
    # (these methods directly reflect the corresponding instruction)
    a = 'Arc'
    c = 'CubicBezierCurve'
    l = 'Step'
    h = 'HorizontalLine'
    q = 'QuadraticBezierCurve'
    s = 'BezierCurve'
    v = 'VerticalLine'
    z = 'ClosePath'

    # Shorter forms:
    Pie = 'PieGraph'
    ArcR = 'ArcRight'
    ArcL = 'ArcLeft'
    Close = 'ClosePath'

    # Logo ('Original') Turtle Compatibility
    pd = 'PenDown'
    pu = 'PenUp'
    fd = 'Forward'
    lt = 'Left'
    rt = 'Right'
    bk = 'Backward'
    
    # Turtle Community Names
    triagon = 'triti'
    
    # Python Turtle Compatibility
    SetPos = 'GoTo'
    SetPosition = 'GoTo'        
    Back = 'Backward'
    xPos = 'xcor'
    yPos = 'ycor'

    # Python Turtle Compatibility That Will be Revised if/when the Turtle goes to 3D
    down = 'PenDown'
    up = 'PenUp'        
    r = 'Rotate'    
        
    # CSS shape pre-compatibility
    LineTo = 'GoTo'
    MoveTo = 'Teleport'
    HLineBy = 'HorizontalLine'
    VLineBy = 'VerticalLine'

    # Usability aliases
    Arm = 'Leg'
    Sticks = 'Spokes'
    
    # Synonyms
    Cobweb = 'Spiderweb'
    Web = 'Spiderweb'

    # Common transposition errors
    FlowerStar = 'StarFlower'
    FlowerGolden = 'GoldenFlower'
    PetalFlower = 'FlowerPetal'

    # Technically accurate aliases to more helpful names
    Href = 'Link'    
    Defs = 'Defines'
    MarkerMid = 'MarkerMiddle'
        
    # Aliasing plurals
    Arguments = 'ArgumentList'
    Args = 'ArgumentList'
    Argument = 'ArgumentList'
    Attributes = 'Attribute'
    PathAttributes = 'PathAttribute'
    TextAttributes = 'TextAttribute'
    SVGAttributes = 'SVGAttribute'
    Keyframes = 'Keyframe'
    '@Keyframes' = 'Keyframe'
    Styles = 'Style'
    Spoke = 'Spokes'
    Stick = 'Sticks'
    Rhombi = 'Rhombus'    

    # Anglican color property names
    BackgroundColour = 'BackgroundColor'    
    FillColour = 'FillColor'
    PenColour = 'PenColor'

    # Internationalized Method Names.  
    # These are technically more correct, but will not be easy to type on all keyboards.    
    BézierCurve = 'BezierCurve'
    Bézier = 'BezierCurve'
    
    QuadraticBézierCurve = 'QuadraticBezierCurve'
    
    CubicBézierCurve = 'CubicBezierCurve'    
    SierpińskiTriangle = 'SierpinskiTriangle'
    SierpińskiArrowHeadCurve = 'SierpinskiArrowHeadCurve'
    SierpińskiSquareCurve = 'SierpinskiSquareCurve'
    SierpińskiCurve = 'SierpinskiCurve'

    Bezier = 'BezierCurve'
    Cubic = 'CubicBezierCurve'

    # Shortened fractal names
    Terdragon = 'TerdragonCurve'

    # Symbols             
    '⭘' = 'Circle'            # 🐢 ⭘ 1
    '▯' = 'Rectangle'         # 🐢 ▯ 1
    '□'  = 'Square'            # 🐢 □ 1
    '∠' = 'Rotate'         # Angle should be rotate
    '⦣' = 'Left'           # Reversed angle should be reversed rotation
    '△' = 'Tri'            # Equilateral triangle should be `Tri`
    '⭢' = 'Forward'        # Forward should be `.Forward`
    '⭠' = 'Backward'       # Backward should be `.Backward`
    '⊿' = 'RightTriangle'      # 🐢 ⊿ -1 -1
    '⟁' = 'SierpinskiTriangle'
    '🕸' = 'Spiderweb'
    '☆' = 'Star'       # 🐢 ☆ 1 5
    '⬡' = 'Polygon'    # 🐢 ⬡ 1 6
    '⚘' = 'Flower'
    '⌒'  = 'Arc'
    '⪦'  = 'CircleArc' # 🐢 ⦣ 30 ⪦ 1 60

    # Compound symbols
    '⌒⬡' = 'Arcygon'    
    '⚘⭘' = 'Bloom'
    '⚘▯' = 'Goldenflower'    
    '⚘⊿' = 'Triflower'
    '⊿⚘' = 'Triflower'
    '⚘☆' = 'Starflower'
    '△△' = 'TriTri' # TriTri

    # Emoji
    '🌹' = 'Rose'

}