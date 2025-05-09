function cliseer_suggestions
    # Get current command and buffer position
    set -l cmd (commandline)
    set -l selected_cmd ($__cliseer_bin_dir/cliprophesy "$cmd" | fzf --height 40% --reverse --ansi --bind 'ctrl-space:abort')
    
    if test -n "$selected_cmd"
        set -l clean_cmd (echo $selected_cmd | sed 's/\s*#.*$//')
        commandline -r $clean_cmd
        commandline -f repaint
    else
        commandline -r $cmd
        commandline -f repaint
    end
end
