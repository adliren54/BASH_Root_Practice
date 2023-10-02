#!/bin/bash

# Check if the user provided an argument
#if [ -z "$1" ]; then
 #echo "Usage: ./Splitter.sh <top-level-directory>"
 #return 1
#fi

# Store the top-level directory path
top_directory="$1"

# Loop and navigate through each subdirectory
for i in {0..9}; do
  cd "$top_directory/$i" || { echo "Directory $top_directory/$i does not exist. Please check the directory again."; return 1; }

  # Find the event line numbers where each new event starts
  eventLines=$(grep -n 'BEGINNINGOFEVENT' HIJING_LBF_test_small.out | awk 'BEGIN {FS=":"}{print $1}')

  # Initialize variables to keep track of the number of event and line range for each event
  startLine=0
  endLine=0
  eventCounter=0

  # Loop through the line numbers
  for line in $eventLines; do
    if [ $startLine -eq 0 ]; then
      startLine=$line
    else
      endLine=$((line - 1))

      # Use sed to extract lines from start_line to end_line and save to a new file
      sed -n "${startLine},${endLine}p" HIJING_LBF_test_small.out > "event_${eventCounter}.dat"

      # Update start_line for the next iteration
      startLine=$line

      # Increment event counter
      eventCounter=$((eventCounter + 1))
    fi
  done

  # Handle the last event
  endLine=$(wc -l < HIJING_LBF_test_small.out)
  sed -n "${startLine},${endLine}p" HIJING_LBF_test_small.out > "event_${eventCounter}.dat"

  #Exit to initial directory
  cd - > /dev/null || exit

done
