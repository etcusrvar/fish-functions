function bash-env -d "Export bash environment"

    argparse \
        (fish_opt -s i -l ignore -r) \
        (fish_opt -s o -l options -r) \
        (fish_opt -s v -l verbose) \
        -- $argv

    echo -n $_flag_options | read -ald " " options
    echo -n $_flag_ignore | read -ald "," ignored_keys
    set -a ignored_keys _

    for i in (bash $options -c env | string replace "=" " ")
        echo $i | read -ld " " k v
        contains $k $ignored_keys && continue

        if test "$$k" != "$v"
            set -q _flag_verbose
            and echo set -gx $k $v >&2

            set -gx $k $v
        end
    end

end
