source "$HOME/.asdf/asdf.sh"

if [ -d "$HOME/.zshrc.d" ]; then
    find "$HOME/.zshrc.d" -type f \( -name "*.zsh" -o -name "*.sh" \) -print0 | while IFS= read -r -d '' script; do
        source "$script"
    done
fi
