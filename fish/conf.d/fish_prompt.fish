function fish_prompt
    set -l last_status $status
    set -l cwd (prompt_pwd --full-length-dirs 3)

    # git branch
    set -l git_branch ""
    if git rev-parse --git-dir &>/dev/null 2>&1
        set git_branch (git branch --show-current 2>/dev/null)
    end

    # exit code indicator
    set -l arrow_color e55b5b
    if test $last_status -eq 0
        set arrow_color 424242
    end

    # path
    echo -n (set_color ff7575)$cwd(set_color normal)

    # git branch
    if test -n "$git_branch"
        echo -n (set_color 424242)" on "(set_color e55b5b)"$git_branch"(set_color normal)
    end

    # newline + arrow
    echo ""
    echo -n (set_color $arrow_color)"❯ "(set_color normal)
end
