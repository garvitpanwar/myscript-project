#!/bin/bash

# File name
DATA_FILE="today"

# Validate input arguments
if [ $# -ne 2 ]; then
    echo "Usage: $0 <Name> <Roll_No|Marks|Subject>"
    exit 1
fi

# Assign input arguments to variables
NAME=$1
FIELD=$2

# Validate field input
if [[ "$FIELD" != "Roll_No" && "$FIELD" != "Marks" && "$FIELD" != "Subject" ]]; then
    echo "Error: Field must be one of Roll_No, Marks, or Subject."
    exit 1
fi

# Check if data file exists
if [ ! -f "$DATA_FILE" ]; then
    echo "Error: Data file '$DATA_FILE' not found."
    exit 1
fi

# Using awk to filter and print the required field for the given name
awk -F "|" -v name="$NAME" -v field="$FIELD" '
    BEGIN {
        # Field mapping
        fieldIndex["Roll_No"] = 3
        fieldIndex["Subject"] = 4
        fieldIndex["Marks"] = 5
    }
    NR == 1 { next }  # Skip header row
    tolower($2) == tolower(name) {  # Case-insensitive match
        if (field == "Marks") {
            print $2, $5
        } else if (field == "Roll_No") {
            print $2, $3
        } else if (field == "Subject") {
            print $2, $4
        }
        found = 1
        exit
    }
    END {
        if (!found) {
            print "No record found for Name:", name
        }
    }
' "$DATA_FILE"

