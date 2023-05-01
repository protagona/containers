#!/bin/bash
:
# shellcheck disable=SC1091
source "$HOME/.bashrc"

set -e

set -x
sudo su -s /bin/zsh - developer
# tool_versions_dir="$HOME/workspace"
# tool_versions_path="$tool_versions_dir/.tool-versions"
# if [[ -f $tool_versions_path ]]; then
#     export ASDF_TOOLS_VERSIONS_DIR="$tool_versions_dir"
#     "$RESOURCES_PATH/scripts/libs/asdf_install"
# fi
