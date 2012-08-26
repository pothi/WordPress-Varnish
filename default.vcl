# The name of the backend (nginx) could be anything;
backend nginx {
	.host = "127.0.0.1";
	.port = "8888";
	# For slow backends
	.first_byte_timeout = 300s;
}

acl purge {
	"localhost";
	"127.0.0.1";
	"yo.ur.ip.no";
}

sub vcl_recv {
	include receive.vcl;
	return (lookup);
}

sub vcl_fetch {
	include fetch.vcl;
	return (deliver);
}
