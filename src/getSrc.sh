VER_NGINX_DEVEL_KIT=0.2.19
VER_LUA_NGINX_MODULE=0.10.0
VER_NGINX=1.7.12
VER_LUAJIT=2.0.4
VER_PCRE=8.38
VER_READLINE=6.3
VER_OPENSSL=1.0.2g

NGINX_DEVEL_KIT=ngx_devel_kit-${VER_NGINX_DEVEL_KIT}
LUA_NGINX_MODULE=lua-nginx-module-${VER_LUA_NGINX_MODULE}
NGINX_ROOT=/nginx
WEB_DIR=${NGINX_ROOT}/html


LUAJIT_LIB=/usr/local/lib
LUAJIT_INC=/usr/local/include/luajit-2.0
# ***** BUILD DEPENDENCIES *****

# Common dependencies (Nginx and LUAJit)
# ***** DOWNLOAD AND UNTAR *****

# Download
wget -q http://www.openssl.org/source/openssl-${VER_OPENSSL}.tar.gz 
wget -q http://sourceforge.net/projects/pcre/files/pcre/${VER_PCRE}/pcre-${VER_PCRE}.tar.gz
#wget -q ftp://ftp.cwru.edu/pub/bash/readline-${VER_READLINE}.tar.gz
wget -q http://ftp.gnu.org/gnu/readline/readline-${VER_READLINE}.tar.gz
wget -q http://nginx.org/download/nginx-${VER_NGINX}.tar.gz
wget -q http://luajit.org/download/LuaJIT-${VER_LUAJIT}.tar.gz
wget -q https://github.com/simpl/ngx_devel_kit/archive/v${VER_NGINX_DEVEL_KIT}.tar.gz -O ${NGINX_DEVEL_KIT}.tar.gz
wget -q https://github.com/openresty/lua-nginx-module/archive/v${VER_LUA_NGINX_MODULE}.tar.gz -O ${LUA_NGINX_MODULE}.tar.gz
# Untar
tar -xzvf nginx-${VER_NGINX}.tar.gz && rm nginx-${VER_NGINX}.tar.gz
tar -xzvf LuaJIT-${VER_LUAJIT}.tar.gz && rm LuaJIT-${VER_LUAJIT}.tar.gz
tar -xzvf ${NGINX_DEVEL_KIT}.tar.gz && rm ${NGINX_DEVEL_KIT}.tar.gz
tar -xzvf ${LUA_NGINX_MODULE}.tar.gz && rm ${LUA_NGINX_MODULE}.tar.gz
tar -zxvf pcre-${VER_PCRE}.tar.gz && rm pcre-${VER_PCRE}.tar.gz
tar -zxvf readline-${VER_READLINE}.tar.gz && rm readline-${VER_READLINE}.tar.gz
tar -zxvf openssl-${VER_OPENSSL}.tar.gz && rm openssl-${VER_OPENSSL}.tar.gz
