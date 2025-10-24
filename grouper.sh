#!/bin/bash

# Security params
set -euo pipefail

# Logging functions
log_info()    { echo -e "[INFO] $*"; }
log_warn()    { echo -e "\033[33m[WARN]\033[0m $*"; }   # yellow
log_success() { echo -e "\033[32m[SUCCESS]\033[0m $*"; } # green
log_error()   { echo -e "\033[31m[ERROR]\033[0m $*"; }   # red

function introduction(){
  echo "+================================================================+"
  echo "|                   Welcome to the File Grouper                  |"
  echo "|                                                                |"
  echo "| - It has been written by Andriy Murhan using bash script       |"
  echo "| - The program groups files by their file extensions.           |"
  echo "| - Please follow next steps to get you directory files grouped. |"
  echo "|                                                                |"
  echo "+================================================================|"
  echo
}

# Non-recursive grouping
function group_files_by_extension(){
  local dir=$1
  local -n out_arr=$2
  cd "$dir" || { log_error "Directory not found: $dir"; return 1; }

  log_info "Scanning directory: $dir"

  local dir_content=(*)
  declare -A temp

  [[ ${#dir_content[@]} -eq 0 ]] && exit 1

  log_info "Grouping files by extensions..."

  for file in "${dir_content[@]}"; do
   if [[ -f $file ]]; then
    IFS='.' read -r -a parts <<< "$file"
    local ext="${parts[-1]:-other}"
    [[ "$ext" == "$file" ]] && ext="other"

    temp["$ext"]+="$file "
   fi
  done

  out_arr=()
  for key in "${!temp[@]}"; do
   out_arr["$key"]="${temp[$key]}"
  done
}

# Recursive grouping
function group_files_recursively(){
  local dir="$1"
  local -n out_arr="$2"

  cd "$dir" || { log_error "Directory not found: $dir"; return 1; }

  log_info "Scanning directory: $dir"
  log_info "Grouping files by extensions..."

  while IFS= read -r -d $'\0' file; do
   [[ -f "$file" ]] || continue
   local base_file="$(basename "$file")"
   IFS='.' read -r -a parts <<< "$base_file"
   local ext="${parts[-1]:-other}"
   [[ "$ext" == "$base_file" ]] && ext="other"
   out_arr["$ext"]+="$file "
  done < <(find . -type f -print0)
}

function copy_files_to_ext_dirs(){
  local -n grouped_files=$1
  [[ ${#grouped_files[@]} -eq 0 ]] && { log_warn "No files to copy"; return 1; }

  local output_dir=$2

  log_info "Preparing output structure: ../$output_dir"
  mkdir -p ../"$output_dir" || { log_error "Cannot create output directory ../$output_dir"; return 1; }

  for dir in "${!grouped_files[@]}"; do
   IFS=" "
   local final_path="$output_dir/${dir}_s"

   log_info "Creating folder for .$dir files"

   mkdir -p ../"$final_path" || { log_error "Cannot create subdirectory $final_path"; return 1; }
   files=(${grouped_files[$dir]})

   for file_to_copy in ${files[@]}; do
    local dest_name=$(basename "$file_to_copy")
    cp "$file_to_copy" ../"$final_path"/"$dest_name" || log_warn "Failed to copy $file_to_copy"
   done

   log_info "Copied ${#files[@]} file(s) to $final_path"
  done

  log_success "Copy completed! Results in ../$output_dir"
}

# Check for target directory name passed (opt)
if [[ -z "${1:-}" ]]; then
  introduction

  read -r -p "Enter a path for a directory to group: " TARGET_DIR
else
  TARGET_DIR="$1"
fi

# Check for passed parsing strategy (opt)
if [[ -z "${2:-}" ]]; then
  read -r -p "Enter the parsing strategy (r - recursevly, n - no, only one layer): " PARSING_STRATEGY
else
  PARSING_STRATEGY="$2"
fi

if [[ -d "$TARGET_DIR" ]]; then
  readonly GROUP_DIR_NAME="grouped_by_extension_$(basename $TARGET_DIR)"

  declare -A grouped_files_res
  if [[ "$PARSING_STRATEGY" == "r" ]]; then
   group_files_recursively "$TARGET_DIR" grouped_files_res
  else
   group_files_by_extension "$TARGET_DIR" grouped_files_res
  fi

  copy_files_to_ext_dirs grouped_files_res "$GROUP_DIR_NAME"
else
  log_error "Directory not found: $TARGET_DIR"
  exit 1
fi
