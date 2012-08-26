# To avoid storing 404, 502, 503 error pages in memory
if (beresp.status == 404 || beresp.status == 503 || beresp.status == 500) {
	set beresp.http.Cache-Control = "max-age=0";
	return (hit_for_pass);
}

# Do not cache admin pages

# Do not cache sitemaps

# Do not cache images

# Do not cache CSS & JS

# Do not cache other static content


