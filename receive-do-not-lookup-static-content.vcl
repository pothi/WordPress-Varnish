# Sitemaps
if (req.url ~ "\.xml(\.gz)?$") {
    return (pass);
}


# Images
if (req.url ~ "\.(jpg|jpeg|png|gif|ico|tiff|tif|bmp|ppm|pgm|xcf|psd|webp|svg)") {
    return (pass);
}


# CSS & JS
if (req.url ~ "\.(css|js)") {
    return (pass);
}


# Fonts
if (req.url ~ "\.(woff|eot|otf|ttf)") {
    return (pass);
}


# Other static content
if (req.url ~ "\.(zip|sql|tar|gz|bzip2)") {
    return (pass);
}