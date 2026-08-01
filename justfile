set shell := ["fish", "-c"]

set lists
set unstable

rsyncflags := [
    "--recursive",
    "--checksum",
    "--delete",
    "--mkpath",
    "--itemize-changes",
    "--verbose",
]

default:
    @just --list

assets:
    rsync {{quote(rsyncflags)}} \
        --include='*/' --include='*.woff2' --exclude='*' \
        (nix build --no-link --print-out-paths .#ibm-plex-mono)/share/fonts/woff2/ \
        public/static/fonts/ibm-plex-mono

serve: assets
    miniserve public --index index.html

publish: assets
    rsync {{quote(rsyncflags)}} \
        public/ lukas@moontide.ink:/var/www/moontide.ink

format:
    treefmt
