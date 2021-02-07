# repeat ls
# repeat 10 ssh host
# repeat "ls; date"
# repeat 2 "ls 2>/dev/null"
# repeat 3 --separate --date --sleep 10 ssh host
# repeat -Sds10 ssh host

function repeat -d "Repeat commands"

    set -l count
    if string match -qr '^[0-9]+$' -- "$argv[1]"
        set count $argv[1]
        test $count -eq 0
        and return 1

        set -e argv[1]
    else
        set -e count
    end

    set -l _flag_sleep 0.25
    argparse \
        --ignore-unknown \
        --stop-nonopt \
        (fish_opt -s d -l date) \
        (fish_opt -s S -l separate) \
        (fish_opt -rs s -l sleep) \
        -- $argv

    test -n "$argv"
    or return 1

    while true
        set -q _flag_separate && echo ~~~~~
        set -q _flag_date && date
        eval $argv
        if set -q count
            set count (math $count - 1)
            test $count -eq 0
            and break
        end
        set -q _flag_separate && echo
        sleep $_flag_sleep
    end

end
