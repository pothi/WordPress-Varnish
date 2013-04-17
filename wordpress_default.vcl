# The name of the backend (nginx) could be anything;
backend nginx {
  .host = "127.0.0.1";
  .port = "8888";

  # For slow backends
  .first_byte_timeout = 300s;
  .connect_timeout = 300s;
  .between_bytes_timeout = 300s;
}

acl purge {
  "localhost";
  "127.0.0.1";

# uncomment the following, after modifying it
# "yo.ur.ip.no";

}

sub vcl_recv {
  include "receive.vcl";
  include "receive-do-not-lookup.vcl";
  include "receive-do-not-lookup-domains.vcl";
  include "receive-do-not-lookup-static-content.vcl";

  # custom rules

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
  include "fetch.vcl";
  include "fetch-do-not-cache.vcl";
  include "fetch-do-not-cache-domains.vcl";
  include "fetch-do-not-cache-static-content.vcl";

  # custom rules

  # if a requests reaches this stage, then it is cacheable
  set beresp.http.X-Cacheable = "YES";

  # setup cache control, if backend doesn't, especially for static files
  # use case - Apache backend without mod_expires
  # if (req.url ~ "\.(jpg|jpeg|png|gif|ico|tiff|tif|bmp|ppm|pgm|xcf|psd|webp|svg)"
   # || req.url ~ "\.(css|js)"
   # || req.url ~ "\.html?$"
   # || req.url ~ "\.(woff|eot|otf|ttf)"
   # ) {
      # unset beresp.http.expires;
      # set beresp.http.Cache-Control = "max-age=2678400";
  # }
  
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

  ### Uncomment the following, if Varnish handles compression
  # set resp.http.Vary = "Accept-Encoding";

  # Display the number of hits
  if (obj.hits > 0) {
    set resp.http.X-Cache = "HIT - " + obj.hits;
  } else {
    set resp.http.X-Cache = "MISS";
  }
  
    return (deliver);
}
