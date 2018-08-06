#!/bin/bash

cekDir(){
	if [ -d "${val}" ]; then
		for filename in $(find $val);
		do 
			echo "`stat -c "%a" "$filename"` u=`stat -c "%U" "$filename"` g=`stat -c "%G" "$filename"` $filename"
		done 
	elif [[ -f "${val}" ]]; then
		#echo "$val is not a Directory"
		echo "`stat -c "%a" "$val"` u=`stat -c "%U" "$val"` g=`stat -c "%G" "$val"` $val"
	else
		echo "
Unknown either FILE nor DIRECTORY,
Please specify precisely
"
	fi
}

fixPerm(){
	if [ -d "${val}" ]; then
		for filename in $(find $val);
		do 
			echo "File permission set to 0644" >&2
			find "${val}" -type f -exec chmod 0644 {} \;
			echo "Directory permission set to 0755" >&2
			find "${val}" -type d -exec chmod 0755 {} \;
		done 
	elif [[ -f "${val}" ]]; then
		#statements
		echo "change file permission to 0644" >&2
		chmod 0644 "${val}"
	fi
}

optspec=":hvfr-:"
while getopts "$optspec" optchar; do
    case "${optchar}" in
        -)
            case "${OPTARG}" in
                dir)
                    val="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))
                    cekDir
                    ;;
                dir=*)
                    val=${OPTARG#*=}
                    opt=${OPTARG%=$val}
                    cekDir
                    ;;
                *)
                    if [ "$OPTERR" = 1 ] && [ "${optspec:0:1}" != ":" ]; then
                        echo "Unknown option --${OPTARG}" >&2
                    fi
                    ;;
            esac;;
        h)
            echo "usage: $0 [-v] [-f] [--dir[=]<value>]" >&2
            exit 2
            ;;
        f)
			fixPerm
            echo "Fixing permission file and folder"
            ;;
        v)
            echo "Parsing option: '-${optchar}'" >&2
            ;;
        *)
            if [ "$OPTERR" != 1 ] || [ "${optspec:0:1}" = ":" ]; then
                echo "Non-option argument: '-${OPTARG}'" >&2
            fi
            ;;
    esac
done