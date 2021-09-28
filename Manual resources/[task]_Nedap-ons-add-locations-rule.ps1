$Path = $NedapOnsLocationMappingPath

$afasLocation = $afasLocationId
$nedapLocations = $nedapLocationIds | ConvertFrom-Json

foreach($n in $nedapLocations)
{
    $nedapLocationString = $nedapLocationString + $n.Id.ToString() + ","
}

$nedapLocationString = $nedapLocationString.Substring(0,$nedapLocationString.Length-1)

$rule = [PSCustomObject]@{
    "Department.ExternalId" = $afasLocation;
    "NedapLocationIds"= $nedapLocationString;
}

$rule | ConvertTo-Csv -NoTypeInformation -Delimiter ";" | % { $_ -replace '"', ""}  | Select-Object -Skip 1  | Add-Content $Path -Encoding UTF8

