### Include this file in your vcl_fetch, if you are going to use CDN for the following filetypes
### Remove the file types that you don't put in CDN
### Even if you don't use a CDN and if you use memory for Varnish caching, then put it in your vcl_fetch too!

# Sitemaps
if (req.url ~ "\.xml(\.gz)?$") { unset beresp.http.cookie; return (hit_for_pass); }


# Images
if (req.url ~ "\.(jpg|jpeg|png|gif|ico|tiff|tif|bmp|ppm|pgm|xcf|psd|webp|svg)") { unset beresp.http.cookie; return (hit_for_pass); }


# CSS & JS
if (req.url ~ "\.(css|js)") { unset beresp.http.cookie; return (hit_for_pass); }


# Fonts
if (req.url ~ "\.(woff|eot|otf|ttf)") { unset beresp.http.cookie; return (hit_for_pass); }


# Other static content
if (req.url ~ "\.(zip|sql|tar|gz|bzip2)") { unset beresp.http.cookie; return (hit_for_pass); }

