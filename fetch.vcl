# To avoid storing 404, 502, 503 error pages in memory
	if (beresp.status == 404 || beresp.status == 503 || beresp.status == 500) {
		set beresp.http.Cache-Control = "max-age=0";
		return (hit_for_pass);
	}
