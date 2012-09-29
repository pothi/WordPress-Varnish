# Check the cookies for wordpress-specific cookies
if (req.http.Cookie ~ "wordpress_" || req.http.Cookie ~ "comment_") {
	return (pass);
}

# Check the admin pages
if (req.url ~ "wp-(login|admin)" || req.url ~ "preview=true") {
	return (pass);
}

# Contact Pages
if (req.url ~ "contact") {
    return (pass);
}
