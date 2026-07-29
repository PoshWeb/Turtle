<#
.SYNOPSIS
    Sets a Turtle's CSS
.DESCRIPTION
    Set's a Turtle's CSS.

    This is any Turtle's `style`, without an enclosing tag.
.EXAMPLE
    turtle css @{
        ".big"= @{
            'font-size'='2rem'
        }
    } @{
        ".bigger"= @{
            'font-size'='3rem'
        }
    } @{
        ".biggest"= @{
            'font-size'='4rem'
        }
    } css
.EXAMPLE
    turtle keyframe ([Ordered]@{
        'slide-in' = [Ordered]@{
            from = [Ordered]@{
                translate = "-150vw 0"
                scale = "200% 1"            
            }
            to = [Ordered]@{
                translate = "0 0" 
                scale = "100% 1"
            }
        }
    }) css
#>
param()

# This just sets the style property.
$this.Style = @(
    # after unrolling arguments 
    $args | . { process { $_ }}
)
