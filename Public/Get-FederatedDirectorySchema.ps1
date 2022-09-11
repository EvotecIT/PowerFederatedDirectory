function Get-FederatedDirectorySchema {
    [alias('Get-FDSchema')]
    [cmdletbinding()]
    param(   )

    $BaseUri = "https://api.federated.directory/v2/Schemas"

    Write-Verbose -Message "Get-FederatedDirectorySchema - Using query: $BaseUri"

    $Headers = @{
        'Content-Type' = 'application/json'
    }

    Try {
        $BatchObjects = Invoke-RestMethod -Method Get -Uri $BaseUri -Headers $Headers -ErrorAction Stop
        $BatchObjects.Resources
    } catch {
        if ($PSBoundParameters.ErrorAction -eq 'Stop') {
            throw
        } else {
            $ErrorDetails = $_.ErrorDetails.Message | ConvertFrom-Json -ErrorAction SilentlyContinue
            Write-Warning -Message "Get-FederatedDirectorySchema - Error $($_.Exception.Message), $($ErrorDetails.Detail)"
        }
    }
}