param(
    [Parameter(Mandatory=$true)]
    [string]$InPath,

    [string]$OutPath,

    [Parameter(Mandatory=$true)]
    [string[]]$IDs
)

# Build regex for requested IDs
$idPattern = ($IDs | ForEach-Object { [regex]::Escape($_) }) -join "|"
$searchRegex = "(?m)^\s*($idPattern)\s+ALTER\b"

$content = Get-Content -Path $InPath -Raw

# Split LISTDSD records
$records = [regex]::Split($content, '(?m)^(?=Processing:\s+)') |
    Where-Object { $_ -match '(?m)^Processing:\s+' }

$results = foreach ($record in $records) {

    $infoMatch = [regex]::Match($record, '(?m)^INFORMATION FOR DATASET .*$')
    if (-not $infoMatch.Success) { continue }

    $aclMatch = [regex]::Match(
        $record,
        '(?ms)^\s+ID\s+ACCESS.*?(?:\r?\n){2,}'
    )
    if (-not $aclMatch.Success) { continue }

    $aclText = $aclMatch.Value.TrimEnd()

    if ($aclText -match $searchRegex) {
        $infoMatch.Value
        $aclText
        ""
    }
}

# Output handling
if ($OutPath) {
    $output | Set-Content -Path $OutPath
} else {
    $output
}
