#!/bin/sh
# replace_hardcoded.sh
#
# This script extracts package name constants from common.sh and replaces hardcoded values
# in other shell scripts with these constants.
#
# Usage: ./replace_hardcoded.sh [directory]
#   If directory is not specified, it will use the current directory.

set -e

COMMON_SH="common.sh"
DIR=${1:-.}

# Check if common.sh exists
if [ ! -f "$DIR/$COMMON_SH" ]; then
  echo "Error: $DIR/$COMMON_SH not found."
  exit 1
fi

echo "Extracting package constants from $DIR/$COMMON_SH..."

# Extract package name constants and their values from common.sh
# Format: NAME="value" where NAME contains _PACKAGE_NAME
# What it does with a line like export AUTOCONF_PACKAGE_NAME="autoconf-2.72":
# Captures "AUTOCONF_PACKAGE_NAME" as group 1
# Captures "autoconf-2.72" as group 2
# Outputs: "AUTOCONF_PACKAGE_NAME autoconf-2.72"
# This output format (variable name and value separated by a space) makes it easy for the script to read both
# pieces of information in the while read -r const_name const_value loop that processes each line.
extract_constants() {
  grep -E 'export [A-Za-z0-9_]+_PACKAGE_NAME=' "$DIR/$COMMON_SH" |
  sed -E 's/export ([A-Za-z0-9_]+_PACKAGE_NAME)="([^"]*)".*/\1 \2/'
}

# Process each script in the directory
process_scripts() {
  for script in "$DIR"/*.sh; do
    # Skip common.sh and the current script
    base_script=$(basename "$script")
    if [ "$base_script" = "$COMMON_SH" ] || [ "$base_script" = "$(basename "$0")" ]; then
      continue
    fi

    # Check if this is a compile script
    echo "Processing $script..."

    # Apply each replacement
    extract_constants | while read -r const_name const_value; do
      if grep -q "$const_value" "$script"; then
        echo "  Replacing '$const_value' with \$$const_name"
        # Create a safe pattern for sed by escaping special characters
        safe_value=$(echo "$const_value" | sed 's/[\/&]/\\&/g')
        # Use a temporary file to avoid issues with in-place editing across systems
        sed "s/$safe_value/\$$const_name/g" "$script" > "$script.tmp"
        mv "$script.tmp" "$script"
      fi
    done
  done
}

# Main execution
echo "Starting replacement process..."
process_scripts
echo "Replacement complete!"

