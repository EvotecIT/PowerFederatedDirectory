function Get-FederatedDirectoryUser {
    [alias('Get-FDUser')]
    [cmdletbinding()]
    param(
        [System.Collections.IDictionary] $Authorization,
        [int] $MaxResults,
        [int] $StartIndex = 1,
        [int] $Count = 50,
        [string] $Filter,
        [ValidateSet(
            'id',
            'externalId',
            'userName',
            'name.givenName',
            'name.familyName',
            'displayName',
            'nickName',
            'profileUrl',
            'title',
            'userType',
            'emails',
            'phoneNumbers',
            'addresses',
            'preferredLanguage',
            'locale',
            'timezone',
            'active',
            'groups',
            'roles',
            'meta',
            'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:organization',
            'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:employeeNumber',
            'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:costCenter',
            'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:division',
            'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:department',
            'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:manager',
            'urn:ietf:params:scim:schemas:extension:fd:2.0:User:description',
            'urn:ietf:params:scim:schemas:extension:fd:2.0:User:directoryId',
            'urn:ietf:params:scim:schemas:extension:fd:2.0:User:companyId',
            'urn:ietf:params:scim:schemas:extension:fd:2.0:User:companyLogos'
        )][string] $SortBy,
        [ValidateSet('ascending', 'descending')][string] $SortOrder,
        [Alias('Property')]
        [ValidateSet(
            'id',
            'externalId',
            'userName',
            'name.givenName',
            'name.familyName',
            'displayName',
            'nickName',
            'profileUrl',
            'title',
            'userType',
            'emails',
            'phoneNumbers',
            'addresses',
            'preferredLanguage',
            'locale',
            'timezone',
            'active',
            'groups',
            'roles',
            'meta',
            'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:organization',
            'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:employeeNumber',
            'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:costCenter',
            'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:division',
            'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:department',
            'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:manager',
            'urn:ietf:params:scim:schemas:extension:fd:2.0:User:description',
            'urn:ietf:params:scim:schemas:extension:fd:2.0:User:directoryId',
            'urn:ietf:params:scim:schemas:extension:fd:2.0:User:companyId',
            'urn:ietf:params:scim:schemas:extension:fd:2.0:User:companyLogos'
        )]
        [string[]] $Attributes
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
        $BaseUri = 'https://api.federated.directory/v2/Users/'
        # Lets build up query
        $QueryParameter = [ordered] @{
            count      = if ($Count) { $Count } else { $null }
            startIndex = if ($StartIndex) { $StartIndex } else { $null }
            filter     = $filter
            sortBy     = $SortBy
            sortOrder  = $SortOrder
            attributes = $Attributes -join ","
        }
        # lets remove empty values to remove whatever user hasn't requested
        Remove-EmptyValue -Hashtable $QueryParameter

        # Lets build our url
        $Uri = Join-UriQuery -BaseUri $BaseUri -QueryParameter $QueryParameter
        Write-Verbose -Message "Get-FederatedDirectoryUser - Using query: $Uri"

        $Headers = @{
            'Content-Type'  = 'application/json'
            'Authorization' = $Authorization.Authorization
        }
        Try {
            $BatchObjects = Invoke-RestMethod -Method Get -Uri $Uri -Headers $Headers -ErrorAction Stop #{id}?attributes={attributes}'
        } catch {
            $ErrorDetails = $_.ErrorDetails.Message | ConvertFrom-Json -ErrorAction SilentlyContinue
            Write-Warning -Message "Get-FederatedDirectoryUser - Error $($_.Exception.Message), $($ErrorDetails.Detail)"
            return
        }
        if ($BatchObjects.Resources) {
            Write-Verbose -Message "Get-FederatedDirectoryUser - Got $($BatchObjects.Resources.Count) users (StartIndex: $StartIndex, Count: $Count). Starting to process them."

            if ($BatchObjects.Resources.Count -ge $MaxResults) {
                # return users if amount of users available is more than we wanted
                $BatchObjects.Resources | Select-Object -First $MaxResults
                $LimitReached = $true
            } else {
                # return all users that were given in a batch
                $BatchObjects.Resources
            }
        } else {
            Write-Verbose "Get-FederatedDirectoryUser - No users found"
            return
        }
        if (-not $Count -and -not $StartIndex) {
            # paging is disabled, we don't do anything
        } elseif (-not $LimitReached -and $BatchObjects.TotalResults -gt $BatchObjects.StartIndex + $Count) {
            # lets get more users because there's more to get and user wanted more
            $MaxResults = $MaxResults - $BatchObjects.Resources.Count
            Write-Verbose "Get-FederatedDirectoryUser - Processing more pages (StartIndex: $StartIndex, Count: $Count)."
            $getFederatedDirectoryUserSplat = @{
                Authorization = $Authorization
                StartIndex    = $($BatchObjects.StartIndex + $Count)
                Count         = $Count
                MaxResults    = $MaxResults
                Filter        = $Filter
                SortBy        = $SortBy
                SortOrder     = $SortOrder
                Attributes    = $Attributes -join ","
            }
            Remove-EmptyValue -Hashtable $getFederatedDirectoryUserSplat
            Get-FederatedDirectoryUser @getFederatedDirectoryUserSplat
        }
    } else {
        Write-Warning -Message 'No authorization found. Please make sure to use Connect-FederatedDirectory first.'
    }
}