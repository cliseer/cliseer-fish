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

rm -i $fish_conf_dir/cliseer*.fish
rm -i $fish_functions_dir/cliseer*.fish

echo "$green Uninstallation complete! Cliseer has been removed. $normal"
echo "$yellow Note: You might need to restart your Fish shell for all changes to take effect. $normal"
