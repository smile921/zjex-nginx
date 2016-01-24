VER_NGINX_DEVEL_KIT=0.2.19
VER_LUA_NGINX_MODULE=0.10.0
VER_NGINX=1.7.12
VER_LUAJIT=2.0.4
VER_PCRE=8.38
VER_READLINE=6.3
VER_OPENSSL=1.0.2e

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
wget -q https://github.com/openresty/ngx_openresty/archive/v1.9.7.2.tar.gz -O ngx_openresty-v1.9.7.2.tar.gz
# Untar
tar -xzvf nginx-${VER_NGINX}.tar.gz && rm nginx-${VER_NGINX}.tar.gz
tar -xzvf LuaJIT-${VER_LUAJIT}.tar.gz && rm LuaJIT-${VER_LUAJIT}.tar.gz
tar -xzvf ${NGINX_DEVEL_KIT}.tar.gz && rm ${NGINX_DEVEL_KIT}.tar.gz
tar -xzvf ${LUA_NGINX_MODULE}.tar.gz && rm ${LUA_NGINX_MODULE}.tar.gz
tar -zxvf pcre-${VER_PCRE}.tar.gz && rm pcre-${VER_PCRE}.tar.gz
tar -zxvf readline-${VER_READLINE}.tar.gz && rm readline-${VER_READLINE}.tar.gz
tar -zxvf openssl-${VER_OPENSSL}.tar.gz && rm openssl-${VER_OPENSSL}.tar.gz
tar -zxvf ngx_openresty-v1.9.7.2.tar.gz && rm ngx_openresty-v1.9.7.2.tar.gz
cd  LuaJIT-${VER_LUAJIT}
make clean && make && make install
cd ..

cd pcre-${VER_PCRE}
./configure --prefix=/usr/local/pcre
 make && make install
cd ..

cd  readline-${VER_READLINE}
  ./configure && make && make install
cd ..
cd /usr/local/lib
ldconfig
cd -

cd openssl-${VER_OPENSSL}

./config --prefix=/usr/local/openssl
./config -t
make 
make install
cd ..

######################################################################
## # tell nginx's build system where to find LuaJIT 2.0:
## export LUAJIT_LIB=/path/to/luajit/lib
## export LUAJIT_INC=/path/to/luajit/include/luajit-2.0
##
## # tell nginx's build system where to find LuaJIT 2.1:
## export LUAJIT_LIB=/path/to/luajit/lib
## export LUAJIT_INC=/path/to/luajit/include/luajit-2.1
##
## # or tell where to find Lua if using Lua instead:
## #export LUA_LIB=/path/to/lua/lib
## #export LUA_INC=/path/to/lua/include
##
## # Here we assume Nginx is to be installed under /opt/nginx/.
## #./configure --prefix=/opt/nginx \
##         --with-ld-opt="-Wl,-rpath,/path/to/luajit-or-lua/lib" \
##         --add-module=/path/to/ngx_devel_kit \
##         --add-module=/path/to/lua-nginx-module
##
## make -j2
## make install
##
#####################################################################
cd nginx-${VER_NGINX}

 ./configure \
    --add-module=../ngx_devel_kit-0.2.19 \
    --add-module=../lua-nginx-module-0.10.0 \
    --with-http_ssl_module \
    --with-openssl=../openssl-1.0.2e \
    --with-pcre=../pcre-8.38  \
    --with-ld-opt="-Wl,-rpath,/usr/local/lib" \
    --prefix=/home/nginx \
    --with-cc-opt="-I/usr/local/openssl/include/ -I/usr/local/pcre/include/" \
    --with-ld-opt="-L/usr/local/openssl/lib/ -L/usr/local/pcre/lib/" \


./configure  \
    --add-module=../${NGINX_DEVEL_KIT}\
    --add-module=../${LUA_NGINX_MODULE}\
    --with-http_ssl_module\
    --with-openssl=../openssl-${VER_OPENSSL} \
    --with-pcre=../pcre-${VER_PCRE} \
    --with-ld-opt="-Wl,-rpath,/usr/local/lib"\
    --prefix=/home/nginx \
    --with-cc-opt="-I/usr/local/openssl/include/ -I/usr/local/pcre/include/" \
    --with-ld-opt="-L/usr/local/openssl/lib/ -L/usr/local/pcre/lib/" \


make 
make install
