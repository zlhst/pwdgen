<#
.SYNOPSIS
    Human-readable secure password generator.
.EXAMPLE
    .\pwdgen.ps1
    .\pwdgen.ps1 25
    .\pwdgen.ps1 25 -n 5
#>
param(
    [Parameter(Position = 0)]
    [string]$Length = "18",

    [Alias("n")]
    [string]$Count = "1"
)

$WISHLIST_LOWER  = "abcdefghjkmnprstuwxyz"
$WISHLIST_UPPER  = "ACDEFGHJKLMNPQRTUVWXYZ"
$WISHLIST_DIGITS = "123456789"
$WISHLIST_FULL   = $WISHLIST_LOWER + $WISHLIST_UPPER + $WISHLIST_DIGITS

$DEFAULT_LENGTH = 18
$MIN_LENGTH     = 8
$MAX_LENGTH     = 1024
$DEFAULT_COUNT  = 1
$MAX_COUNT      = 1000
$GROUP_SIZE     = 6
$SUFFIX_LENGTH  = 5 # '-' + 1 lower + 1 upper + 2 digits

function Parse-Length([string]$RawValue) {
    $parsed = 0
    if (-not [int]::TryParse($RawValue, [ref]$parsed)) {
        return $DEFAULT_LENGTH
    }
    if ($parsed -lt $MIN_LENGTH) {
        return $DEFAULT_LENGTH
    }
    if ($parsed -gt $MAX_LENGTH) {
        return $MAX_LENGTH
    }
    return $parsed
}

function Parse-Count([string]$RawValue) {
    $parsed = 0
    if (-not [int]::TryParse($RawValue, [ref]$parsed)) {
        return $DEFAULT_COUNT
    }
    if ($parsed -lt 1) {
        return $DEFAULT_COUNT
    }
    if ($parsed -gt $MAX_COUNT) {
        return $MAX_COUNT
    }
    return $parsed
}

$rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()

function Get-RandomChar([string]$Charset) {
    $len = [uint64]$Charset.Length
    $limit = [uint64]([Math]::Floor(4294967296.0 / $len)) * $len
    $bytes = New-Object byte[] 4
    do {
        $rng.GetBytes($bytes)
        $value = [uint64][BitConverter]::ToUInt32($bytes, 0)
    } while ($value -ge $limit)
    return $Charset[[int]($value % $len)]
}

function New-Password([int]$TotalLength) {
    $mainLength = $TotalLength - $SUFFIX_LENGTH
    $sb = New-Object System.Text.StringBuilder($TotalLength)

    for ($i = 0; $i -lt $mainLength; $i++) {
        if ((($i + 1) % ($GROUP_SIZE + 1) -eq 0) -and ($i -ne $mainLength - 1)) {
            [void]$sb.Append("-")
        } else {
            [void]$sb.Append((Get-RandomChar $WISHLIST_FULL))
        }
    }

    [void]$sb.Append("-")
    [void]$sb.Append((Get-RandomChar $WISHLIST_LOWER))
    [void]$sb.Append((Get-RandomChar $WISHLIST_UPPER))
    [void]$sb.Append((Get-RandomChar $WISHLIST_DIGITS))
    [void]$sb.Append((Get-RandomChar $WISHLIST_DIGITS))

    return $sb.ToString()
}

try {
    $resolvedLength = Parse-Length $Length
    $resolvedCount = Parse-Count $Count

    for ($i = 0; $i -lt $resolvedCount; $i++) {
        Write-Output (New-Password $resolvedLength)
    }
} finally {
    $rng.Dispose()
}
