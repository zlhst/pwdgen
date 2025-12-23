import sys
import secrets
import re

def generate_secure_string(length, wishlist):
    return ''.join(secrets.choice(wishlist) for _ in range(length))

def main():
    wishlist_lower = 'abcdefghjkmnprstuwxyz'
    wishlist_higher = 'ACDEFGHJKLMNPQRTUVWXYZ'
    wishlist_digits = '123456789'
    wishlist_full = wishlist_lower + wishlist_higher + wishlist_digits

    try:
        length = int(sys.argv[1]) if len(sys.argv) > 1 else 12
        if length < 6:
            length = 12
        if length > 1024:
            length = 1024
    except ValueError:
        length = 12

    main_part = generate_secure_string(length, wishlist_full)

    char_l = generate_secure_string(1, wishlist_lower)
    char_h = generate_secure_string(1, wishlist_higher)
    digits = generate_secure_string(2, wishlist_digits)
    suffix = f"-{char_l}{char_h}{digits}"

    parts = re.findall('.{1,6}', main_part)
    formatted_main = "-".join(parts)

    final_pwd = formatted_main + suffix
    print(final_pwd)

if __name__ == "__main__":
    main()
