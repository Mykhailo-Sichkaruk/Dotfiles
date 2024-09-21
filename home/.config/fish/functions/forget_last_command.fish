function forget_last_command
    set -l cmd $history[1]
    if test -z "$cmd"
        echo "No commands in history"
        return
    end
    history delete --exact --case-sensitive -- $cmd
    echo "Last command '$cmd' removed from history"
end

