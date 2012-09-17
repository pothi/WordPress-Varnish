# Check the cookies for wordpress-specific cookies
if (req.http.Cookie ~ "wordpress_" || req.http.Cookie ~ "comment_") {
	return (pass);
}
