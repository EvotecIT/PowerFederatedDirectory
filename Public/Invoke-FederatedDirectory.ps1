function Invoke-FederatedDirectory {
    <#
    .SYNOPSIS
    Provides a way to invoke multiple operations on FederatedDirectory in a single request (bulk).

    .DESCRIPTION
    Provides a way to invoke multiple operations on FederatedDirectory in a single request (bulk).
    While the official limit is 1000 operations in a single request, it's actually much lower due to payload size

    .PARAMETER Authorization
    The authorization identity to use for the request from Connect-FederatedDirectory. If not specified, the default authorization identity will be used.

    .PARAMETER Operations
    Operations to perform as part of bulk request

    .PARAMETER Size
    Batch size of operations to send in a single request. Default is 100.

    .PARAMETER ReturnHashtable
    Return results as a hashtable for quick matching BulkId

    .PARAMETER ReturnNative
    Return results the same way REST API returns it

    .EXAMPLE
    Connect-FederatedDirectory -Token $Token -Suppress

    $Operations = for ($i = 1; $i -le 1; $i++) {
        Add-FederatedDirectoryUser -UserName "TestNewwwww$i@test.pl" -DisplayName "TestUserNew$i" -ManagerDisplayName 'TestUser' -FamilyName 'Kłys' -GivenName 'Przemysłąw' -BulkProcessing
        #Set-FederatedDirectoryUser -Id '69c6b3c0-34dd-11ed-a621-4b6b819dffa2' -DisplayName 'New name' -FamilyName 'New namme' -EmailAddressHome 'test@evo.pl' -PhoneNumberHome '502469000' -Custom01 'test123' -Action Update -BulkProcessing
        Set-FederatedDirectoryUser -Id '0c50c6f0-3428-11ed-98e2-11027423d1f1' -DisplayName 'New name' -GivenName "Test" -EmailAddressHome 'test@evo.pl' -PhoneNumberHome '502469000' -Custom01 'test123' -UserName 'TestMe@verymuch.pl' -Action Overwrite -StreetAddress "Test me" -BulkProcessing
        Set-FederatedDirectoryUser -Id '69c6b3c0-34dd-11ed-a621-4b6b819dffa2' -DisplayName 'New name' -GivenName "Test" -EmailAddressHome 'test@evo.pl' -PhoneNumberHome '502469000' -Custom01 'test123' -UserName 'TestMe@verymuch.pl' -Action Overwrite -StreetAddress "Test me" -BulkProcessing
    }
    $Response = Invoke-FederatedDirectory -Operations $Operations -ReturnHashtable
    $Response | Format-Table

    .NOTES
    General notes
    #>
    [cmdletbinding(SupportsShouldProcess)]
    param(
        [System.Collections.IDictionary] $Authorization,
        [Array] $Operations,
        [int] $Size = 100,
        [switch] $ReturnHashtable,
        [switch] $ReturnNative
    )
    $TranslateMethod = @{
        'PUT'    = 'Update'
        'POST'   = 'Add'
        'DELETE' = 'Remove'
    }
    $TranslateStatus = @{
        '200' = $true
        '201' = $true
        '204' = $true
        '400' = $false
        '401' = $false
        '403' = $false
        '404' = $false
        '409' = $false
        '500' = $false
        '503' = $false
    }

    if (-not $Authorization) {
        if ($Script:AuthorizationCacheFD) {
            $Authorization = $Script:AuthorizationCacheFD[0]
        }
        if (-not $Authorization) {
            if ($PSBoundParameters.ErrorAction -eq 'Stop') {
                throw "No authorization found. Please run 'Connect-FederatedDirectory' first."
            } else {
                Write-Warning -Message "Invoke-FederatedDirectory - No authorization found. Please run 'Connect-FederatedDirectory' first."
                return
            }
        }
    }
    if ($Authorization) {
        $SplitOperations = Split-Array -Objects $Operations -Size $Size
        foreach ($O in $SplitOperations) {
            $Body = [ordered] @{
                schemas    = @('urn:ietf:params:scim:api:messages:2.0:BulkRequest')
                Operations = $O
            }
            Remove-EmptyValue -Hashtable $Body -Recursive -Rerun 2
            Try {
                $invokeRestMethodSplat = [ordered] @{
                    Method      = 'POST'
                    Uri         = 'https://api.federated.directory/v2/Bulk'
                    Headers     = [ordered]  @{
                        'Content-Type'  = 'application/json; charset=utf-8'
                        'Authorization' = $Authorization.Authorization
                        'Cache-Control' = 'no-cache'
                    }
                    Body        = $Body | ConvertTo-Json -Depth 10
                    ErrorAction = 'Stop'
                    ContentType = 'application/json; charset=utf-8'
                }
                if ($DirectoryID) {
                    $invokeRestMethodSplat['Headers']['directoryId'] = $DirectoryID
                }
                # for troubleshooting
                if ($VerbosePreference -eq 'Continue') {
                    $Body | ConvertTo-Json -Depth 10 | Write-Verbose
                }
                if ($PSCmdlet.ShouldProcess("Federated Directory", "Bulk sending $($O.Count) operations")) {
                    $ReturnData = Invoke-RestMethod @invokeRestMethodSplat -Verbose:$false
                    # don't return data as we trust it's been created
                    if (-not $Suppress) {
                        if ($ReturnNative) {
                            $ReturnData.Operations
                        } elseif ($ReturnHashtable) {
                            $ResultsPrepared = [ordered] @{}
                            foreach ($Operation in $ReturnData.Operations) {
                                $ResultsPrepared[$Operation.bulkid] = [PSCustomObject] @{
                                    BulkID         = $Operation.bulkid
                                    Method         = $TranslateMethod[$Operation.method]
                                    Status         = $TranslateStatus[$Operation.status.ToString()]
                                    StatusResponse = $Operation.status
                                    Detail         = $Operation.response.detail
                                    ScimType       = $Operation.response.scimType
                                    Location       = $Operation.location

                                }
                            }
                            $ResultsPrepared
                        } else {
                            foreach ($Operation in $ReturnData.Operations) {
                                [PSCustomObject] @{
                                    BulkID         = $Operation.bulkid
                                    Method         = $TranslateMethod[$Operation.method]
                                    Status         = $TranslateStatus[$Operation.status.ToString()]
                                    StatusResponse = $Operation.status
                                    Detail         = $Operation.response.detail
                                    ScimType       = $Operation.response.scimType
                                    Location       = $Operation.location
                                }
                            }
                        }
                    }
                }
                # # for troubleshooting
                # if ($VerbosePreference -eq 'Continue') {
                #     $invokeRestMethodSplat.Remove('body')
                #     $invokeRestMethodSplat | ConvertTo-Json -Depth 10 | Write-Verbose
                # }
            } catch {
                if ($PSBoundParameters.ErrorAction -eq 'Stop') {
                    throw
                } else {
                    $ErrorDetails = $_.ErrorDetails.Message | ConvertFrom-Json -ErrorAction SilentlyContinue
                    Write-Warning -Message "Invoke-FederatedDirectory - Error $($_.Exception.Message), $($ErrorDetails.Detail)"
                }
            }
        }
    } else {
        Write-Warning -Message 'Invoke-FederatedDirectory - No authorization found. Please make sure to use Connect-FederatedDirectory first.'
    }
}