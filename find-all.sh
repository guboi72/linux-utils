#!/bin/bash

POSITIONAL=()
while [[ $# -gt 0 ]]
do
    key="$1"
    
    case $key in
        -e|--extension)
            EXTENSION="$2"
            shift # past argument
            shift # past value
        ;;
        -s|--searchpath)
            SEARCHPATH="$2"
            shift # past argument
            shift # past value
        ;;
        -p | --PATTERNS)
            shift # past argument
            PATTERNS=($*)
            echo ${PATTERNS[@]}
            for ((i = 0 ; i < ${#PATTERNS[@]} ; i++)); do
                shift
            done
    esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters


if [[ -z "${SEARCHPATH}" ]]; then
    SEARCHPATH=`pwd`
fi

if [[ -z "${EXTENSION}" ]]; then
    EXTENSION=""
fi

echo "FILE EXTENSION  = ${EXTENSION}"
echo "SEARCH PATH     = ${SEARCHPATH}"
echo "PATTERNS        = ${PATTERNS[@]}"

files_count=$(ls -1 "${SEARCHPATH}"/*"${EXTENSION}" | wc -l)

GREP_TEMP_CMD=""
n=1
for pattern in ${PATTERNS[@]}; do

    if [[ $n -eq 1 ]]; then
        GREP_TEMP_CMD+="grep -lr \"${pattern}\" ${SEARCHPATH}"
    else
        GREP_TEMP_CMD+="xargs grep -l \"${pattern}\""
    fi
    if [[ $n -ne ${#PATTERNS[@]} ]]; then
        GREP_TEMP_CMD+=" | "
    fi
    n=$((n+1))
done

echo "Number of files matching the patterns:" $files_count
if [[ -n $1 ]]; then
    echo "Last line of file specified as non-opt/last argument:"
    tail -1 "$1"
fi

ls -a $($GREP_TEMP_CMD) | cut -d " " -f 4 

exit 0