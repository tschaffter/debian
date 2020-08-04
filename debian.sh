#!/bin/bash
#
# This is a rather minimal example Argbash potential
# Example taken from http://argbash.readthedocs.io/en/stable/example.html
#
# ARG_POSITIONAL_MULTI([environment],[Environment name and version],[2],[user],[latest])
# ARG_HELP([The general script's help msg])
# ARGBASH_GO()
# needed because of Argbash --> m4_ignore([
### START OF CODE GENERATED BY Argbash v2.8.1 one line above ###
# Argbash is a bash code generator used to get arguments parsing right.
# Argbash is FREE SOFTWARE, see https://argbash.io for more info
# Generated online by https://argbash.io/generate

# exit when any command fails
set -e


die()
{
	local _ret=$2
	test -n "$_ret" || _ret=1
	test "$_PRINT_HELP" = yes && print_help >&2
	echo "$1" >&2
	exit ${_ret}
}


begins_with_short_option()
{
	local first_option all_short_options='h'
	first_option="${1:0:1}"
	test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - POSITIONALS
_positionals=()
_arg_environment=("user" "latest")
# THE DEFAULTS INITIALIZATION - OPTIONALS


print_help()
{
	printf '%s\n' "Starts a dockerized Debian development environment."
	printf 'Usage: %s [-h|--help] [<environment-name>] [<environment-version>]\n' "$0"
	printf '\t%s\n' "<environment-name> (default is 'user')"
	printf '\t%s\n' "<environment-version> (default is 'latest')"
	printf '\t%s\n' "-h, --help: Prints help"
}


parse_commandline()
{
	_positionals_count=0
	while test $# -gt 0
	do
		_key="$1"
		case "$_key" in
			-h|--help)
				print_help
				exit 0
				;;
			-h*)
				print_help
				exit 0
				;;
			*)
				_last_positional="$1"
				_positionals+=("$_last_positional")
				_positionals_count=$((_positionals_count + 1))
				;;
		esac
		shift
	done
}


handle_passed_args_count()
{
	test "${_positionals_count}" -le 2 || _PRINT_HELP=yes die "FATAL ERROR: There were spurious positional arguments --- we expect between 0 and 2, but got ${_positionals_count} (the last one was: '${_last_positional}')." 1
}


assign_positional_args()
{
	local _positional_name _shift_for=$1
	_positional_names="_arg_environment[0] _arg_environment[1] "

	shift "$_shift_for"
	for _positional_name in ${_positional_names}
	do
		test $# -gt 0 || break
		eval "$_positional_name=\${1}" || die "Error during argument parsing, possibly an Argbash bug." 1
		shift
	done
}

parse_commandline "$@"
handle_passed_args_count
assign_positional_args 1 "${_positionals[@]}"

# OTHER STUFF GENERATED BY Argbash

### END OF CODE GENERATED BY Argbash (sortof) ### ])
# [ <-- needed because of Argbash

# Find the location of the directory that includes this script.
get_script_dir() {
	wdir="$PWD"; [ "$PWD" = "/" ] && wdir=""
	arg=$1
	case "$arg" in
		/*) scriptdir="${arg}";;
		*) scriptdir="$wdir/${arg#./}";;
	esac
	scriptdir="${scriptdir%/*}"
	echo "$scriptdir"
}

if [[ -z "${DEBIAN_PATH}" ]]
then
	# If using bash, try to guess DEBIAN_PATH from script location
	if [[ -n "${BASH_SOURCE}" ]]
	then
		if [[ "$OSTYPE" == "darwin"* ]]; then
			script_dir="$(get_script_dir $BASH_SOURCE)"
		else
			script_name="$(readlink -f $BASH_SOURCE)"
			script_dir="$(dirname $script_name)"
		fi
		export DEBIAN_PATH="${script_dir}"
	else
		echo "DEBIAN_PATH must be set."
		return 1
	fi
fi

environment=${_arg_environment[0]}
version=${_arg_environment[1]}
file=${DEBIAN_PATH}/docker-compose.yml

version=${version} docker-compose \
	-f ${file} \
	--log-level ERROR\
	pull ${environment}

version=${version} docker-compose \
	-f ${file} \
	--log-level ERROR \
	run ${environment}

# ] <-- needed because of Argbash