#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "No CSV filename supplied"
    exit 1
fi

csv_file="$1"

# create an array of filter types
filters=("FROM" "SUBJECT" "TEXT" "TO")

# loop through each filter type
for filter in "${filters[@]}"
do
    # loop through each customer and generate a text file for that customer's filter type
    while read -r line
    do
        customer=$(echo "$line" | cut -d ';' -f 1)
        filter_type=$(echo "$line" | cut -d ';' -f 2)
        filter_content=$(echo "$line" | cut -d ';' -f 3)
        type=$(echo "$line" | cut -d ';' -f 4)
        if [[ $filter_type == $filter ]]
        then
            if [[ $type == "ALWAYS" ]]
            then
                type_name="Blacklist"
            elif [[ $type == "NEVER" ]]
            then
                type_name="Whitelist"
            else
                type_name="Possible"
            fi
            case $filter_type in
                "FROM") type_desc="Sender" ;;
                "TO") type_desc="Recipient" ;;
                "SUBJECT") type_desc="Subject" ;;
                "TEXT") type_desc="Body" ;;
            esac
            filename="${customer}_${type_name}_${type_desc}.txt"
            echo "Creating file $filename"
            echo "$filter_content" >> "$filename"
        fi
    done < "$csv_file"
done

