### This file basically contains things that shouldn't be cached by Varnish after fetching from the backend

# Comment out only one of the following *if* conditions
# Second *if* condition is already commented out, if you forgot to read this line;
if (req.http.Host != "domainname.com") { return (hit_for_pass); }
# if (req.http.Host != "www.domainname.com") { return (hit_for_pass); }

# Admin pages
if (req.url ~ "wp-(login|admin)" || req.url ~ "preview=true") {
	set beresp.http.Cache-Control = "max-age=0";
	return (hit_for_pass);
}


# If backend response is NOT 200.
if (beresp.status != 200) {
	set beresp.http.Cache-Control = "max-age=0";
	return (hit_for_pass);
}


# Do not cache any static content
include fetch-do-not-cache-static-content.vcl
