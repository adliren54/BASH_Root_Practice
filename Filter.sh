#!/bin/bash

#Store the top-level directory path
topDirectory="$1"

#Loop through each event in the respective subdirectory
while read -r File; do
  #Navigate to the directory of current file
  cd "$(dirname "$File")" || { echo "Directory does not exist"; return 1; }

  #Store the basename of current file
  currentFile=$(basename "$File")

  #Create backup of current file
  cp "$currentFile" "backup_${currentFile}"

  #Filter out only the primary particles (label 0 in the 3rd column)
  awk '{if ($3 == 0) print $0}' < "backup_${currentFile}" > "$currentFile"

  #Remove backup
  rm "backup_${currentFile}"

  #Exit to initial directory
  cd - > /dev/null || exit

done < <(find "$topDirectory" -type f -name "event_*.dat")
