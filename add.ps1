param(
  [Parameter(Mandatory)][string]$Title,
  [Parameter(Mandatory)][string]$Topic,
  [Parameter(Mandatory)][ValidateSet("Easy","Medium","Hard")][string]$Difficulty,
  [string]$Number = "-",
  [string]$Approach = "Add approach, O(?) time / O(?) space"
)

$words = ($Title -replace '[^a-zA-Z0-9 ]','') -split ' ' | Where-Object { $_ }
$file  = ($words | ForEach-Object { $_.Substring(0,1).ToUpper() + $_.Substring(1) }) -join ''
$date  = Get-Date -Format "yyyy-MM-dd"
$utf8  = New-Object System.Text.UTF8Encoding($false)

$icon = switch ($Difficulty) {
  "Easy"   { [char]::ConvertFromUtf32(0x1F7E2) }
  "Medium" { [char]::ConvertFromUtf32(0x1F7E1) }
  "Hard"   { [char]::ConvertFromUtf32(0x1F534) }
}
$done = [char]::ConvertFromUtf32(0x2705)

# Topic README: insert after the last table row
$path  = "$Topic/README.md"
$lines = [System.Collections.Generic.List[string]](Get-Content $path -Encoding UTF8)
$last  = 0
for ($i = 0; $i -lt $lines.Count; $i++) { if ($lines[$i].StartsWith("|")) { $last = $i } }
$row = "| $Number | [$Title]($file.java) | $icon $Difficulty | [Solution]($file.java) | $Approach | $done Solved | |"
$lines.Insert($last + 1, $row)
[System.IO.File]::WriteAllText((Join-Path (Get-Location) $path), ($lines -join "`n") + "`n", $utf8)

# Main README: append a row to the bottom table
Add-Content README.md "| $Number | $Title | $Topic | $Difficulty | [Java]($Topic/$file.java) | $date |" -Encoding UTF8

git add .
git commit -m $Title
git push
