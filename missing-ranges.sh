#!/bin/bash

source variables.sh

function missing_ranges {
	set -eu
	local input_range=(${1})
	local input_range_length=${#input_range[@]}
	local i=${MISSING_RANGE_SUFFIX_START}
	local j=0
	local missing_range_start=
	local missing_range_end=
	while [ ${i} -le ${MISSING_RANGE_SUFFIX_END} ] && [ ${j} -lt ${input_range_length} ]
	do
		local compleate_range_item_formatted=$(printf "%${MISSING_RANGE_SUFFIX_FILLING}${MISSING_RANGE_SUFFIX_LENGTH}d" "${i}")
		local input_item_formatted="${input_range[j]}"
		#local input_item_formatted=`printf "%${MISSING_RANGE_SUFFIX_FILLING}${MISSING_RANGE_SUFFIX_LENGTH}d" "${input_range[j]}"`
		if [ ${compleate_range_item_formatted} = ${input_item_formatted} ]
		then
			j=$(( ${j} + 1 ))
			if [ ! -z "${missing_range_start}" ];
			then
				missing_range_end=$(( ${i} - 1 ))
				missing_range_end=$(printf "%${MISSING_RANGE_SUFFIX_FILLING}${MISSING_RANGE_SUFFIX_LENGTH}d" "${missing_range_end}")
				echo "range ${missing_range_start} - ${missing_range_end} missing"
				missing_range_start=
			fi
		else
			if [ -z "${missing_range_start}" ];
			then
				missing_range_start=${compleate_range_item_formatted}
			fi
		fi
		i=$(( ${i} + 1 ))
	done
	if [ ${i} -le ${MISSING_RANGE_SUFFIX_END} ];
	then
		if [ -z "${missing_range_start}" ];
		then
			missing_range_start=$(printf "%${MISSING_RANGE_SUFFIX_FILLING}${MISSING_RANGE_SUFFIX_LENGTH}d" "${i}")
		fi
		missing_range_end=$(printf "%${MISSING_RANGE_SUFFIX_FILLING}${MISSING_RANGE_SUFFIX_LENGTH}d" "${MISSING_RANGE_SUFFIX_END}")
		echo "range ${missing_range_start} - ${missing_range_end} missing"
	fi
}


read stdin_range
missing_ranges "${stdin_range}"
echo "${stdin_range}" | \
tr " " "\n" | \
sort | \
awk '{ a[$0]++ } END{ for(x in a) if (a[x] != 1) print a[x], x }'