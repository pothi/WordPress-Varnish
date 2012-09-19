### If the backend doesn't deflate or gzip, then uncomment the following
#	if (beresp.http.content-type ~ "text" || req.url ~ "\.(css|js|html)" ) {
#		set beresp.do_gzip = true;
#	}
