function Get-FederatedDirectoryUser {
    [alias('Get-FDUser')]
    [cmdletbinding()]
    param(
        [System.Collections.IDictionary] $Authorization,
        [string] $Id,
        [Alias('SearchUserName')][string] $UserName,
        [string] $DirectoryID,
        [int] $MaxResults,
        [int] $StartIndex = 1,
        [int] $Count = 50,
        [string] $Filter,
        [ValidateSet(
            'id',
            'externalId',
            'userName',
            'givenName',
            'familyName',
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
            'organization',
            'employeeNumber',
            'costCenter',
            'division',
            'department',
            'manager',
            'description',
            'directoryId',
            'companyId',
            'companyLogos',
            'custom01',
            'custom02',
            'custom03'
        )]
        [string] $SortBy,
        [ValidateSet('ascending', 'descending')][string] $SortOrder,
        [Alias('Property')]
        [ValidateSet(
            'id',
            'externalId',
            'userName',
            'givenName',
            'familyName',
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
            'organization',
            'employeeNumber',
            'costCenter',
            'division',
            'department',
            'manager',
            'description',
            'directoryId',
            'companyId',
            'companyLogos',
            'custom01',
            'custom02',
            'custom03'
        )]
        [string[]] $Attributes,
        [switch] $Native
    )

    $ConvertAttributes = @{
        'id'                = 'id'
        'externalId'        = 'externalId'
        'userName'          = 'userName'
        'givenName'         = 'name.givenName'
        'familyName'        = 'name.familyName'
        'displayName'       = 'displayName'
        'nickName'          = 'nickName'
        'profileUrl'        = 'profileUrl'
        'title'             = 'title'
        'userType'          = 'userType'
        'emails'            = 'emails'
        'phoneNumbers'      = 'phoneNumbers'
        'addresses'         = 'addresses'
        'preferredLanguage' = 'preferredLanguage'
        'locale'            = 'locale'
        'timezone'          = 'timezone'
        'active'            = 'active'
        'groups'            = 'groups'
        'roles'             = 'roles'
        'meta'              = 'meta'
        'organization'      = 'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:organization'
        'employeeNumber'    = 'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:employeeNumber'
        'costCenter'        = 'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:costCenter'
        'division'          = 'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:division'
        'department'        = 'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:department'
        'manager'           = 'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:manager'
        'description'       = 'urn:ietf:params:scim:schemas:extension:fd:2.0:User:description'
        'directoryId'       = 'urn:ietf:params:scim:schemas:extension:fd:2.0:User:directoryId'
        'companyId'         = 'urn:ietf:params:scim:schemas:extension:fd:2.0:User:companyId'
        'companyLogos'      = 'urn:ietf:params:scim:schemas:extension:fd:2.0:User:companyLogos'
        'custom01'          = 'urn:ietf:params:scim:schemas:extension:fd:2.0:User:custom01'
        'custom02'          = 'urn:ietf:params:scim:schemas:extension:fd:2.0:User:custom02'
        'custom03'          = 'urn:ietf:params:scim:schemas:extension:fd:2.0:User:custom03'
    }

    $AttributesConverted = foreach ($Attribute in $Attributes) {
        if ($ConvertAttributes[$Attribute]) {
            $ConvertAttributes[$Attribute]
        }
    }
    if ($SortBy) {
        $SortByConverted = $ConvertAttributes[$SortBy]
    }

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
        if ($ID) {
            $BaseUri = "https://api.federated.directory/v2/Users/$ID"
        } else {
            $BaseUri = "https://api.federated.directory/v2/Users"
        }
        # Lets build up query
        $QueryParameter = [ordered] @{
            count      = if ($Count) { $Count } else { $null }
            startIndex = if ($StartIndex) { $StartIndex } else { $null }
            filter     = if ($UserName) {
                # keep in mind regardless of used operator it will always revert back to co as per API (weird)
                "userName co $UserName"
            } else {
                $Filter
            }
            sortBy     = $SortByConverted
            sortOrder  = $SortOrder
            attributes = $AttributesConverted -join ","
        }
        # lets remove empty values to remove whatever user hasn't requested
        Remove-EmptyValue -Hashtable $QueryParameter

        # Lets build our url
        $Uri = Join-UriQuery -BaseUri $BaseUri -QueryParameter $QueryParameter
        Write-Verbose -Message "Get-FederatedDirectoryUser - Using query: $Uri"

        $Headers = @{
            'Content-Type'  = 'application/json; charset=utf-8'
            'Authorization' = $Authorization.Authorization
            'directoryID'   = $DirectoryID
        }
        Remove-EmptyValue -Hashtable $Headers
        Try {
            $BatchObjects = Invoke-RestMethod -Method Get -Uri $Uri -Headers $Headers -ErrorAction Stop #{id}?attributes={attributes}'
        } catch {
            if ($PSBoundParameters.ErrorAction -eq 'Stop') {
                throw
            } else {
                $ErrorDetails = $_.ErrorDetails.Message | ConvertFrom-Json -ErrorAction SilentlyContinue
                if ($ErrorDetails.Detail -like '*already exists*directory*') {
                    Write-Warning -Message "Get-FederatedDirectoryUser - $($ErrorDetails.Detail) [UserName: $UserName / ID: $ID]"
                    return
                } else {
                    Write-Warning -Message "Get-FederatedDirectoryUser - Error $($_.Exception.Message), $($ErrorDetails.Detail)"
                    return
                }
            }
        }
        if ($BatchObjects.Resources) {
            Write-Verbose -Message "Get-FederatedDirectoryUser - Got $($BatchObjects.Resources.Count) users (StartIndex: $StartIndex, Count: $Count). Starting to process them."

            if ($MaxResults -gt 0 -and $BatchObjects.Resources.Count -ge $MaxResults) {
                # return users if amount of users available is more than we wanted
                if ($Native) {
                    $BatchObjects.Resources | Select-Object -First $MaxResults
                } else {
                    Convert-FederatedUser -Users ($BatchObjects.Resources | Select-Object -First $MaxResults)
                }
                $LimitReached = $true
            } else {
                # return all users that were given in a batch
                if ($Native) {
                    $BatchObjects.Resources
                } else {
                    Convert-FederatedUser -Users $BatchObjects.Resources
                }
            }
        } elseif ($BatchObjects.Schemas -and $BatchObjects.id) {
            if ($Native) {
                $BatchObjects
            } else {
                Convert-FederatedUser -Users $BatchObjects
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
                Attributes    = $Attributes
                DirectoryID   = $DirectoryID
            }
            Remove-EmptyValue -Hashtable $getFederatedDirectoryUserSplat
            Get-FederatedDirectoryUser @getFederatedDirectoryUserSplat
        }
    } else {
        Write-Warning -Message 'Get-FederatedDirectoryUser - No authorization found. Please make sure to use Connect-FederatedDirectory first.'
    }
}

# $Script:AttributesList = @(
#     'id',
#     'externalId',
#     'userName',
#     'givenName',
#     'familyName',
#     'displayName',
#     'nickName',
#     'profileUrl',
#     'title',
#     'userType',
#     'emails',
#     'phoneNumbers',
#     'addresses',
#     'preferredLanguage',
#     'locale',
#     'timezone',
#     'active',
#     'groups',
#     'roles',
#     'meta',
#     'organization',
#     'employeeNumber',
#     'costCenter',
#     'division',
#     'department',
#     'manager',
#     'description',
#     'directoryId',
#     'companyId',
#     'companyLogos'
#     'custom01',
#     'custom02',
#     'custom03'
# )

# $Script:ScriptBlockAttributes = {
#     param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
#     $Script:AttributesList | Where-Object { $_ -like "*$wordToComplete*" }
# }

# Register-ArgumentCompleter -CommandName Get-FederatedDirectoryUser -ParameterName Attributes -ScriptBlock $Script:ScriptBlockAttributes
# Register-ArgumentCompleter -CommandName Get-FederatedDirectoryUser -ParameterName SortBy -ScriptBlock $Script:ScriptBlockAttributes