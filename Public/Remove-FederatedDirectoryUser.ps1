function Remove-FederatedDirectoryUser {
    [alias('Remove-FDUser')]
    param(
        [System.Collections.IDictionary] $Authorization,
        [string] $Id,
        [parameter()][string] $DirectoryID,
        [parameter()][string] $UserName
    )

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
    if ($Authorization) {
        if ($Id) {

        } else {
            return
        }
        Try {
            $invokeRestMethodSplat = [ordered] @{
                Method      = 'DELETE'
                Uri         = "https://api.federated.directory/v2/Users/$Id"
                Headers     = [ordered]  @{
                    'Content-Type'  = 'application/json'
                    'Authorization' = $Authorization.Authorization
                    'Cache-Control' = 'no-cache'
                    # 'directoryId'   = $DirectoryID
                }
                ErrorAction = 'Stop'
            }
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
                return
            }
        }
    } else {
        Write-Warning -Message 'Remove-FederatedDirectoryUser - No authorization found. Please make sure to use Connect-FederatedDirectory first.'
    }
}