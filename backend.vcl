backend apache {
  .host = "127.0.0.1";
  .port = "81";

  # Feel free to change these according to your specific requirement/s
  .first_byte_timeout     = 60s;
  .connect_timeout        = 60s;
  .between_bytes_timeout  = 30s;
}

backend nginx {
  .host = "127.0.0.1";
  .port = "82";

  # Feel free to change these according to your specific requirement/s
  .first_byte_timeout     = 60s;
  .connect_timeout        = 60s;
  .between_bytes_timeout  = 30s;
}

