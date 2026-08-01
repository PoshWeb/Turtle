<#
.SYNOPSIS
    Layout script
.DESCRIPTION
    This script is used to layout a page with a consistent style and structure.

    If a file generates HTML but does not include a `<html>` tag, it's output should be piped to this script.

    Any directories without a layout should use the nearest `layout.ps1` file in a parent directory.

    Layout parameters can be provided by the site or page.
#>
param(
    # The name of the palette to use.
    [Alias('Palette')]
    [string]
    $PaletteName = $(
        if ($Site -and $Site['PaletteName']) { $Site['PaletteName'] }
        else { 'Konsolas' }
    ),

    # The Google Font name
    [Alias('FontName')]
    [string]
    $Font = $(
        if ($Site -and $Site['FontName']) { $Site['FontName'] }
        else { 'Roboto' }
    ),

    # The Google Code Font name
    [string]
    $CodeFont = $(
        if ($Site -and $Site['CodeFontName']) { $Site['CodeFontName'] }
        else { 'Inconsolata' }
    ),
    
    # The urls for any fav icons.
    [string[]]
    $FavIcon,
    
    # The taskbar icons.
    # The key should be the icon name or content, and the value should be the URL.
    # SVG icons should be included inline so they may be stylized.
    [Collections.IDictionary]
    $Taskbar = $(        
        if ($page -and $page['Taskbar']) { $page.Taskbar }
        elseif ($Site -and $site['Taskbar']) { $site['Taskbar'] }
        else { [Ordered]@{} }
    ),

    # The header menu.
    [Collections.IDictionary]
    $HeaderMenu = $(
        if ($page -and $page.'HeaderMenu' -is [Collections.IDictionary]) {
            $page.'HeaderMenu'
        } elseif ($Site -and $site.'HeaderMenu' -is [Collections.IDictionary]) {
            $site.'HeaderMenu'
        } else {
            [Ordered]@{}
        }
    ),

    # The footer menu.
    [PSObject[]]
    $Footer = @(
        if ($page.Footer) {
            $page.Footer
        } elseif ($Site -and $site.Footer) {
            $site.Footer
        } else {
            ''
        }
    )
)

# The literal first thing we do is to capture the arguments and input.
# This is important beecause `$input` can only be read once.
$allInput = @($input)
$allArguments = @($args)
$argsAndinput = @($args) + @($allInput)

#region Initialize Site and Page
if (-not $Site) { $Site = [Ordered]@{} }
if (-not $page) { $page = [Ordered]@{} }
if (-not $page.MetaData) { $page.MetaData = [Ordered]@{} }
#endregion Initialize Site and Page

#region Initialize Metadata
$page.MetaData['og:title'] =
    if ($title) { $title }
    elseif ($Page.title) { $Page.title } 
    elseif ($site.title) { $site.title }

$page.MetaData['og:description'] =
    if ($description) { $description }
    elseif ($page.description) { $page.description }
    elseif ($site.description) { $site.description }

$page.MetaData['og:image'] =
    if ($image) { $image } 
    elseif ($page.image) { $page.image } 
    elseif ($site.image) { $site.image }

if ($page.Date -is [DateTime]) {
    $page.MetaData['article:published_time'] = $page.Date.ToString('o')
}

if ($page.MetaData['og:image']) {
    $page.MetaData['og:image'] = $page.MetaData['og:image'] -replace '^/', '' -replace '^[^h]', '/'
}
#endregion Initialize Metadata

filter outputHtml {
    $outputItem = $_
    switch ($outputItem) {
        {$outputItem -is [string]} { return $outputItem }
        {$outputItem -is [xml]} { return $outputItem.OuterXml }
        {$outputItem.HTML} { return $outputItem.HTML }
        {$outputItem.Markdown} { return (ConvertFrom-Markdown -InputObject (
            $outputItem.Markdown -join [Environment]::NewLine
        )).HTML }
        default { "$outputItem" }
    }
}

$outputHtml = @($argsAndinput | outputHtml) -join [Environment]::NewLine


#region Declare global styles
$grid = [Ordered]@{display='grid'}
$flex = [Ordered]@{display='flex'}

$turtleStyle = 🐢 style ([Ordered]@{
    body =
        [Ordered]@{
            'max-width' = '100%'
            'height' = '100vh'
            'font-family' = "'$font', sans-serif"
        }

    header = 
        $grid + [Ordered]@{        
            'position' = 'sticky'
            'grid-area' = 'header'
            'grid-template-areas' = '"social title options"'
            'grid-template-columns' = '1fr 3fr 1fr'
            'transform-style' = 'preserve-3d'
            'top' = '0vh'
            'left' = '0vw'
            'max-width' = '100%'
            'height' = '10rem'
            'z-index' = 10
            'margin' = '1rem'
            'gap' = '0.5rem'            
            'background' = 
                'color-mix(in srgb, var(--background) 25%, transparent)'
        }

    footer =
        $grid + [Ordered]@{
            'grid-area'='footer'
            'position'='sticky'    
            'grid-template-rows' ='auto auto'
            'max-width' = '100vw'
            'height' = '1vh'
            'bottom' =  '0'
            'z-index' = 100
        }


    'article' = 
        [Ordered]@{
            'background' = 
                'color-mix(in srgb, var(--background) 50%, transparent)'
        }

    '.background' = [Ordered]@{
        'position' = 'fixed'
        'top' = 0
        'left' = 0
        'max-width' = '100%'
        'height' = '100%'
    }

    '.foreground' = $grid + [Ordered]@{        
        'grid-template-rows' = 'auto 1fr auto'
        'grid-template-areas' = '"header" "main" "footer"'
    }    

    '.main' = [Ordered]@{
        'grid-area' = 'main'
        'max-width' = '90%'
        'margin-top' = '10rem'
        'padding-left' = '5%'
        'padding-right' = '5%'
        'font-size' = if ($page.FontSize) {
            $page.FontSize
        } elseif ($site.FontSize) {
            $site.FontSize
        } else {
            "1.23em"
        }
        'line-height' = '1.5rem'        
    }

    '.social' = $flex + [Ordered]@{
        'grid-area' = 'social'        
    }
    
    '.title' = [Ordered]@{
        'grid-area' = 'title'
        'place-self' = 'center'
        'place-items' = 'center'
        'text-align' = 'center'
    }

    '.options' = [Ordered]@{
        'grid-area' = 'options'
    }


    '@keyframes grow-progress' = [Ordered]@{
        from = @{transform='scaleX(0) scaleY(1)'}
        to = @{transform='scaleX(1) scaleX(3)'}
    }

    ".scroll-progress"  = [Ordered]@{
        'max-width' = '100%'
        'height' = '1rem'
        'margin-top' = 'auto'
        'margin-bottom' = 'auto'
        'left' = 0
        'transform-origin' = '0 50%'
        'background' = 'linear-gradient(to right, transparent, var(--foreground))'
        'animation' = 'grow-progress auto linear'
        'animation-timeline' = 'scroll()'
    }

    'header > svg' = [Ordered]@{
        'display' = 'block'
        'text-align' = 'center'
    }


    ".logo" = [Ordered]@{ 
        'display' ='inline'
        'height'  = '7rem'
    }

    'pre, code' = [Ordered]@{ 'font-family' = "'$CodeFont', monospace" }

    "a, a:visited" = [Ordered]@{'text-decoration' ='none'}

    "a:hover, a:focus" = [Ordered]@{'text-decoration' ='underline'}

    ".backdrop-svg" = [Ordered]@{"z-index"= -100}
    ".backdrop-canvas" = [Ordered]@{"z-index"= -99}

    ".row-or-column" = [Ordered]@{        
        'flex-direction' = 'row'
    }


    '@media (orientation: landscape)' = [Ordered]@{
        '.row-or-column'  = @{'flex-direction' = 'row'}
        '.logo' = @{height='4.2rem'}
        '.site-title, .page-title' = [Ordered]@{
            'font-size' = '1.23rem'
            'line-height' = '0.75rem'
        }
    }

    '@media (orientation: portrait)' = [Ordered]@{
        '.row-or-column'  = @{'flex-direction' = 'column'}
        '.logo' = @{height='2.3rem'}
        '.page-title, .site-title' = [Ordered]@{
            'font-size' = '0.84rem'
            'line-height' = '0.66rem'
        }
    }




    #region HighlightJS
    '.hljs' = [Ordered]@{
        background = 'color-mix(in srgb, var(--background) 75%, transparent)'
        color = 'var(--foreground)'
    }
    '.hljs-number' = @{color='var(--cyan)'}
    '.hljs-type' = @{color='var(--purple)'}
    '.hljs-string' = @{color='var(--brightWhite)'}
    
    '.hljs-built_in' = [Ordered]@{
        color = 'var(--brightBlue)'
        'font-weight' = 'demibold'
    }

    '.hljs-variable' = [Ordered]@{
        color = 'var(--green)'
        'font-weight' = 'demibold'
    }

    '.hljs-comment' = [Ordered]@{
        color = 'var(--brightGreen)'
        'font-weight' = 'demibold'
    }

    ".hljs-literal" = @{
        color='var(--brightWhite)'
    }
    
    #endregion HighlightJS
})
#endregion Declare global styles

#region Page Header
# Set up all of the header elements
$headerElements = @(
    # * Google Analytics
    if ($site.analyticsID) {
        "<!-- Google tag (gtag.js) -->
        <script async src='https://www.googletagmanager.com/gtag/js?id=$($site.AnalyticsID)'></script>
        <script>
            window.dataLayer = window.dataLayer || [];
            function gtag(){dataLayer.push(arguments);}
            gtag('js', new Date());
            gtag('config', '$($site.AnalyticsID)');
        </script>"
    }
    # * Viewport metadata
    "<meta name='viewport' content='width=device-width, initial-scale=1, minimum-scale=1.0' />"
    "<meta charset='utf-8' />"
    # * Open Graph metadata
    if ($Page.MetaData -is [Collections.IDictionary] -and $Page.MetaData.Count) {
        foreach ($og in $Page.MetaData.GetEnumerator()) {
            "<meta name='$([Web.HttpUtility]::HtmlAttributeEncode($og.Key))' content='$([Web.HttpUtility]::HtmlAttributeEncode($og.Value))' />"
        }
    }
    # * RSS autodiscovery
    if (-not $site.NoRss) { "<link rel='alternate' type='application/rss+xml' title='$($site.Title)' href='/RSS/index.rss' />" }
    # * Color palette
    if ($PaletteName) { "<link rel='stylesheet' href='https://cdn.jsdelivr.net/gh/2bitdesigns/4bitcss@latest/css/$PaletteName.css' id='palette' />" }
    # * Google Font
    if ($Font) { "<link rel='stylesheet' href='https://fonts.googleapis.com/css?family=$Font' id='font' />" }
    # * Code font
    if ($CodeFont) { "<link rel='stylesheet' href='https://fonts.googleapis.com/css?family=$CodeFont' id='codeFont' />" }
    # * highlightjs css ( if using highlight )
    if ($Site.HighlightJS -or $page.HighlightJS) {
        "<link rel='stylesheet' href='https://cdn.jsdelivr.net/gh/highlightjs/cdn-release@latest/build/styles/default.min.css' id='highlight' />"
        '<script src="https://cdn.jsdelivr.net/gh/highlightjs/cdn-release@latest/build/highlight.min.js"></script>'
        foreach ($language in $Site.HighlightJS.Languages) {
            "<script src='https://cdn.jsdelivr.net/gh/highlightjs/cdn-release@latest/build/languages/$language.min.js'></script>"
        }
    }
    # * favicons 
    if ($FavIcon) {
        switch -regex ($FavIcon) {
            '\.(?>svg|png)$' {
                $contentType = $matches.0 -replace 'svg', 'svg+xml' -replace '^', 'image'
                # (try to match the size,
                if ($_ -match '\d+x\d+') {
                    "<link rel='icon' href='$_' type='$contentType' sizes='$($matches.0)' />"
                } else {
                    # otherwise, use 'any' size)
                    "<link rel='icon' href='$_' type='$contentType' sizes='any' />"
                }
            }
        }
    }    
    # * HTMX
    if (-not $Site.NoHtmx -or $page.NoHtmx) {
        "<script src='https://unpkg.com/htmx.org@latest'></script>"
    }
    $ImportMap
    # * Our styles
    "$turtleStyle"
)

$background = @(
    # * The background layers        
    "<svg class='background backdrop-svg' id='background-svg' width='100%' height='100%'>"
    if ($page.Background -is [xml]) {
        $page.Background.OuterXml
    }
    elseif ($site.Background -is [xml]) {
        $site.Background.OuterXml
    }
    "</svg>"
    "<canvas id='background backdrop-canvas' width='0' height='0'></canvas>"
)

$header = @(
# * The header
    "<header>"
        "<section class='social row-or-column'>"
            if ($taskbar) {
            # * Our taskbar    
            foreach ($taskbarItem in $taskbar.GetEnumerator()) {
                $itemIconAndOrName = 
                    if ($page -and $page.Icon."$($taskbarItem.Key)") {                     
                        $page.Icon[$taskbarItem.Key]
                        if ($site.ShowTaskbarIconText -or $page.ShowTaskbarIconText) {
                            $taskbarItem.Key
                        }                    
                    }
                    elseif ($site -and $site.Icon."$($taskbarItem.Key)") { 
                        $site.Icon[$taskbarItem.Key]
                        if ($site.ShowTaskbarIconText -or $page.ShowTaskbarIconText) {
                            $taskbarItem.Key
                        }                
                    }
                    else { $taskbarItem.Key }
                $taskBarContent = $taskbarItem.Value                
                if ($taskBarContent -match '[<>]') {
                    "<details>"
                    "<summary>"
                    $itemIconAndOrName
                    "</summary>"
                    $taskbarItem.Value                    
                    "</details>"
                } else {
                    "<a href='$($taskBarContent)' class='icon-link' target='_blank'>"
                    "<button>"
                    $itemIconAndOrName
                    "</button>"
                    "</a>"
                }
                
            }
            "</div>"
        }
        "</section>"
        "<section class='title'>"
        if ($page.Header) {
            $page.Header -join [Environment]::NewLine
        } elseif ($site.Header) {
            $site.Header -join [Environment]::NewLine
        } else {
            "<a href='/'>"
            @(
                "<svg xmlns='http://www.w3.org/2000/svg' class='logo'>" + $(
                    if ($site.Logo) {
                        if ($site.Logo -match '<svg') { $site.Logo -replace '<\?.+>' }
                        else { "<image src='$($site.Logo)' class='logoImage' />" }
                    }
                ) + "</svg>"
                if ($site.Title) {
                    "<h1 class='site-title'>$([Web.HttpUtility]::HtmlEncode($site.Title))</h1>"
                }
                elseif ($site.CNAME) {                    
                    "<h1 class='site-title'>$([Web.HttpUtility]::HtmlEncode($site.CNAME))</h1>"
                }
            ) -join (
                [Environment]::NewLine + "<br/>" + [Environment]::NewLine
            )
            "</a>"
            if ($page.Title -and $page.Title -ne $site.Title) {
                "<h2 class='page-title'>$([Web.HttpUtility]::HtmlEncode($page.Title))</h2>"
            }            
        }
        "</section>"
        "<section class='options'>"
            . /_includes/Palette
        "</section>"
    "</header>"
)

$footer = @(
    # * The footer
    "<footer>"
    "<section class='footer-options'>"    
    "</section>"        
    "<section class='scroll-progress'>"
    "</section>"
    "</footer>"
)

# Now we declare the body elements
$bodyElements = @(    
    
    $background
    
    
    "<section class='foreground'>"
    

        $header

        "<section class='main'>$outputHtml</section>"    

        $Footer    

    "</section>"

    if ($site.HighlightJS -or $page.HighlightJS) {
        "<script>hljs.highlightAll();</script>"
    }
)

🐢 element "<html>
    <head>
        <title>$(if ($page['Title']) { $page['Title'] } else { $Title })</title>
$($headerElements -join [Environment]::NewLine)
    </head>
    <body>
$($bodyElements -join [Environment]::NewLine)
</body>
</html>" element