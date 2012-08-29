### This file basically contains things that shouldn't be cached by Varnish after fetching from the backend

# Admin pages
if (req.url ~ "wp-(login|admin)" || req.url ~ "preview=true") { return (hit_for_pass); }


# Sitemaps (and remove the cookie, if any)
if (req.url ~ "\.xml(\.gz)?$") { unset beresp.http.cookie; return (hit_for_pass); }


# Images (and remove the cookie, if any)
if (req.url ~ "\.(jpg|jpeg|png|gif|ico|tiff|tif|bmp|ppm|pgm|xcf|psd|webp|svg)") { unset beresp.http.cookie; return (hit_for_pass); }


# CSS & JS
if (req.url ~ "\.(css|js)") { unset beresp.http.cookie; return (hit_for_pass); }


# Fonts
if (req.url ~ "\.(woff|eot|otf|ttf)") { unset beresp.http.cookie; return (hit_for_pass); }


# Other static content
if (req.url ~ "\.(zip|sql|tar|gz|bzip2)") { unset beresp.http.cookie; return (hit_for_pass); }


# If backend response is NOT 200.
if (beresp.status != 200) {
	set beresp.http.Cache-Control = "max-age=0";
	return (hit_for_pass);
}

