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

path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

apache="httpd-2.4.57"

src_distr=$path"/src_distr/"$apache".tar.bz2"
src_distr_apr=$path"/src_distr/apr-1.7.4.tar.gz"
src_distr_apr_iconv=$path"/src_distr/apr-iconv-1.2.2.tar.gz"
src_distr_apr_util=$path"/src_distr/apr-util-1.6.3.tar.gz"

path_src=$path"/src"

mkdir -p $path_src
fn_stoponerror $BASH_SOURCE $LINENO $?
tar -xvf $src_distr -C $path_src
fn_stoponerror $BASH_SOURCE $LINENO $?

mkdir -p $path_src"/"$apache"/srclib"
fn_stoponerror $BASH_SOURCE $LINENO $?

tar -xvf $src_distr_apr -C $path_src"/"$apache"/srclib"
fn_stoponerror $BASH_SOURCE $LINENO $?
mv $path_src'/'$apache'/srclib/apr-'* $path_src'/'$apache'/srclib/apr'
fn_stoponerror $BASH_SOURCE $LINENO $?

tar -xvf $src_distr_apr_iconv -C $path_src"/"$apache"/srclib"
fn_stoponerror $BASH_SOURCE $LINENO $?
mv $path_src'/'$apache'/srclib/apr-iconv-'* $path_src'/'$apache'/srclib/apr-iconv'
fn_stoponerror $BASH_SOURCE $LINENO $?

tar -xvf $src_distr_apr_util -C $path_src"/"$apache"/srclib"
fn_stoponerror $BASH_SOURCE $LINENO $?
mv $path_src'/'$apache'/srclib/apr-util-'* $path_src'/'$apache'/srclib/apr-util'
fn_stoponerror $BASH_SOURCE $LINENO $?

cd $path_src'/'$apache
fn_stoponerror $BASH_SOURCE $LINENO $?
./configure --with-included-apr
fn_stoponerror $BASH_SOURCE $LINENO $?

make

cd $path


