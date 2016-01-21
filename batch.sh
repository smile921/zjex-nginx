basepath=$(cd `dirname $0`; pwd)
basenginxpath=/home/ngx_lua/openresty
${basenginxpath}/nginx/sbin/nginx -p ${basepath} -c ${basepath}/conf/nginx.conf -s stop
${basenginxpath}/nginx/sbin/nginx -p ${basepath} -c ${basepath}/conf/nginx.conf
tail -f ${basepath}/logs/debug.log
