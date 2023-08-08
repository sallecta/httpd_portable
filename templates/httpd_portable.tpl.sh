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

exe=$path'/bin/httpd_portable'

export LD_LIBRARY_PATH=$path'/lib:'$LD_LIBRARY_PATH

sed -i -e 's,^ServerRoot\s.*,ServerRoot '$path/apache2',g' $path'/apache2/conf/httpd.conf'
fn_stoponerror $BASH_SOURCE $LINENO $?

sed -i -e 's,^DocumentRoot\s.*,DocumentRoot '$path/htdocs',g' $path'/apache2/conf/httpd.conf'
fn_stoponerror $BASH_SOURCE $LINENO $?

sed -i -e 's,^<Directory\s\"987887569DocumentRoot.*,<Directory '$path/htdocs'>,g' $path'/apache2/conf/httpd.conf'
fn_stoponerror $BASH_SOURCE $LINENO $?

sed -i -e 's,^PidFile\s.*,PidFile '$path/apache2/httpd.pid',g' $path'/apache2/conf/httpd.conf'
fn_stoponerror $BASH_SOURCE $LINENO $?

mkdir -p $path'/apache2/logs'
fn_stoponerror $BASH_SOURCE $LINENO $?

#sed -i -e 's,^Listen\s.*,Listen '$path/apache2',g' $path'/apache2/conf/httpd.conf'
#fn_stoponerror $BASH_SOURCE $LINENO $?

args="$@"
if [ -z "$args" ]
	then
		echo "No argument supplied, using '-version'."
		args='-version'
		echo "Suggestions:"
		echo "- use [-k start|restart|graceful|graceful-stop|stop] "
		echo "- or [-help]"
fi

echo args are $args

sudo LD_LIBRARY_PATH="$LD_LIBRARY_PATH" $exe -f $path'/apache2/conf/httpd.conf' $args
ps -eo comm,etime,user,pid | grep httpd_portable
