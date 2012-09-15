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
	include "receive.vcl";
	return (lookup);
}

sub vcl_hit {
    if (req.request == "PURGE") {
        purge;
        error 200 "Purged";
    }
    return (deliver);
}

sub vcl_miss {
    if (req.request == "PURGE") {
        purge;
        error 200 "Purged";
    }
    return (fetch);
}

sub vcl_fetch {
	include "fetch-do-not-cache.vcl";

	# The default value of 120s can be modified here
	# set beresp.ttl = 300s;
	return (deliver);
}

sub vcl_deliver {
    # Hide server header
    unset resp.http.X-Powered-By;
    unset resp.http.Server;
    unset resp.http.Via;
    unset resp.http.X-Varnish;
    unset resp.http.X-Pingback;

    return (deliver);
}
