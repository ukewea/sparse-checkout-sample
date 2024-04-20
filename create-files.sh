#!/bin/bash

# Define the base path to your git repository
REPO_PATH="."

# Define the folder paths
FOLDER_A="$REPO_PATH/project-001"
FOLDER_A_SUBDIR="$REPO_PATH/project-001/project-001-subdir"
FOLDER_B="$REPO_PATH/project-002"
FOLDER_C="$REPO_PATH/project-003"
FOLDER_LARGE="$REPO_PATH/project-very-large-files"

# Ensure the folders exist
mkdir -p "$FOLDER_A" "$FOLDER_B" "$FOLDER_C" "$FOLDER_LARGE"

# Change to the repository directory
cd "$REPO_PATH"

# Function to add and commit files in a specified folder
commit_files() {
  local folder_path=$1
  local start_index=$2
  local end_index=$3

  for i in $(seq $start_index $end_index); do
    # Create a dummy file with a unique name
    echo "This is dummy file $i in $(basename $folder_path)" > "$folder_path/dummy_file_$i.txt"

    # Add the file to the Git repository
    git add "$folder_path/dummy_file_$i.txt"

    # Commit the file with a unique commit message
    git commit -m "Add dummy file $i in $(basename $folder_path)"
  done
}

# Function to create a large file and commit it with unified signature
create_large_files() {
  local folder_path=$1
  local start_index=$2
  local end_index=$3
  local size_mb=$4  # Size in megabytes for each file

  for i in $(seq $start_index $end_index); do
    local file_name="large_file_$i.dat"
    local file_path="$folder_path/$file_name"

    # Create a file of specified size using 'dd'
    dd if=/dev/urandom of="$file_path" bs=1M count=$size_mb iflag=fullblock

    # Add and commit the file
    git add "$file_path"
    git commit -m "Add $file_name, size ${size_mb}MB"
  done
}

mkdir "$FOLDER_A"
mkdir "$FOLDER_A_SUBDIR"
mkdir "$FOLDER_B"
mkdir "$FOLDER_C"
mkdir "$FOLDER_LARGE"

# Perform the required file creations and commits
commit_files "$FOLDER_A" 1 5
commit_files "$FOLDER_B" 6 10

create_large_files "$FOLDER_LARGE" 1 5 50

commit_files "$FOLDER_C" 11 15
commit_files "$FOLDER_B" 16 20

create_large_files "$FOLDER_LARGE" 6 10 50

commit_files "$FOLDER_A" 21 25

commit_files "$FOLDER_A_SUBDIR" 26 30

commit_files "$FOLDER_B" 31 35
commit_files "$FOLDER_C" 36 40

create_large_files "$FOLDER_LARGE" 11 15 50

commit_files "$FOLDER_A" 41 45
commit_files "$FOLDER_B" 46 50

echo "Commits and file creations have been performed as requested."
