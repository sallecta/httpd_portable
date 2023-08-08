fn_stoponerror ()
{
	# Usage:
	# fn_stoponerror $BASH_SOURCE $LINENO $?
	from=$1
	line=$2
	error=$3
	if [ $error -ne 0 ]; then
		printf "\n$from: line $line: error: $error\n"
		exit $error
	fi
}

path=$(dirname "$(realpath "$0")")
fn_stoponerror $BASH_SOURCE $LINENO $?
echo path is $path
if [ -z $path ]
then
	echo "path is empty"
	exit
fi

path_p=$path'/httpd_portable'
sudo pkill httpd_portable

if [ -e $path_p ]
then
	rm -rf $path_p
	fn_stoponerror $BASH_SOURCE $LINENO $?
fi

mkdir -p $path_p
fn_stoponerror $BASH_SOURCE $LINENO $?

mkdir -p $path_p'/bin'
fn_stoponerror $BASH_SOURCE $LINENO $?

mkdir -p $path_p'/lib'
fn_stoponerror $BASH_SOURCE $LINENO $?

mkdir -p $path_p'/apache2/conf'
fn_stoponerror $BASH_SOURCE $LINENO $?

cp $path'/README.md' $path_p
fn_stoponerror $BASH_SOURCE $LINENO $?

cp $path'/LICENSE' $path_p
fn_stoponerror $BASH_SOURCE $LINENO $?

cp $path'/templates/httpd_portable.tpl.sh' $path_p'/httpd_portable.sh'
fn_stoponerror $BASH_SOURCE $LINENO $?

cp $path'/src/httpd-2.4.57/.libs/httpd' $path_p'/bin/httpd_portable'
fn_stoponerror $BASH_SOURCE $LINENO $?

cp $path'/src/httpd-2.4.57/srclib/apr-util/.libs/libaprutil-1.so.0.6.3' $path_p'/lib/'
fn_stoponerror $BASH_SOURCE $LINENO $?
ln --symbolic --relative $path_p'/lib/libaprutil-1.so.0.6.3' $path_p'/lib/libaprutil-1.so.0'
fn_stoponerror $BASH_SOURCE $LINENO $?

cp $path'/src/httpd-2.4.57/srclib/apr/.libs/libapr-1.so.0.7.4' $path_p'/lib/'
fn_stoponerror $BASH_SOURCE $LINENO $?
ln --symbolic --relative $path_p'/lib/libapr-1.so.0.7.4' $path_p'/lib/libapr-1.so.0'
fn_stoponerror $BASH_SOURCE $LINENO $?

# modules
mkdir -p $path_p'/apache2/modules'
fn_stoponerror $BASH_SOURCE $LINENO $?

cp $path'/src/httpd-2.4.57/modules/aaa/.libs/mod_authz_core.so' $path_p'/apache2/modules/'
fn_stoponerror $BASH_SOURCE $LINENO $?

cp $path'/src/httpd-2.4.57/modules/mappers/.libs/mod_rewrite.so' $path_p'/apache2/modules/'
fn_stoponerror $BASH_SOURCE $LINENO $?

cp $path'/src/httpd-2.4.57/modules/arch/unix/.libs/mod_unixd.so' $path_p'/apache2/modules/'
fn_stoponerror $BASH_SOURCE $LINENO $?

cp $path'/src/httpd-2.4.57/modules/generators/.libs/mod_autoindex.so' $path_p'/apache2/modules/'
fn_stoponerror $BASH_SOURCE $LINENO $?

cp $path'/src/httpd-2.4.57/modules/mappers/.libs/mod_dir.so' $path_p'/apache2/modules/'
fn_stoponerror $BASH_SOURCE $LINENO $?
# end modules

cp $path'/templates/httpd.tpl.conf' $path_p'/apache2/conf/httpd.conf'
fn_stoponerror $BASH_SOURCE $LINENO $?


mkdir -p $path_p'/htdocs'
fn_stoponerror $BASH_SOURCE $LINENO $?

cp $path'/templates/index.tpl.html' $path_p'/htdocs/index.html'
fn_stoponerror $BASH_SOURCE $LINENO $?

chmod u+x $path_p'/httpd_portable.sh'
fn_stoponerror $BASH_SOURCE $LINENO $?

$path_p'/httpd_portable.sh' -version

ps -eo comm,etime,user,pid | grep httpd_portable
sudo pkill httpd_portable

