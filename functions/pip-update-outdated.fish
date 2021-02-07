function pip-update-outdated -d "Update outdated python packages"

    set -l pip pip
    set -l venv $argv[1]

    if test -n "$venv"
        set pip $venv/bin/pip
        if not test -f $pip
            echo pip-update-outdated: $pip not found
            return 1
        end
    else if not set -q VIRTUAL_ENV
        echo pip-update-outdated: not in a virtualenv
        return 1
    end

    set -l packages (
        $pip list --outdated --format freeze 2>/dev/null |
        string replace -r "==.*" ""
    )

    test -n "$packages"
    and $pip install --upgrade $packages

    return 0

end
