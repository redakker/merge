#!/bin/bash

# Configuration: Filter branches for selection
FROMFILTER=""
TOFILTER=""

# Configuration: Repository folder (absolute path)
FOLDER=""

# Ensure dialog is installed
if ! command -v dialog &> /dev/null; then
    echo "Dialog is required but not installed. Install it using: sudo apt install dialog"
    exit 1
fi

# Change to the specified folder if configured
if [ -n "$FOLDER" ]; then
    cd "$FOLDER" || { echo "Failed to change directory to $FOLDER"; exit 1; }
fi

while true; do
    # Get the list of remote branches
    repos=($(git branch -r | grep -v '\->' | sed 's/origin\///' | sort -u))

    if [ ${#repos[@]} -lt 2 ]; then
        echo "At least two branches are needed for merging."
        exit 1
    fi

    # Filter branches based on configuration
    SOURCE_OPTIONS=()
    TARGET_OPTIONS=()
    for r in "${repos[@]}"; do
        [[ "$r" == *"$FROMFILTER"* ]] && SOURCE_OPTIONS+=("$r" "$r" off)
        [[ "$r" == *"$TOFILTER"* ]] && TARGET_OPTIONS+=("$r" "$r" off)
    done

    SOURCE_BRANCH=$(dialog --clear --title "Select Source Branch" --radiolist "Choose a branch to merge FROM:" 20 50 10 "${SOURCE_OPTIONS[@]}" 2>&1 >/dev/tty)

    if [ -z "$SOURCE_BRANCH" ]; then
        clear
        exit 0
    fi

    TARGET_BRANCH=$(dialog --clear --title "Select Target Branch" --radiolist "Choose a branch to merge INTO:" 20 50 10 "${TARGET_OPTIONS[@]}" 2>&1 >/dev/tty)

    if [ -z "$TARGET_BRANCH" ]; then
        clear
        exit 0
    fi

    # Ensure selections are different
    if [ "$SOURCE_BRANCH" == "$TARGET_BRANCH" ]; then
        dialog --msgbox "Source and target branches must be different." 10 40
        continue
    fi

    # Check if working directory is clean
    if ! git diff --quiet || ! git diff --cached --quiet; then
        dialog --msgbox "Working directory is not clean! Commit or stash changes before proceeding." 10 50
        clear
        exit 1
    fi

    # Check if there are unpushed commits
    if ! git diff --quiet @{u}; then
        dialog --msgbox "There are unpushed commits! Push or discard them before proceeding." 10 50
        clear
        exit 1
    fi

    # Confirm the merge decision
    dialog --clear --title "Confirm Merge" --yes-label "Merge" --no-label "Start Again" --yesno "Are you sure you want to merge '$SOURCE_BRANCH' into '$TARGET_BRANCH'?" 10 50
    case $? in
        0) ;;  # Proceed with merge
        1) continue ;;  # Start again
        *) clear; exit 0 ;;  # Quit
    esac

    # Clear screen before merging
    clear

    # Perform the merge
    echo "Merging $SOURCE_BRANCH into $TARGET_BRANCH..."

    # git checkout "$TARGET_BRANCH" || exit 1
    # git switch "$TARGET_BRANCH" || exit 1  # Ensure branch switch
    # git pull origin "$TARGET_BRANCH"

    git merge --no-ff "origin/$SOURCE_BRANCH" -m "$SOURCE_BRANCH is merged to $TARGET_BRANCH"
    if [ $? -ne 0 ]; then
        dialog --msgbox "Merge failed! Resolve conflicts manually." 10 40
        # git merge --abort
        continue
    fi

    # git push origin "$TARGET_BRANCH"
    dialog --msgbox "Merge completed successfully!" 10 40
    clear
    exit 0

done
