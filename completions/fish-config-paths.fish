complete -c fish-config-paths -xn "__fish_use_subcommand" -l help -d "Show help message and exit"
complete -c fish-config-paths -xn "__fish_use_subcommand" -a add -d "Manage recordings on asciinema.org account"
complete -c fish-config-paths -n "__fish_seen_subcommand_from add" -x -a "(__fish_complete_directories (commandline -ct) '')"
