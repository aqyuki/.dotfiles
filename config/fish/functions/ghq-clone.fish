
# ghq-clone
# Dependencies: fish, gh, ghq, fzf, mkdir, mktemp, mv, rm, date
#
# Cache:
#   $XDG_CACHE_HOME/ghq-clone/<login>-<api>-<etag>.tmp
#   $XDG_CACHE_HOME/ghq-clone/<login>-<api>.etag
#   $XDG_CACHE_HOME/ghq-clone/<login>-<api>.timestamp
#
# Cached body format:
#   OWNER/REPO<TAB>true|false

function __ghq_clone_cache_dir
    if set -q XDG_CACHE_HOME; and test -n "$XDG_CACHE_HOME"
        printf '%s/ghq-clone\n' "$XDG_CACHE_HOME"
    else
        printf '%s/.cache/ghq-clone\n' "$HOME"
    end
end

# Resolve a cache entry from its ETag metadata.
function __ghq_clone_cache_path --argument-names dir prefix
    set -l etag_file "$dir/$prefix.etag"
    test -f "$etag_file"; or return 1

    set -l etag
    read -l etag < "$etag_file"
    test -n "$etag"; or return 1

    set -l safe_etag (
        string replace -ra '[^a-zA-Z0-9_.-]' '_' -- "$etag"
    )

    set -l path "$dir/$prefix-$safe_etag.tmp"
    test -f "$path"; or return 1

    printf '%s\n' "$path"
end

# Fetch one page, or reuse its cached response.
# Writes the TSV body to $output.
function __ghq_clone_fetch \
    --argument-names endpoint prefix dir refresh output

    set -l stamp_file "$dir/$prefix.timestamp"
    set -l etag_file "$dir/$prefix.etag"

    set -l cache (__ghq_clone_cache_path "$dir" "$prefix")
    set -l now (date +%s)

    # Use a fresh local cache without any API request.
    if test "$refresh" != true; and test -n "$cache"
        if test -f "$stamp_file"
            set -l updated
            read -l updated < "$stamp_file"

            if string match -rq '^[0-9]+$' -- "$updated"
                set -l age (math "$now - $updated")

                if test "$age" -ge 0; and test "$age" -lt 300
                    command cp "$cache" "$output"
                    return $status
                end
            end
        end
    end

    set -l request_args -i \
        --jq '.[] | [.full_name, (.archived | tostring)] | @tsv'

    # The ETag may be used on --refresh as well.
    if test -n "$cache"; and test -f "$etag_file"
        set -l etag
        read -l etag < "$etag_file"

        if test -n "$etag"
            set -a request_args \
                -H "If-None-Match: $etag"
        end
    end

    set -l response (mktemp "$dir/.response.XXXXXXXX")
    if test $status -ne 0
        return 1
    end

    # --include puts the status line and HTTP headers before
    # the formatted response body.
    gh api $request_args "$endpoint" > "$response" 2>/dev/null
    set -l request_status $status

    set -l http_status ''
    set -l new_etag ''
    set -l in_headers true

    # Separate the HTTP headers from the TSV body.
    # The body is staged before touching any cache files.
    set -l body (mktemp "$dir/.body.XXXXXXXX")
    if test $status -ne 0
        rm -f "$response"
        return 1
    end

    while read -l line
        set -l clean (string replace -r '\r$' '' -- "$line")

        if test "$in_headers" = true
            if string match -rq '^HTTP/[0-9.]+ [0-9]{3}' -- "$clean"
                set -l parts (string split ' ' -- "$clean")
                set http_status "$parts[2]"
                continue
            end

            if string match -rqi '^etag:' -- "$clean"
                set new_etag (
                    string replace -ri '^etag:[[:space:]]*' '' -- "$clean"
                )
                continue
            end

            if test -z "$clean"
                set in_headers false
                continue
            end
        else
            printf '%s\n' "$line" >> "$body"
        end
    end < "$response"

    rm -f "$response"

    switch "$http_status"
        case 304
            rm -f "$body"

            if test -z "$cache"
                echo "ghq-clone: 304 received without cache" >&2
                return 1
            end

            command cp "$cache" "$output"; or return 1

            set -l stamp_tmp (mktemp "$dir/.stamp.XXXXXXXX")
            or return 1

            printf '%s\n' "$now" > "$stamp_tmp"
            mv -f "$stamp_tmp" "$stamp_file"
            return $status

        case 200
            if test "$request_status" -ne 0
                rm -f "$body"
                echo "ghq-clone: API processing failed" >&2
                return 1
            end

        case '*'
            rm -f "$body"
            echo "ghq-clone: API request failed (HTTP $http_status)" >&2
            return 1
    end

    # A response without an ETag can still be used, but is
    # not persisted as an ETag-addressed cache entry.
    if test -z "$new_etag"
        mv -f "$body" "$output"
        return $status
    end

    set -l safe_etag (
        string replace -ra '[^a-zA-Z0-9_.-]' '_' -- "$new_etag"
    )

    set -l new_cache "$dir/$prefix-$safe_etag.tmp"

    # Atomically replace the response file.
    mv -f "$body" "$new_cache"; or return 1

    set -l etag_tmp (mktemp "$dir/.etag.XXXXXXXX")
    or return 1
    set -l stamp_tmp (mktemp "$dir/.stamp.XXXXXXXX")
    or return 1

    printf '%s\n' "$new_etag" > "$etag_tmp"
    printf '%s\n' "$now" > "$stamp_tmp"

    mv -f "$etag_tmp" "$etag_file"; or return 1
    mv -f "$stamp_tmp" "$stamp_file"; or return 1

    # Remove superseded response files for this page.
    for old in "$dir/$prefix-"*.tmp
        test -f "$old"; or continue
        test "$old" = "$new_cache"; and continue
        rm -f "$old"
    end

    command cp "$new_cache" "$output"
end

function ghq-clone \
    --description 'Clone GitHub repositories selected with fzf'

    argparse \
        'all' \
        'refresh' \
        'include-archived' \
        'h/help' \
        -- $argv
    or return 2

    if set -q _flag_help
        printf '%s\n' \
            'Usage: ghq-clone [OWNER] [OPTIONS]' \
            '' \
            'Options:' \
            '  --all               Include all accessible repositories' \
            '  --refresh           Revalidate cache using ETag' \
            '  --include-archived  Include archived repositories' \
            '  -h, --help          Show this help'
        return 0
    end

    if test (count $argv) -gt 1
        echo 'ghq-clone: too many arguments' >&2
        return 2
    end

    for cmd in gh ghq fzf
        if not command -q "$cmd"
            echo "ghq-clone: missing dependency: $cmd" >&2
            return 1
        end
    end

    # gh provides its own API response cache for identity.
    set -l login (gh api --cache 24h user --jq '.login' 2>/dev/null)
    if test $status -ne 0; or test -z "$login"
        echo 'ghq-clone: GitHub authentication failed' >&2
        return 1
    end

    set -l owner "$login"
    set -l owner_given false

    if test (count $argv) -eq 1
        set owner "$argv[1]"
        set owner_given true

        if not string match -rq '^[a-zA-Z0-9][a-zA-Z0-9-]*$' -- "$owner"
            echo 'ghq-clone: invalid OWNER' >&2
            return 2
        end
    end

    set -l refresh false
    set -l include_archived false
    set -l all false

    set -q _flag_refresh; and set refresh true
    set -q _flag_include_archived; and set include_archived true
    set -q _flag_all; and set all true

    set -l dir (__ghq_clone_cache_dir)
    mkdir -p "$dir"; or return 1

    # Use /user/repos for authenticated access, including
    # private repositories of organizations and collaborators.
    #
    # Explicit OWNER filters this accessible repository set.
    # Without OWNER, --all changes the affiliation scope.
    set -l affiliation owner

    if test "$all" = true; or test "$owner_given" = true
        set affiliation 'owner,collaborator,organization_member'
    end

    set -l scope 'owned'
    if test "$affiliation" != owner
        set scope 'accessible'
    end

    set -l results (mktemp "$dir/.results.XXXXXXXX")
    or return 1

    set -l page 1

    while true
        set -l endpoint \
            "/user/repos?affiliation=$affiliation&visibility=all&per_page=100&page=$page&sort=full_name&direction=asc"

        set -l prefix "$login-$scope-page_$page"

        set -l page_file (mktemp "$dir/.page.XXXXXXXX")
        if test $status -ne 0
            rm -f "$results"
            return 1
        end

        __ghq_clone_fetch \
            "$endpoint" "$prefix" "$dir" "$refresh" "$page_file"

        if test $status -ne 0
            rm -f "$page_file" "$results"
            return 1
        end

        set -l count_on_page 0

        while read -l line
            set -l fields (string split \t -- "$line")
            test (count $fields) -ge 2; or continue

            set count_on_page (math "$count_on_page + 1")

            set -l full_name "$fields[1]"
            set -l archived "$fields[2]"

            if test "$include_archived" = false
                if test "$archived" = true
                    continue
                end
            end

            if test "$owner_given" = true
                set -l repo_owner (
                    string split -m1 / -- "$full_name"
                )[1]

                if test (string lower -- "$repo_owner") != \
                    (string lower -- "$owner")
                    continue
                end
            end

            printf '%s\n' "$full_name" >> "$results"
        end < "$page_file"

        rm -f "$page_file"

        # A full page indicates that another page may exist.
        if test "$count_on_page" -lt 100
            break
        end

        set page (math "$page + 1")
    end

    if not test -s "$results"
        rm -f "$results"
        echo 'ghq-clone: no repositories found' >&2
        return 0
    end

    # Keep fzf interactive and preserve multiple selections.
    set -l selected (
        command cat "$results" |
        fzf \
            --multi \
            --height=80% \
            --layout=reverse \
            --prompt='GitHub repositories > ' \
            --header='TAB: select / ENTER: clone' \
            --border
    )

    rm -f "$results"

    if test (count $selected) -eq 0
        return 0
    end

    set -l failed 0

    for repo in $selected
        echo "ghq-clone: $repo"

        ghq get "https://github.com/$repo.git"

        if test $status -ne 0
            echo "ghq-clone: failed: $repo" >&2
            set failed 1
        end
    end

    return $failed
end
