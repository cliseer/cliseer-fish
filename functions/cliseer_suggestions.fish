function cliseer_suggestions
    # Get current command and buffer position
    set -l cmd (commandline)
    
    # Call Python script with current command and history
    # Output is piped to fzf for selection
    set -l selected_cmd (cliprophesy "$cmd" | fish_indent | fzf --height 40% --reverse --ansi --bind 'ctrl-space:abort')
    
    # If user selected a command, replace current command with it
    if test -n "$selected_cmd"
        set -l clean_cmd (echo $selected_cmd | sed 's/\s*#.*$//')
        commandline -r $clean_cmd
        commandline -f repaint
    else
        commandline -r $cmd
        commandline -f repaint
    end
end
