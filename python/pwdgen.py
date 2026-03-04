import sys
import secrets

WISHLIST_LOWER = 'abcdefghjkmnprstuwxyz'
WISHLIST_HIGHER = 'ACDEFGHJKLMNPQRTUVWXYZ'
WISHLIST_DIGITS = '123456789'
WISHLIST_FULL = WISHLIST_LOWER + WISHLIST_HIGHER + WISHLIST_DIGITS

def generate_secure_string(length, wishlist):
    return ''.join(secrets.choice(wishlist) for _ in range(length))

def main():
    try:
        length = int(sys.argv[1]) if len(sys.argv) > 1 else 12
        if length < 6:
            length = 12
        if length > 1024:
            length = 1024
    except ValueError:
        length = 12

    main_part = generate_secure_string(length, WISHLIST_FULL)

    char_l = generate_secure_string(1, WISHLIST_LOWER)
    char_h = generate_secure_string(1, WISHLIST_HIGHER)
    digits = generate_secure_string(2, WISHLIST_DIGITS)
    suffix = f"-{char_l}{char_h}{digits}"

    parts = [main_part[i:i + 6] for i in range(0, len(main_part), 6)]
    formatted_main = "-".join(parts)

    final_pwd = formatted_main + suffix
    print(final_pwd)

if __name__ == "__main__":
    main()
