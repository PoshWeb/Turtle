@{
    name = 'PreviewUpload'
    uses = 'actions/upload-artifact@main'
    with = @{
        name = 'TurtlePreview'
        path = '**/psturtle.com/**'
    }
    if = '${{always()}}'
}

