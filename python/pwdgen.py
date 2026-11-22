#!/usr/bin/env python3
"""Human-readable secure password generator."""

import argparse
import secrets
from typing import List, Optional

WISHLIST_LOWER = "abcdefghjkmnprstuwxyz"
WISHLIST_UPPER = "ACDEFGHJKLMNPQRTUVWXYZ"
WISHLIST_DIGITS = "123456789"
WISHLIST_FULL = WISHLIST_LOWER + WISHLIST_UPPER + WISHLIST_DIGITS

DEFAULT_LENGTH = 18
MIN_LENGTH = 8
MAX_LENGTH = 1024
DEFAULT_COUNT = 1
MAX_COUNT = 1000
GROUP_SIZE = 6
SUFFIX_LENGTH = 5  # '-' + 1 lower + 1 upper + 2 digits


def parse_length(raw_value: Optional[str]) -> int:
    if raw_value is None:
        return DEFAULT_LENGTH
    try:
        length = int(raw_value)
    except ValueError:
        return DEFAULT_LENGTH
    if length < MIN_LENGTH:
        return DEFAULT_LENGTH
    if length > MAX_LENGTH:
        return MAX_LENGTH
    return length


def parse_count(raw_value: Optional[str]) -> int:
    if raw_value is None:
        return DEFAULT_COUNT
    try:
        count = int(raw_value)
    except ValueError:
        return DEFAULT_COUNT
    if count < 1:
        return DEFAULT_COUNT
    if count > MAX_COUNT:
        return MAX_COUNT
    return count


def generate_password(length: int = DEFAULT_LENGTH) -> str:
    main_length = length - SUFFIX_LENGTH
    chars: List[str] = []

    for i in range(main_length):
        if (i + 1) % (GROUP_SIZE + 1) == 0 and i != main_length - 1:
            chars.append("-")
        else:
            chars.append(secrets.choice(WISHLIST_FULL))

    char_l = secrets.choice(WISHLIST_LOWER)
    char_u = secrets.choice(WISHLIST_UPPER)
    digits = "".join(secrets.choice(WISHLIST_DIGITS) for _ in range(2))
    return "".join(chars) + f"-{char_l}{char_u}{digits}"


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Generate human-readable secure passwords."
    )
    parser.add_argument(
        "length",
        nargs="?",
        default=None,
        help=f"Total password length ({MIN_LENGTH}-{MAX_LENGTH}, default: {DEFAULT_LENGTH})",
    )
    parser.add_argument(
        "-n",
        "--count",
        default=None,
        help=f"Number of passwords to generate (1-{MAX_COUNT}, default: {DEFAULT_COUNT})",
    )
    args = parser.parse_args()

    length = parse_length(args.length)
    count = parse_count(args.count)

    for _ in range(count):
        print(generate_password(length))


if __name__ == "__main__":
    main()
