param(
    [string]$Path = ".\listdsd.txt",

    [string[]]$IDs
)

# Build regex pattern from supplied IDs
$idPattern = ($IDs | ForEach-Object {[regex]::Escape($_)}) -join "|"
$searchRegex = "(?m)^\s*($idPattern)\s+ALTER\b"

$content = Get-Content -Path $Path -Raw

# Split into LISTDSD records
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
        [pscustomobject]@{
            DatasetInfo = $infoMatch.Value
            AccessList  = $aclText
        }
    }
}

$results | ForEach-Object {
    $_.DatasetInfo
    $_.AccessList
    ""
}
