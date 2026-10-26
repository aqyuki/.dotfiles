
# Complete OWNER from local cache only.
function __ghq_clone_complete_owners
    set -l dir (__ghq_clone_cache_dir)
    test -d "$dir"; or return 0

    # Resolve the current GitHub identity without API access.
    set -l login (gh api --cache 24h user --jq '.login' 2>/dev/null)
    test -n "$login"; or return 0

    set -l owners

    for meta in "$dir/$login-"*.etag
        test -f "$meta"; or continue

        set -l prefix (string replace -r '\.etag$' '' -- "$meta")
        set prefix (string replace "$dir/" '' -- "$prefix")

        set -l cache (__ghq_clone_cache_path "$dir" "$prefix")
        test -n "$cache"; or continue

        while read -l line
            set -l fields (string split \t -- "$line")
            test (count $fields) -ge 2; or continue

            set -l parts (string split -m1 / -- "$fields[1]")
            test (count $parts) -eq 2; or continue

            set -l owner "$parts[1]"

            if not contains -- "$owner" $owners
                set -a owners "$owner"
            end
        end < "$cache"
    end

    if test (count $owners) -gt 0
        printf '%s\n' $owners | command sort -fu
    end
end

# Allow OWNER completion only before a positional argument.
function __ghq_clone_needs_owner
    set -l tokens (commandline -opc)

    for token in $tokens[2..]
        if not string match -q -- '-*' "$token"
            return 1
        end
    end

    return 0
end

complete -c ghq-clone -f

complete -c ghq-clone \
    -n '__ghq_clone_needs_owner' \
    -a '(__ghq_clone_complete_owners)' \
    -d 'Cached GitHub owner'

complete -c ghq-clone \
    -l all \
    -d 'Include all accessible repositories'

complete -c ghq-clone \
    -l refresh \
    -d 'Revalidate cache using ETag'

complete -c ghq-clone \
    -l include-archived \
    -d 'Include archived repositories'

complete -c ghq-clone \
    -s h -l help \
    -d 'Show help'
