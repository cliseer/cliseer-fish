function maybe_run
    set -l cmd $argv
    read -P "Do you want to run: $cmd [y/N] " -l response
    if test "$response" = "y" -o "$response" = "Y"
        echo "Running: $cmd"
        eval $cmd
    else
        echo "Skipped: $cmd"
    end
end

function _config_dependency --on-event cliseer-fish_install
     mkdir -p ~/.config/cliseer/settings..cfg
     curl https://gist.githubusercontent.com/ygreif/f9879149afbe2382006c867fe099dce8/raw/6874a3989e4bf2886183cf94ee743d399beebd40/gistfile1.txt > ~/.config/cliseer/settings.cfg
     echo "Configure cliseer behavior from ~/.config/cliseer/settings.cfg
     return 0
end

function _cliseer_fzf_dependency --on-event cliseer-fish_install
     if type -q fzf
        echo "fzf is installed"
        return 0
     end
     echo "fzf, command-line fuzzy finder, is required"
     set os (uname)
     switch $os
       case "Darwin"
         maybe_run "brew install fzf"
       case "Linux"
         if test -f /etc/debian_version
           maybe_run "sudo apt install fzf"
         else
           maybe_run "sudo dnf install fzf"
         end
     end
       
     return 0
end
