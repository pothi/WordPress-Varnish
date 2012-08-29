### This file basically contains things that shouldn't be cached by Varnish after fetching from the backend

# Admin pages
if (req.url ~ "wp-(login|admin)" || req.url ~ "preview=true") { return (hit_for_pass); }


# If backend response is NOT 200.
if (beresp.status != 200) {
	set beresp.http.Cache-Control = "max-age=0";
	return (hit_for_pass);
}


# Do not cache any static content
include fetch-static-content.vcl
