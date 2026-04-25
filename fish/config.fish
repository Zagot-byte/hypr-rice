if status is-interactive
    fastfetch

    # Starship transient prompt from end-4
    function starship_transient_prompt_func
        starship module character
    end
    starship init fish | source
    enable_transience

    # Commands to run in interactive sessions can go here
end
function cliplast
    eval $history[1] | wl-copy && echo "copied to clipboard"
end
# pipe last command output to clipboard
abbr -a clip 'wl-copy'
