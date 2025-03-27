#!/bin/bash

# Define the base directory containing Git repositories
REPO_DIR="$HOME/repos"

# Ensure YAD is installed
if ! command -v yad &> /dev/null; then
    echo "YAD is required but not installed. Install it using: sudo apt install yad"
    exit 1
fi

# Get the list of repositories from Git
repos=($(git remote -v | awk '{print $1}' | sort -u))

if [ ${#repos[@]} -lt 2 ]; then
    echo "At least two repositories are needed for merging."
    exit 1
fi

# Create a YAD form for repository selection
selected_repos=$(yad --form --title="Select Repositories to Merge" \
    --field="Repo to Merge (Source)":CB "${repos[*]}" \
    --field="Merge Into (Target)":CB "${repos[*]}" --width=400)

# Extract selections
SOURCE_REPO=$(echo "$selected_repos" | cut -d '|' -f1)
TARGET_REPO=$(echo "$selected_repos" | cut -d '|' -f2)

# Ensure selections are different
if [ "$SOURCE_REPO" == "$TARGET_REPO" ]; then
    yad --error --text="Source and target repositories must be different."
    exit 1
fi

# Clone repositories if not already present
if [ ! -d "$REPO_DIR/$SOURCE_REPO" ]; then
    git clone "$SOURCE_REPO" "$REPO_DIR/$(basename "$SOURCE_REPO")"
fi
if [ ! -d "$REPO_DIR/$TARGET_REPO" ]; then
    git clone "$TARGET_REPO" "$REPO_DIR/$(basename "$TARGET_REPO")"
fi

SOURCE_PATH="$REPO_DIR/$(basename "$SOURCE_REPO")"
TARGET_PATH="$REPO_DIR/$(basename "$TARGET_REPO")"

# Perform the merge
echo "Merging $SOURCE_REPO into $TARGET_REPO..."
cd "$TARGET_PATH" || exit 1

git fetch origin

git merge --no-ff "$SOURCE_PATH" -m "$SOURCE_REPO is merged to $TARGET_REPO"
if [ $? -ne 0 ]; then
    yad --error --text="Merge failed! Resolve conflicts manually."
    git merge --abort
    exit 1
fi

yad --info --text="Merge completed successfully!"
