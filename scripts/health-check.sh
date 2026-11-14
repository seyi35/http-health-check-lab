#!/usr/bin/env bash
# Local lab: pass only when the request completes and returns HTTP 200.

check_health() {
  local http_status

  # Return failure if curl cannot complete the request.
  http_status=$(curl -q --noproxy '*' --silent --show-error \
    --connect-timeout 2 --max-time 5 \
    --output /dev/null --write-out '%{http_code}' \
    "$1") || return 1

  printf 'HTTP status: %s\n' "$http_status"

  # The final comparison determines the function's exit status.
  [ "$http_status" = "200" ]
}

# Require an explicit URL so the caller chooses the intended endpoint.
if [ "$#" -ne 1 ] || [ -z "$1" ]; then
  printf 'Usage: bash %s <URL>\n' "${0##*/}" >&2
  exit 2
fi

check_health "$1"
