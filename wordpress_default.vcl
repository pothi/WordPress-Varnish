include "backend.vcl";
include "acl.vcl";

sub vcl_recv {
  include "conf.d/receive/pagespeed.vcl";
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
  include "conf.d/fetch/pagespeed.vcl";
  include "fetch-do-not-cache-domains.vcl";
  include "fetch-do-not-cache-static-content.vcl";

  # custom rules
  # include "conf.d/fetch/expires.vcl";

  # if a requests reaches this stage, then it is cacheable
  set beresp.http.X-Cacheable = "YES";

  # The default value of 120s can be modified here
  # set beresp.ttl = 300s;

  return (deliver);
}

sub vcl_deliver {
  # Comment it out to see useful headers (for example, while debugging)
  include "conf.d/deliver/hide_headers.vcl";

  # If your site uses CloudFront, you may want to enable / uncomment the following
  # include "conf.d/deliver/cloudfront.vcl;

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

# The data on which the hashing will take place
sub vcl_hash {
    hash_data(req.url);

    if (req.http.host) {
        hash_data(req.http.host);
    } else {
        hash_data(server.ip);
    }

    # hash cookies for object with auth
    if (req.http.Cookie) {
        hash_data(req.http.Cookie);
    }
    if (req.http.Authorization) {
        hash_data(req.http.Authorization);
    }

    # If the client supports compression, keep that in a different cache
    if (req.http.Accept-Encoding) {
        hash_data(req.http.Accept-Encoding);
    }

    return (hash);
}

