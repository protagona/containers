source "$HOME/.asdf/asdf.sh"

if [ -d "$HOME/.bashrc.d" ]; then
    find "$HOME/.bashrc.d" -type f -name "*.sh" -print0 | while IFS= read -r -d '' script; do
        source "$script"
    done
fi
