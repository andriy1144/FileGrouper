#!/bin/bash

# Introdcution
echo "+================================================================+"
echo "|                   Welcome to the File Grouper                  |"
echo "|                                                                |"
echo "| - It has been written by Andriy Murhan using bash script       |"
echo "| - The program groups files by their file extensions.           |"
echo "| - Please follow next steps to get you directory files grouped. |"
echo "|                                                                |"
echo "+================================================================|"
echo

read -p "Enter a path for a directory to group: " targetDir

# Checking if the directory exists
if [ -d $targetDir ];
then
 # Moving to the directory
 cd $targetDir
 dirContent=(*)

 # Grouping files by their extensions
 declare -A fileSortedArr

 for file in ${dirContent[@]};
 do
  if [[ -f $file ]];
  then
   IFS='.'
   read -r -a fileNameSplit <<< $file

   if [[ ${#fileNameSplit[@]} > 1 ]];
   then
    fileExtension=${fileNameSplit[((${#fileNameSplit[@]}-1))]}
   else
    fileExtension="other"
   fi

   if [[ ${fileSortedArr[${fileExtension}]+1} ]];
   then
    fileSortedArr[$fileExtension]+=" "$file
   else
    fileSortedArr[$fileExtension]=$file
   fi
  fi
 done


 # Copying files to directories by their extensions
 groupedDirName='grouped_result'
 mkdir ../$groupedDirName

 for dir in ${!fileSortedArr[@]};
 do
  mkdir ../$groupedDirName/$dir"_s"
  IFS=" "
  files=(${fileSortedArr[$dir]})

  for fileToCopy in ${files[@]};
  do
   cp $fileToCopy ../$groupedDirName/$dir"_s"/$fileToCopy
  done
 done

else
  echo "The directory with a path $targetDir was not found!"
  exit
fi
