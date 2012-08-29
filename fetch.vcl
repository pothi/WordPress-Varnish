### This file basically contains things that shouldn't be cached

# Do not cache admin pages
if (req.url ~ "wp-(login|admin)" || req.url ~ "preview=true") { return (hit_for_pass); }


# Do not cache sitemaps (and remove the cookie, if any)
if (req.url ~ "\.xml(\.gz)?$") { unset beresp.http.cookie; return (hit_for_pass); }


# Do not cache images (and remove the cookie, if any)
if (req.url ~ "\.(jpg|jpeg|png|gif|ico|tiff|tif|bmp|ppm|pgm|xcf|psd|webp)") { unset beresp.http.cookie; return (hit_for_pass); }


# Do not cache CSS & JS
if (req.url ~ "\.(css|js)") { unset beresp.http.cookie; return (hit_for_pass); }


# Do not cache other static content
if (req.url ~ "\.(zip|sql|tar|gz|bzip2)") { unset beresp.http.cookie; return (hit_for_pass); }


# Do not cache anything, if backend response is NOT 200.
if (beresp.status != 200) {
	set beresp.http.Cache-Control = "max-age=0";
	return (hit_for_pass);
}

