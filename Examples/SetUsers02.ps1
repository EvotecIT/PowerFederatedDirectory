Import-Module .\PowerFederatedDirectory.psd1 -Force

$Token = Get-Content -Raw -LiteralPath 'C:\Support\Important\Password-FederatedDirectory.txt'

Connect-FederatedDirectory -Token $Token -Suppress

#Set-FederatedDirectoryUser -Id '69c6b3c0-34dd-11ed-a621-4b6b819dffa2' -DisplayName 'New name' -FamilyName 'New namme' -EmailAddressHome 'test@evo.pl' -PhoneNumberHome '502469000' -Verbose -Custom01 'test123' -Action Update

Invoke-FederatedDirectory -Operations @(
    Set-FederatedDirectoryUser -Id '53f53e40-3a96-11ed-9bef-61d3413a9179' -Action Overwrite -StreetAddress "Test me" -Country 'test' -Verbose -UserName 'test@evotec.pl' -DisplayName 'Test' -BulkProcessing
    Set-FederatedDirectoryUser -Id '53f53e40-3a96-11ed-9bef-61d3413a9179' -Action Overwrite -StreetAddress "Test me" -Country 'test' -Verbose -UserName 'test@evotec.pl' -DisplayName 'Test' -BulkProcessing
) -Verbose


(Set-FederatedDirectoryUser -Id '53f53e40-3a96-11ed-9bef-61d3413a9179' -Action Overwrite -StreetAddress "Test me" -Country 'test' -Verbose -UserName 'test@evotec.pl' -DisplayName 'Test' -BulkProcessing).data.addresses