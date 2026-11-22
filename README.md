# pwdgen

Simple, human-readable secure password generator available in **HTML/JS**, **Python**, **Bash**, and **PowerShell**.

All versions follow the exact same rules and produce passwords that are strong, easy to read and re-type without mistakes, and pass typical password complexity checks out of the box.

## Why pwdgen?

Most password generators output strings that are frustrating to read or type manually. `pwdgen` keeps things simple:

- **No ambiguous characters**: omits visually confusing characters (`0`, `O`, `o`, `l`, `I`, `i`, `B`, `S`, `q`, `v`).
- **Readable groups**: splits the password with `-` separators (every 6 characters).
- **Guaranteed complexity**: always ends with `-aA12` (1 lowercase, 1 uppercase, 2 digits) plus `-` as a separator/special character.
- **Exact total length**: the `length` parameter is the exact length of the generated password including separators and suffix (default: `18`, min: `8`, max: `1024`).
- **Zero dependencies**: each script is standalone and uses the platform's CSPRNG without modulo bias.

Example (default length `18`):

```text
aB3kPm-9xRtWq-fK47
```

## Character Set

- **Lowercase (21)**: `abcdefghjkmnprstuwxyz`
- **Uppercase (22)**: `ACDEFGHJKLMNPQRTUVWXYZ`
- **Digits (9)**: `123456789`
- **Separator**: `-`

## Usage

### HTML / JS (`html/index.html`)

Open `html/index.html` directly in a browser or host it statically. Supports URL query parameters:

- `length`: total password length (`8`–`1024`, default: `18`)
- `style`: color theme (`1`–`16`)

```text
html/index.html?length=25&style=14
```

### Python (`python/pwdgen.py`)

Requires Python 3.6+ (uses the standard `secrets` module).

```bash
python python/pwdgen.py              # 1 password, length 18
python python/pwdgen.py 25           # 1 password, length 25
python python/pwdgen.py 25 -n 5      # 5 passwords, length 25
python python/pwdgen.py -n 5         # 5 passwords, length 18
```

### Bash / Linux (`bash/pwdgen.sh`)

Uses `/dev/urandom` with `tr` and `head` (no external dependencies).

```bash
chmod +x bash/pwdgen.sh
./bash/pwdgen.sh                     # 1 password, length 18
./bash/pwdgen.sh 25                  # 1 password, length 25
./bash/pwdgen.sh 25 -n 5             # 5 passwords, length 25
./bash/pwdgen.sh -n 5                # 5 passwords, length 18
```

### PowerShell / Windows (`powershell/pwdgen.ps1`)

Works on Windows PowerShell 5.1 and PowerShell 7+ (uses .NET `RandomNumberGenerator`).

```powershell
.\powershell\pwdgen.ps1              # 1 password, length 18
.\powershell\pwdgen.ps1 25           # 1 password, length 25
.\powershell\pwdgen.ps1 25 -n 5      # 5 passwords, length 25
.\powershell\pwdgen.ps1 -n 5         # 5 passwords, length 18
```

## License

MIT License
