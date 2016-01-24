.PHONY: all install clean

all:
	cd /media/zuo/100g-data/git/zjex-nginx/src/ngx_openresty-1.9.7.2/build/LuaJIT-2.1-20160108 && $(MAKE) TARGET_STRIP=@: CCDEBUG=-g CC=cc PREFIX=/home/nginx-openresty/luajit
	cd /media/zuo/100g-data/git/zjex-nginx/src/ngx_openresty-1.9.7.2/build/lua-cjson-2.1.0.3 && $(MAKE) DESTDIR=$(DESTDIR) LUA_INCLUDE_DIR=/media/zuo/100g-data/git/zjex-nginx/src/ngx_openresty-1.9.7.2/build/luajit-root/home/nginx-openresty/luajit/include/luajit-2.1 LUA_CMODULE_DIR=/home/nginx-openresty/lualib LUA_MODULE_DIR=/home/nginx-openresty/lualib CJSON_CFLAGS="-g -fpic" CC=cc
	cd /media/zuo/100g-data/git/zjex-nginx/src/ngx_openresty-1.9.7.2/build/lua-redis-parser-0.12 && $(MAKE) DESTDIR=$(DESTDIR) LUA_INCLUDE_DIR=/media/zuo/100g-data/git/zjex-nginx/src/ngx_openresty-1.9.7.2/build/luajit-root/home/nginx-openresty/luajit/include/luajit-2.1 LUA_LIB_DIR=/home/nginx-openresty/lualib CC=cc
	cd /media/zuo/100g-data/git/zjex-nginx/src/ngx_openresty-1.9.7.2/build/lua-rds-parser-0.06 && $(MAKE) DESTDIR=$(DESTDIR) LUA_INCLUDE_DIR=/media/zuo/100g-data/git/zjex-nginx/src/ngx_openresty-1.9.7.2/build/luajit-root/home/nginx-openresty/luajit/include/luajit-2.1 LUA_LIB_DIR=/home/nginx-openresty/lualib CC=cc
	cd /media/zuo/100g-data/git/zjex-nginx/src/ngx_openresty-1.9.7.2/build/nginx-1.9.7 && $(MAKE)

install: all
	cd /media/zuo/100g-data/git/zjex-nginx/src/ngx_openresty-1.9.7.2/build/LuaJIT-2.1-20160108 && $(MAKE) install TARGET_STRIP=@: CCDEBUG=-g CC=cc PREFIX=/home/nginx-openresty/luajit DESTDIR=$(DESTDIR)
	cd /media/zuo/100g-data/git/zjex-nginx/src/ngx_openresty-1.9.7.2/build/lua-cjson-2.1.0.3 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_INCLUDE_DIR=/media/zuo/100g-data/git/zjex-nginx/src/ngx_openresty-1.9.7.2/build/luajit-root/home/nginx-openresty/luajit/include/luajit-2.1 LUA_CMODULE_DIR=/home/nginx-openresty/lualib LUA_MODULE_DIR=/home/nginx-openresty/lualib CJSON_CFLAGS="-g -fpic" CC=cc
	cd /media/zuo/100g-data/git/zjex-nginx/src/ngx_openresty-1.9.7.2/build/lua-redis-parser-0.12 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_INCLUDE_DIR=/media/zuo/100g-data/git/zjex-nginx/src/ngx_openresty-1.9.7.2/build/luajit-root/home/nginx-openresty/luajit/include/luajit-2.1 LUA_LIB_DIR=/home/nginx-openresty/lualib CC=cc
	cd /media/zuo/100g-data/git/zjex-nginx/src/ngx_openresty-1.9.7.2/build/lua-rds-parser-0.06 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_INCLUDE_DIR=/media/zuo/100g-data/git/zjex-nginx/src/ngx_openresty-1.9.7.2/build/luajit-root/home/nginx-openresty/luajit/include/luajit-2.1 LUA_LIB_DIR=/home/nginx-openresty/lualib CC=cc
	cd /media/zuo/100g-data/git/zjex-nginx/src/ngx_openresty-1.9.7.2/build/lua-resty-dns-0.14 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_LIB_DIR=/home/nginx-openresty/lualib INSTALL=/media/zuo/100g-data/git/zjex-nginx/src/ngx_openresty-1.9.7.2/build/install
	cd /media/zuo/100g-data/git/zjex-nginx/src/ngx_openresty-1.9.7.2/build/lua-resty-memcached-0.13 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_LIB_DIR=/home/nginx-openresty/lualib INSTALL=/media/zuo/100g-data/git/zjex-nginx/src/ngx_openresty-1.9.7.2/build/install
	cd /media/zuo/100g-data/git/zjex-nginx/src/ngx_openresty-1.9.7.2/build/lua-resty-redis-0.22 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_LIB_DIR=/home/nginx-openresty/lualib INSTALL=/media/zuo/100g-data/git/zjex-nginx/src/ngx_openresty-1.9.7.2/build/install
	cd /media/zuo/100g-data/git/zjex-nginx/src/ngx_openresty-1.9.7.2/build/lua-resty-mysql-0.15 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_LIB_DIR=/home/nginx-openresty/lualib INSTALL=/media/zuo/100g-data/git/zjex-nginx/src/ngx_openresty-1.9.7.2/build/install
	cd /media/zuo/100g-data/git/zjex-nginx/src/ngx_openresty-1.9.7.2/build/lua-resty-string-0.09 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_LIB_DIR=/home/nginx-openresty/lualib INSTALL=/media/zuo/100g-data/git/zjex-nginx/src/ngx_openresty-1.9.7.2/build/install
	cd /media/zuo/100g-data/git/zjex-nginx/src/ngx_openresty-1.9.7.2/build/lua-resty-upload-0.09 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_LIB_DIR=/home/nginx-openresty/lualib INSTALL=/media/zuo/100g-data/git/zjex-nginx/src/ngx_openresty-1.9.7.2/build/install
	cd /media/zuo/100g-data/git/zjex-nginx/src/ngx_openresty-1.9.7.2/build/lua-resty-websocket-0.05 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_LIB_DIR=/home/nginx-openresty/lualib INSTALL=/media/zuo/100g-data/git/zjex-nginx/src/ngx_openresty-1.9.7.2/build/install
	cd /media/zuo/100g-data/git/zjex-nginx/src/ngx_openresty-1.9.7.2/build/lua-resty-lock-0.04 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_LIB_DIR=/home/nginx-openresty/lualib INSTALL=/media/zuo/100g-data/git/zjex-nginx/src/ngx_openresty-1.9.7.2/build/install
	cd /media/zuo/100g-data/git/zjex-nginx/src/ngx_openresty-1.9.7.2/build/lua-resty-lrucache-0.04 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_LIB_DIR=/home/nginx-openresty/lualib INSTALL=/media/zuo/100g-data/git/zjex-nginx/src/ngx_openresty-1.9.7.2/build/install
	cd /media/zuo/100g-data/git/zjex-nginx/src/ngx_openresty-1.9.7.2/build/lua-resty-core-0.1.4 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_LIB_DIR=/home/nginx-openresty/lualib INSTALL=/media/zuo/100g-data/git/zjex-nginx/src/ngx_openresty-1.9.7.2/build/install
	cd /media/zuo/100g-data/git/zjex-nginx/src/ngx_openresty-1.9.7.2/build/lua-resty-upstream-healthcheck-0.03 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_LIB_DIR=/home/nginx-openresty/lualib INSTALL=/media/zuo/100g-data/git/zjex-nginx/src/ngx_openresty-1.9.7.2/build/install
	cd /media/zuo/100g-data/git/zjex-nginx/src/ngx_openresty-1.9.7.2/build/resty-cli-0.05 && /media/zuo/100g-data/git/zjex-nginx/src/ngx_openresty-1.9.7.2/build/install resty $(DESTDIR)/home/nginx-openresty/bin/
	cd /media/zuo/100g-data/git/zjex-nginx/src/ngx_openresty-1.9.7.2/build/nginx-1.9.7 && $(MAKE) install DESTDIR=$(DESTDIR)

clean:
	rm -rf build
