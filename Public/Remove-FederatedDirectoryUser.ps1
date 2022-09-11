function Remove-FederatedDirectoryUser {
    <#
    .SYNOPSIS
    Remove a user from a federated directory.

    .DESCRIPTION
    Remove a user from a federated directory.

    .PARAMETER Authorization
    The authorization identity to use for the request from Connect-FederatedDirectory. If not specified, the default authorization identity will be used.

    .PARAMETER User
    The user to remove from the federated directory.

    .PARAMETER Id
    The id of the user to remove from the federated directory.

    .PARAMETER UserName
    The user name of the user to remove from the federated directory.

    .PARAMETER DirectoryID
    The id of the directory to remove the user from. If not specified, the default directory will be used.

    .EXAMPLE
     # remove specific user id
    Remove-FederatedDirectoryUser -Id '171a8cd0-2382-11ed-9dd1-b13400d703b6' -Verbose

    .EXAMPLE
    # get all ther users that contain name test user and delete them
    Remove-FederatedDirectoryUser -UserName 'testuser' -Verbose

    .EXAMPLE
     # get all ther users that contain name test user and delete them
    Get-FederatedDirectoryUser -UserName 'testuser' | Remove-FederatedDirectoryUser -Verbose

    .NOTES
    General notes
    #>
    [alias('Remove-FDUser')]
    [CmdletBinding(DefaultParameterSetName = 'Id')]
    param(
        [System.Collections.IDictionary] $Authorization,
        [parameter(Position = 0, ValueFromPipeline, Mandatory, ParameterSetName = 'User')][PSCustomObject[]] $User,
        [parameter(Mandatory, ParameterSetName = 'Id')][string[]] $Id,
        [parameter(Mandatory, ParameterSetName = 'UserName')][string[]] $UserName,
        [parameter()][string] $DirectoryID
    )
    Begin {
        if (-not $Authorization) {
            if ($Script:AuthorizationCacheFD) {
                $Authorization = $Script:AuthorizationCacheFD[0]
            }
            if (-not $Authorization) {
                if ($PSBoundParameters.ErrorAction -eq 'Stop') {
                    throw "No authorization found. Please run 'Connect-FederatedDirectory' first."
                } else {
                    Write-Warning -Message "Get-FederatedDirectory - No authorization found. Please run 'Connect-FederatedDirectory' first."
                    return
                }
            }
        }
    }
    Process {
        if ($Authorization) {
            if ($Id) {
                $RemoveID = $Id
            } elseif ($User) {
                $RemoveID = $User.Id
            } elseif ($UserName) {
                $RemoveID = Foreach ($U in $UserName) {
                    (Get-FederatedDirectoryUser -Authorization $Authorization -UserName $U).Id
                }
            } else {
                return
            }
            foreach ($I in $RemoveID) {
                Try {
                    $invokeRestMethodSplat = [ordered] @{
                        Method      = 'DELETE'
                        Uri         = "https://api.federated.directory/v2/Users/$I"
                        Headers     = [ordered]  @{
                            'Content-Type'  = 'application/json'
                            'Authorization' = $Authorization.Authorization
                            'Cache-Control' = 'no-cache'
                            'directoryId'   = $DirectoryID
                        }
                        ErrorAction = 'Stop'
                    }
                    Remove-EmptyValue -Hashtable $invokeRestMethodSplat

                    if ($VerbosePreference -eq 'Continue') {
                        $invokeRestMethodSplat | ConvertTo-Json -Depth 10 | Write-Verbose
                    }

                    $ReturnData = Invoke-RestMethod @invokeRestMethodSplat
                    $ReturnData
                } catch {
                    $ErrorDetails = $_.ErrorDetails.Message | ConvertFrom-Json -ErrorAction SilentlyContinue
                    if ($ErrorDetails.Detail -like "*not found*") {
                        Write-Warning -Message "Remove-FederatedDirectoryUser - $($ErrorDetails.Detail)."
                    } else {
                        Write-Warning -Message "Remove-FederatedDirectoryUser - Error $($_.Exception.Message), $($ErrorDetails.Detail)"
                    }
                }
            }
        } else {
            Write-Warning -Message 'Remove-FederatedDirectoryUser - No authorization found. Please make sure to use Connect-FederatedDirectory first.'
        }
    }
}