Param (
    [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
    [int] $Records
)

if ($Records -eq 0)
{
    $Records = 100
}

$products = @('Bronze','Silver','Gold')

$forenames = @('Liam','Noah','Oliver','Elijah','William','James','Benjamin','Lucas','Henry','Alexander',
               'Olivia','Emma','Ava','Charlotte','Sophia','Amelia','Isabella','Mia','Evelyn','Harper')

$surnames = @('Smith','Johnson','Williams','Brown','Jones','Garcia','Miller','Davis','Rodriguez')

$postcodesDataSet = "BH postcodes.csv"

if (".\$($postcodesDataSet)") {
    $postcodes = Import-Csv -Delimiter "," -Path ".\$($postcodesDataSet)" | ForEach-Object {     
      New-Object PSObject -prop @{
        Postcode = $_.'Postcode';
        District = $_.'District';
      }
    }
}

$Output = for (($record = 0); $record -lt $Records; $record++)
{
    $randPostcode = Get-Random $postcodes.Count
    $days = Get-Random -Maximum 30 -Minimum 1
    $coverDate = (Get-date).AddDays($days)

    New-Object -TypeName PSObject -Property @{
        product = Get-Random $products
        policyHolder = (Get-Random $forenames) + " " + (Get-Random $surnames)
        postcode = $postcodes[$randPostcode].Postcode
        numPeople = Get-Random -Maximum 8 -Minimum 1
        coverDate = Get-date $coverDate -Format "dd/MM/yyyy"
    } | Select-Object product,policyHolder,numPeople,postcode,coverDate
}
$Output | Export-Csv -Path ".\testData.csv" -NoTypeInformation -Delimiter ","