#!/usr/bin/env fish

# Define colors for output
set green (set_color green)
set yellow (set_color yellow)
set red (set_color red)
set normal (set_color normal)

# Define Fish directories
set -l fish_config_dir "$HOME/.config/fish"
set -l fish_conf_dir "$fish_config_dir/conf.d"
set -l fish_functions_dir "$fish_config_dir/functions"

# Function to create directories if they don't exist
function ensure_dir
    if not test -d $argv[1]
        echo "$yellow Creating directory $argv[1] $normal"
        mkdir -p $argv[1]
    end
end

# Create necessary directories
ensure_dir "$fish_config_dir"
ensure_dir "$fish_conf_dir"
ensure_dir "$fish_functions_dir"

# Copy configuration files
echo "$green Installing cliseer configuration files... $normal"
cp conf.d/*.fish "$fish_conf_dir/"
cp functions/*.fish "$fish_functions_dir/"

# Check if cliprophesy is installed
if not command -v cliprophesy &>/dev/null
    echo "$yellow Warning: cliprophesy command not found. You'll need to install it separately. $normal"
    echo "$yellow cliseer won't work without cliprophesy installed. $normal"
end

# Reload configuration and trigger dependency check
echo "$green Reloading Fish configuration... $normal"
for conf_file in "$fish_conf_dir"/cliseer*.fish
    if test -f "$conf_file"
        echo "$yellow Reloading $conf_file $normal"
        source "$conf_file" 2>/dev/null || true
    end
end
emit cliseer_dependencies_install

echo "$green Installation complete! Cliseer has been installed. $normal"
echo "You can use $yellow Ctrl+Space $normal or $yellow Ctrl+S $normal to activate cliseer suggestions."
