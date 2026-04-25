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
