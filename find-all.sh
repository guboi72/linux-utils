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
    EXTENSION="*"
fi

echo "FILE EXTENSION  = ${EXTENSION}"
echo "SEARCH PATH     = ${SEARCHPATH}"
echo "PATTERNS        = ${PATTERNS[@]}"

GREP_TEMP_CMD=""
n=1
for pattern in ${PATTERNS[@]}; do

    if [[ $n -eq 1 ]]; then
        GREP_TEMP_CMD+="grep -lri --include=\*.${EXTENSION} -e \"${pattern}\" ${SEARCHPATH}"
    else
        GREP_TEMP_CMD+="xargs grep -li -e \"${pattern}\""
    fi
    if [[ $n -ne ${#PATTERNS[@]} ]]; then
        GREP_TEMP_CMD+=" | "
    fi
    n=$((n+1))
done

echo $GREP_TEMP_CMD
eval $GREP_TEMP_CMD
exit 0