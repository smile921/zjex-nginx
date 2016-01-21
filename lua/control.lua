if current_page_uri == "/" then
  current_page_uri = "/index.html"
end
ngx.exit(ngx.OK)
