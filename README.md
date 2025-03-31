# Branch Merge Tool

## Introduction
The **Branch Merge Tool** is a user-friendly command-line utility that simplifies the process of merging Git branches. It provides a graphical interface within the terminal, making it easier for users to select and merge branches without needing to manually type Git commands.

## Purpose
Merging branches in Git can be a complex and error-prone process, especially for users unfamiliar with Git’s command-line operations. This tool provides:
- A **graphical user interface** (via `dialog`) for selecting branches.
- A step-by-step guided process to **ensure a safe merge**.
- **Pre-checks** to prevent merging when the working directory is not clean.
- An **easy way to confirm** merges before execution.

## Requirements
This tool requires the following:
- **Git**: Ensure Git is installed on your system.
- **dialog**: The `dialog` package is required for the text-based UI.
  - Install on Debian-based systems using: `sudo apt install dialog`
  - Install on Red Hat-based systems using: `sudo yum install dialog`

## Configuration
The script includes configurable parameters to customize behavior:

- `FROMFILTER`: A string used to filter the list of **source branches** (branches to merge FROM). Only branches containing this string will be displayed.
- `TOFILTER`: A string used to filter the list of **target branches** (branches to merge INTO). Only branches containing this string will be displayed.
- `FOLDER`: The absolute path of the Git repository. If set, the script will change to this directory before execution. If left empty, the current directory is used.

Modify these variables at the beginning of the script to suit your needs.

## How to Use
1. Clone or download the script to your local machine.
2. Ensure the script is executable:
   ```bash
   chmod +x branch-merge-tool.sh
   ```
3. Run the script:
   ```bash
   ./branch-merge-tool.sh
   ```
4. The tool will display:
   - A list of **source branches** (branches to merge FROM)
   - A list of **target branches** (branches to merge INTO)
5. Select a branch from each list.
6. The tool will check if the working directory is clean and if there are any unpushed commits.
7. Confirm the merge operation.
8. If everything is correct, the merge will proceed. Otherwise, an error message will be shown.
9. If conflicts occur, the merge will stop so they can be resolved manually.

## Features
- **Graphical selection** of branches via a terminal-based UI.
- **Pre-merge validation** to check for:
  - A clean working directory
  - Unpushed commits
- **Automated Git operations** for checking out, merging, and pushing branches.
- **Configurable filters** to limit which branches are shown.
- **Option to restart or quit** if the user wants to start over.

## Possible Improvements
- **Branch naming filters**: Currently, filters are static in the script. They could be made dynamic via command-line arguments.
- **Conflict resolution helper**: The tool could suggest next steps when a conflict occurs.
- **Better error handling**: More detailed explanations when a merge fails.

## Notes
- The branches in this repository have only one purpose: test this Branch Merge Tool

## Versions
- 1.0 - 2025.03.28

## Usage Responsibility

By using this software, you acknowledge and agree that:

- This software is provided **as is**, without any guarantees or warranties, express or implied.
- The developers are **not responsible** for any data loss, security breaches, or unintended consequences resulting from its use.
- It is **your responsibility** to ensure that the software is configured and used in a way that complies with applicable laws, regulations, and best practices.
- Any **modifications, integrations, or usage in critical environments** should be thoroughly tested by you before deployment.
- The software may receive updates, but there is **no obligation** for continued maintenance or support.

By proceeding with the installation or usage of this software, you **accept full responsibility** for any outcomes. If you do not agree with these terms, please refrain from using it.


## Conclusion
The Branch Merge Tool simplifies Git branch management by providing an intuitive, text-based graphical interface. It is ideal for developers who want to merge branches easily without typing complex Git commands.

If you have suggestions for improvements, feel free to contribute!
