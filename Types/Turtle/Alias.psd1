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

    # Shorter forms:
    Pie = 'PieGraph'
    ArcR = 'ArcRight'
    ArcL = 'ArcLeft'

    # Logo ('Original') Turtle Compatibility
    pd = 'PenDown'
    pu = 'PenUp'
    fd = 'Forward'
    lt = 'Left'
    rt = 'Right'
    bk = 'Backward' 
    
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
    Keyframes = 'Keyframe'
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
}