function Get-FederatedDirectorySchema {
    <#
    .SYNOPSIS
    Get the schema of a federated directory.

    .DESCRIPTION
    Get the schema of a federated directory.

    .EXAMPLE
    $Schema = Get-FederatedDirectorySchema
    $Schema | Where-Object { $_.Name -eq 'User' } | Select-Object -ExpandProperty Attributes | Format-Table
    $Schema | Where-Object { $_.Name -eq 'EnterpriseUser' } | Select-Object -ExpandProperty Attributes | Format-Table
    $Schema | Where-Object { $_.Name -eq 'FederatedDirectoryUser' } | Select-Object -ExpandProperty Attributes | Format-Table

    .NOTES
    General notes
    #>
    [alias('Get-FDSchema')]
    [cmdletbinding()]
    param()

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