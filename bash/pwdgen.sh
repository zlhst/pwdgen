#!/usr/bin/env bash
# Human-readable secure password generator.

set -eu

WISHLIST_LOWER='abcdefghjkmnprstuwxyz'
WISHLIST_UPPER='ACDEFGHJKLMNPQRTUVWXYZ'
WISHLIST_DIGITS='123456789'
WISHLIST_FULL="${WISHLIST_LOWER}${WISHLIST_UPPER}${WISHLIST_DIGITS}"

DEFAULT_LENGTH=18
MIN_LENGTH=8
MAX_LENGTH=1024
DEFAULT_COUNT=1
MAX_COUNT=1000
GROUP_SIZE=6
SUFFIX_LENGTH=5 # '-' + 1 lower + 1 upper + 2 digits

usage() {
  cat <<EOF
Usage: $(basename "$0") [length] [-n|--count COUNT]

Options:
  length              Total password length (${MIN_LENGTH}-${MAX_LENGTH}, default: ${DEFAULT_LENGTH})
  -n, --count COUNT   Number of passwords to generate (1-${MAX_COUNT}, default: ${DEFAULT_COUNT})
  -h, --help          Show this help message
EOF
}

parse_length() {
  local raw="${1:-}"
  if [[ ! "$raw" =~ ^[0-9]+$ ]]; then
    echo "$DEFAULT_LENGTH"
    return
  fi
  local val=$((10#$raw))
  if (( val < MIN_LENGTH )); then
    echo "$DEFAULT_LENGTH"
  elif (( val > MAX_LENGTH )); then
    echo "$MAX_LENGTH"
  else
    echo "$val"
  fi
}

parse_count() {
  local raw="${1:-}"
  if [[ ! "$raw" =~ ^[0-9]+$ ]]; then
    echo "$DEFAULT_COUNT"
    return
  fi
  local val=$((10#$raw))
  if (( val < 1 )); then
    echo "$DEFAULT_COUNT"
  elif (( val > MAX_COUNT )); then
    echo "$MAX_COUNT"
  else
    echo "$val"
  fi
}

# Exact rejection sampling on /dev/urandom bytes (no modulo bias)
random_chars() {
  local charset="$1"
  local count="$2"
  LC_ALL=C tr -dc "$charset" < /dev/urandom | head -c "$count"
}

generate_password() {
  local length="$1"
  local main_length=$((length - SUFFIX_LENGTH))
  local raw_main
  raw_main="$(random_chars "$WISHLIST_FULL" "$main_length")"

  local main=""
  local pos=0
  local i=0
  while (( i < main_length )); do
    if (( (i + 1) % (GROUP_SIZE + 1) == 0 && i != main_length - 1 )); then
      main+="-"
    else
      main+="${raw_main:pos:1}"
      pos=$((pos + 1))
    fi
    i=$((i + 1))
  done

  local char_l char_u digits
  char_l="$(random_chars "$WISHLIST_LOWER" 1)"
  char_u="$(random_chars "$WISHLIST_UPPER" 1)"
  digits="$(random_chars "$WISHLIST_DIGITS" 2)"

  printf '%s-%s%s%s\n' "$main" "$char_l" "$char_u" "$digits"
}

raw_length=""
raw_count=""

while (( $# > 0 )); do
  case "$1" in
    -h|--help)
      usage
      exit 0
      ;;
    -n|--count)
      shift
      raw_count="${1:-}"
      ;;
    --count=*)
      raw_count="${1#*=}"
      ;;
    *)
      if [[ -z "$raw_length" ]]; then
        raw_length="$1"
      fi
      ;;
  esac
  if (( $# > 0 )); then
    shift
  fi
done

length="$(parse_length "$raw_length")"
count="$(parse_count "$raw_count")"

n=0
while (( n < count )); do
  generate_password "$length"
  n=$((n + 1))
done
