# Variables to store command information
set -g __fish_cmd_start_time 0
set -g __fish_last_cmd ""
set -g __fish_last_pwd ""

set -gx CLISEER_LOG_DIR "/tmp/cliseer/"
mkdir -p $CLISEER_LOG_DIR

# Function to run before command execution (preexec)
function __fish_preexec --on-event fish_preexec
    set -g __fish_cmd_start_time (date +%s.%N)
    set -g __fish_last_cmd $argv
    set -g __fish_last_pwd $PWD
    set -g __command_key "$__fish_cmd_start_time".(random)
end

# Function to run after command execution (postexec)
function __fish_postexec --on-event fish_postexec
    set -x exit_status $status
    set end_time (date +%s.%N)
    
    # Only log if we have a command (prevents logging empty lines)
    if test -n "$__fish_last_cmd"
        # Calculate execution time TODO: can be simpler
        set exec_time (math "$end_time - $__fish_cmd_start_time")
        
        # Format the timestamp
        set timestamp (date '+%Y-%m-%d %H:%M:%S')
        
        # Log the information
        echo "$__command_key ||| $timestamp ||| EXIT: $exit_status ||| PWD: $__fish_last_pwd ||| TIME: {$exec_time}s ||| CMD: $__fish_last_cmd" >> "$CLISEER_LOG_DIR/fish_terminal_log.txt"
    end
end
