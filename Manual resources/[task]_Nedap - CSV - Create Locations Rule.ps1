$afasLocationId = $form.afasLocations.Id
$nedapLocationIds = $form.multiselect.toJsonString

$Path = $NedapOnsLocationMappingPath

$afasLocation = $afasLocationId
$nedapLocations = $nedapLocationIds | ConvertFrom-Json

foreach ($n in $nedapLocations) {
    $nedapLocationString = $nedapLocationString + $n.Id.ToString() + ","
}

$nedapLocationString = $nedapLocationString.Substring(0, $nedapLocationString.Length - 1)

$rule = [PSCustomObject]@{
    "Department.ExternalId" = $afasLocation
    "NedapLocationIds"      = $nedapLocationString
}

$rule | ConvertTo-Csv -NoTypeInformation -Delimiter ";" | ForEach-Object { $_ -replace '"', "" }  | Select-Object -Skip 1  | Add-Content $Path -Encoding UTF8

$Log = @{
    Action            = "Undefined" # optional. ENUM (undefined = default) 
    System            = "NedapOns" # optional (free format text) 
    Message           = "Added location rule for department [$afasLocation] to Nedap Location id(s) [$nedapLocationString] to mapping file [$path]" # required (free format text) 
    IsError           = $false # optional. Elastic reporting purposes only. (default = $false. $true = Executed action returned an error) 
    TargetDisplayName = "$path" # optional (free format text) 
    TargetIdentifier  = "" # optional (free format text) 
}
#send result back  
Write-Information -Tags "Audit" -MessageData $log 
