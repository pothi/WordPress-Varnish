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
