# pwdgen - Human-Readable Secure Password Generator

A secure CSPRNG generator that stops treating humans like machines. It creates highly secure passwords using a narrowed-down character set to avoid visual ambiguity, formatted into readable groups with guaranteed complexity requirements.

## Why this exists?
Most random generators create strings that are impossible for humans to read or re-type without errors. This tool solves that by:
- Eliminating visually similar characters (like `1, l, I` or `0, O`).
- Grouping characters into readable segments.
- Guaranteeing complexity requirements are met in every single pass.

## Implementations

### HTML/JS Version
A standalone web interface with 16 predefined, high-contrast visual styles.
- **Parameters**: 
  - `length`: Main body length (default: 12, min: 6).
  - `style`: Theme selection (1 to 16).
- **Usage**: `index.html?length=18&style=14`

### Python Version
A lightweight CLI tool for backend or terminal use.
- **Usage**: `python script.py [length]`
- **Requirements**: Python 3.6+ (uses `secrets` module for CSPRNG).

## Security Logic
Both versions use Cryptographically Secure Pseudo-Random Number Generators (CSPRNG). The output structure is:
`[Main Body] + [Suffix]`
- **Main Body**: Grouped by 6 characters, using a human-friendly character set.
- **Suffix**: A mandatory `-XXNN` format (1 lowercase, 1 uppercase, 2 digits) ensuring complexity validation is always passed.

## Character Set
To avoid errors during manual transcription, the following characters are used:
- **Lower**: `abcdefghjkmnprstuwxyz`
- **Higher**: `ACDEFGHJKLMNPQRTUVWXYZ`
- **Digits**: `123456789`

## License
MIT License
