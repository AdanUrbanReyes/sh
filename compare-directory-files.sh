#!/bin/bash

function prepare_file_to_compare {
    set -eu
    local file="${1}"
    local ready_to_compare_file="ready-to-compare-${file}"
    sed -E 's/[0-9]{4}[\-][0-9]{1,2}[\-][0-9]{1,2}//g' "${file}" | \
    sed -E 's/[0-9]{1,2}[:][0-9]{1,2}[:][0-9]{1,2}(\.[0-9]+)?//g' | \
    iconv -sc -f utf-8 -t ascii | \
    sort  | \
    uniq > "${ready_to_compare_file}"
    echo "${ready_to_compare_file}"
}

function compare_files {
    set -eu
    local file_one="${1}"
    local file_two="${2}"
    local ready_to_compare_one=$(prepare_file_to_compare "${file_one}")
    local ready_to_compare_two=$(prepare_file_to_compare "${file_two}")
    if [ -z "$(diff -u "${ready_to_compare_one}" "${ready_to_compare_two}")" ]; then
        rm "${ready_to_compare_one}" "${ready_to_compare_two}"
        echo "true"
        return 0
    fi
    echo "false"
    return 0
}

function compare_directory_files {
    set -eu
    local files=$(ls -lS *.csv | awk '{print $9}') # comparing only csv files, modify if need it
    local file_one
    local file_two
    printf "%-70s | %-5s | %-7s | %-15s\n" "File" "Size" "Lines" "Match"
    printf "%-70s | %-5s | %-7s | %-15s\n" "----------------------------------------------------------------------" "-----" "-------" "---------------"
    while IFS= read -r file; do
        local size=$(ls -lh ${file} | awk '{print $5}')
        local lines=$(wc -l ${file} | awk '{print $1}')
        local match
        if [ -z "${file_one}" ]; then
            file_one="${file}"
        elif [ -z "${file_two}" ]; then
            file_two="${file}"
            match=$(compare_files "${file_one}" "${file_two}")
            file_one=
            file_two=
        fi
        printf "%-70s | %-5s | %-7s | %-15s\n" "${file}" "${size}" "${lines}" "${match}"
        match=
    done <<< "${files}"
}

compare_directory_files