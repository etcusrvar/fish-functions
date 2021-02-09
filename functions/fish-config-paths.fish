function fish-config-paths -a cmd -d "Update completions,conf.d,functions paths"

    set -e argv[1]

    switch $cmd
        case "" --help
            echo "Usage: fish-config-paths COMMAND

Commands:
    add     add path(s)"

        case add
            test -z "$argv"
            and set argv .

            __fish-config-paths-add $argv

        case \*
            return 1

    end

end

function __fish-config-paths-add

    # This function can be called from config.fish or conf.d/*
    # Be extra careful not to recursively source config.fish or conf.d/*
    #   in $__fish_config_dir
    # (fish-config-paths add $__fish_config_dir) should work fine

    # recursion may occur if
    #   $__fish_config_dir != (realpath $__fish_config_dir)
    set -l realpath_fish_config_dir (realpath $__fish_config_dir)

    for path in $argv

        # don't add if path doesn't exist
        test -d "$path" || continue

        # so relative paths will work
        set -l path (realpath $path)

        # prepend or bring to front of list
        set -g fish_complete_path \
            $path/completions \
            (string match -v $path/completions $fish_complete_path)
        set -g fish_function_path \
            $path/functions \
            (string match -v $path/functions $fish_function_path)

        if test $path != $realpath_fish_config_dir # don't recurse!
            for f in $path/conf.d/*.fish
                source $f
            end
        end

        if test -d $path/functions
            # add functions/* subdirs
            #   (for `complete...`, reference share/functions/__fish_complete_directories.fish)
            for p in (complete -C "__nonexistent-command__ $path/functions/" |
                string match -r '.*/$' |
                string trim -rc '/'
                printf "%s\n" $path/functions
                )
                # prepend or bring to front of list
                set -g fish_function_path \
                    $p \
                    (string match -v $p $fish_function_path)
            end
        end

        if test $path != $realpath_fish_config_dir # don't recurse!
            and test -f $path/config.fish

            source $path/config.fish
        end

    end

end
