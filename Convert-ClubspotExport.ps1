param(
    [Parameter(Mandatory=$true)][string]$importfile,
    [Parameter()][switch]$skipperonly,
    [Parameter()][switch]$unique
)
$entries = Get-Content -Path $importfile | Select-Object -Skip 1 | ConvertFrom-Csv
$persons = @()
foreach ($entry in $entries) {
    $entry.Participants = $entry.Participants.Replace("<br><div class='table-row-tag grey' style='display:inline-block;'>Incomplete crew</div>", "")
    $entry.Participants = $entry.Participants.Replace("<br>", ",")
    $entry.Participants = $entry.Participants.Replace("  ", " ")
    $entry.Participants = $entry.Participants.Replace("- ", "-")
    $entry.emails = $entry.emails.Replace(";", ",")
    $entry.emails = $entry.emails.Replace(", ", ",")
    $entry.Participants = $entry.Participants.Replace("<br>", ",")
    $entry.emails = $entry.emails.Replace(";", ",")
    $entry.emails = $entry.emails.Replace(", ", ",")
    $entry.emails = $entry.emails.Replace(" ", "")
    $participants = $entry.Participants.Split(',')
    $emails = $entry.emails.Split(',')
    $i = 0
    foreach ($participant in $participants) {
        if ($emails.Count -gt $i) {
            if ($emails[$i] -like '*@*') {
                $names = $participant.Split(" ")
                if ($names.Count -gt 0) {
                    $lastname = $names[$names.Count - 1]
                }
                # $names[0] + "," + $lastname + "," + $emails[$i]
                $person = New-Object PSObject
                $person | Add-member -NotePropertyName "firstName" -NotePropertyValue $names[0]
                $person | Add-member -NotePropertyName "lastName" -NotePropertyValue $lastname
                $person | Add-member -NotePropertyName "email" -NotePropertyValue $emails[$i]
                $persons += $person
            }
            if ($skipperonly) {
                break
            }
            $i++
        } else {
            break
        }
    }
}
if ($unique) {
    $persons = $persons | Sort email -Unique 
}
$persons | ConvertTo-Csv -NoTypeInformation