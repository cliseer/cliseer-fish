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

function _cliseer_cliprophesy_dependency --on-event cliseer_dependencies_install
    # Check if cliprophesy is already installed in PATH
    if type -q cliprophesy
        echo "cliprophesy is already installed."
        return 0
    end

    echo "cliprophesy, a CLI helper module, is required."

    # Set platform-specific binary name
    switch (uname)
        case Linux
            set binary_name cliprophesy-linux
        case Darwin
            set binary_name cliprophesy-macos
        case '*'
            echo "Unsupported OS: (uname)"
            return 1
    end

    read -P "Download release from github? [y/N] " -l answer 
    if test "$answer" != "y"
       echo "Installation skipped, for manual installations see https://github.com/cliseer/cliprophesy"
       return 0
    end

    # Set install location
    set bin_dir $HOME/.local/bin
    mkdir -p $bin_dir

    # Download latest release
    set url "https://github.com/cliseer/cliprophesy/releases/latest/download/$binary_name"
    set dest "$bin_dir/cliprophesy"
    echo "Downloading $binary_name from $url to $dest"
    curl -L $url -o $dest

    # Make executable
    chmod +x $dest

    # Check if bin_dir is in PATH
    if not contains $bin_dir $PATH
        echo ""
        echo "Directory $bin_dir is not in your PATH."
        read -P "Add $bin_dir to your PATH? [y/N] " -l answer
        if test "$answer" = "y"
            set -Ux fish_user_paths $bin_dir $fish_user_paths
            echo "Added $bin_dir to your PATH."
        else
            echo "You can add it later with:"
            echo "  set -Ux fish_user_paths $bin_dir \$fish_user_paths"
        end
    end

    return 0
end

function _config_dependency --on-event cliseer_dependencies_install
     if test -f ~/.config/cliseer/settings.cfg
        return 0
     end
     mkdir -p ~/.config/cliseer/
     curl https://gist.githubusercontent.com/ygreif/f9879149afbe2382006c867fe099dce8/raw/6874a3989e4bf2886183cf94ee743d399beebd40/gistfile1.txt > ~/.config/cliseer/settings.cfg
     echo "Cliseer configuration file created at ~/.config/cliseer/settings.cfg. Edit this file to customize behavior."
     return 0
end

function _cliseer_fzf_dependency --on-event cliseer_dependencies_install
     if type -q fzf
        echo "fzf is already installed"
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
