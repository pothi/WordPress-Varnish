### This file basically contains things that shouldn't be cached by Varnish after fetching from the backend

# Do not cache the domains listed in the following file
include "fetch-do-not-cache-domains.vcl";

# Admin pages
if (req.url ~ "wp-(login|admin)" || req.url ~ "preview=true") {
	set beresp.http.Cache-Control = "max-age=0";
	return (hit_for_pass);
}

# Contact Pages
if (req.url ~ "contact") {
    return (hit_for_pass);
}


# If backend response is NOT 200.
if (beresp.status != 200) {
	set beresp.http.Cache-Control = "max-age=0";
	return (hit_for_pass);
}


# Do not cache any static content
include "fetch-do-not-cache-static-content.vcl";
