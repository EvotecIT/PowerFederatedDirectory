function Set-FederatedDirectoryUser {
    [alias('Set-FDUser')]
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [System.Collections.IDictionary] $Authorization,
        [string] $SearchUserName,
        [string] $Id,
        [string] $ExternalId,
        [parameter()][string] $DirectoryID,
        [parameter()][string] $UserName,
        [Alias('FirstName')] $FamilyName,
        [string] $GivenName,
        [parameter()][string] $DisplayName,
        [string] $NickName,
        [string] $ProfileUrl,
        [string] $EmailAddress,
        [string] $EmailAddressHome,
        [string] $StreetAddress,
        [string] $City,
        [string] $Region,
        [string] $PostalCode,
        [string] $Country,
        [string] $StreetAddressHome,
        [string] $PostalCodeHome,
        [string] $CityHome,
        [string] $RegionHome,
        [string] $CountryHome,
        [string] $PhoneNumberWork,
        [string] $PhoneNumberHome,
        [string] $PhoneNumberMobile,
        [string] $PhotoUrl,
        [string] $ThumbnailUrl,
        [string] $CompanyID,
        #[string] $CompanyLogoUrl,
        #[string] $CompanyThumbnailUrl,
        [string] $PreferredLanguage,
        [string] $Locale,
        [string] $TimeZone,
        [string] $Title,
        [string] $UserType,
        [string] $Password,
        [string] $ManagerID,
        [string] $ManagerUserName,
        [string] $ManagerReference,
        [string] $ManagerDisplayName,
        [bool] $Active,
        #[string] $Organization,
        [string] $Department,
        [string] $EmployeeNumber,
        [string] $CostCenter,
        [string] $Division,
        [string] $Description,
        [ValidateSet('admin', 'user', 'contact')][string] $Role,
        [alias('CustomAttribute01')][string] $Custom01,
        [alias('CustomAttribute02')][string] $Custom02,
        [alias('CustomAttribute03')][string] $Custom03,
        [switch] $Suppress,
        [ValidateSet('Overwrite', 'Update')][string] $Action = 'Update',
        [System.Collections.IDictionary] $ActionPerProperty = @{},
        [switch] $BulkProcessing
    )
    if (-not $Authorization) {
        if ($Script:AuthorizationCacheFD) {
            $Authorization = $Script:AuthorizationCacheFD[0]
        }
        if (-not $Authorization) {
            if ($PSBoundParameters.ErrorAction -eq 'Stop') {
                throw "No authorization found. Please run 'Connect-FederatedDirectory' first."
            } else {
                Write-Warning -Message "Set-FederatedDirectoryUser - No authorization found. Please run 'Connect-FederatedDirectory' first."
                return
            }
        }
    }
    if ($Authorization) {
        if ($Id) {
            $SetID = $Id
        } elseif ($User) {
            $SetID = $User.Id
        } elseif ($SearchUserName) {
            $SetID = Foreach ($U in $SearchUserName) {
                (Get-FederatedDirectoryUser -Authorization $Authorization -UserName $U).Id
            }
        } else {
            Write-Warning -Message "Set-FederatedDirectoryUser - No ID or UserName specified."
            return
        }
        if ($ManagerUserName) {
            $ManagerID = (Get-FederatedDirectoryUser -Authorization $Authorization -UserName $ManagerUserName).Id
        }

        if ($Action -eq 'Update') {
            $TranslatePath = @{
                UserName           = "userName"
                ExternalId         = "externalId"
                FamilyName         = "name.familyName"
                Password           = "password" # not used yet
                # not used yet
                Role               = "roles.value" #  "admin" or "user"
                GivenName          = 'name.givenName'
                DisplayName        = 'displayName'
                NickName           = 'nickName'
                ProfileUrl         = 'profileUrl'
                EmailAddress       = 'emails[type eq "work"].value'
                EmailAddressHome   = 'emails[type eq "home"].value'
                StreetAddress      = 'addresses[type eq "work"].streetAddress'
                City               = 'addresses[type eq "work"].locality'
                Region             = 'addresses[type eq "work"].region'
                PostalCode         = 'addresses[type eq "work"].postalCode'
                Country            = 'addresses[type eq "work"].country'
                StreetAddressHome  = 'addresses[type eq "home"].streetAddress'
                PostalCodeHome     = 'addresses[type eq "home"].postalCode'
                CityHome           = 'addresses[type eq "home"].locality'
                RegionHome         = 'addresses[type eq "home"].region'
                CountryHome        = 'addresses[type eq "home"].country'
                PhoneNumberWork    = 'phoneNumbers[type eq "work"].value'
                PhoneNumberHome    = 'phoneNumbers[type eq "home"].value'
                PhoneNumberMobile  = 'phoneNumbers[type eq "mobile"].value'
                PhotoUrl           = 'photos[type eq "photo"].value'
                ThumbnailUrl       = 'photos[type eq "thumbnail"].value'
                Title              = 'title'
                UserType           = 'userType'
                Active             = 'active'
                TimeZone           = 'timezone'
                Locale             = 'locale'
                PreferredLanguage  = 'preferredLanguage'
                EmployeeNumber     = 'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:employeeNumber'
                CostCenter         = 'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:costCenter'
                Division           = 'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:division'
                Department         = 'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:department'
                Organization       = 'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:organization'
                ManagerID          = 'manager'
                ManagerUserName    = 'manager'
                ManagerDisplayName = 'manager'
                Description        = "urn:ietf:params:scim:schemas:extension:fd:2.0:User:description"
                Custom01           = "urn:ietf:params:scim:schemas:extension:fd:2.0:User:custom01"
                Custom02           = "urn:ietf:params:scim:schemas:extension:fd:2.0:User:custom02"
                Custom03           = "urn:ietf:params:scim:schemas:extension:fd:2.0:User:custom03"
                CompanyID          = "urn:ietf:params:scim:schemas:extension:fd:2.0:User:companyId"
                #CompanyLogoUrl      = 'urn:ietf:params:scim:schemas:extension:fd:2.0:User:companyLogos[type eq "logo"].value'
                #CompanyThumbnailUrl = 'urn:ietf:params:scim:schemas:extension:fd:2.0:User:companyLogos[type eq "thumbnail"].value'
            }

            $Body = [ordered] @{
                schemas    = @(
                    "urn:ietf:params:scim:api:messages:2.0:PatchOp"
                )
                Operations = @(
                    foreach ($Key in $PSBoundParameters.Keys) {
                        if ($Key -in $TranslatePath.Keys) {
                            if ($TranslatePath[$Key]) {
                                $Path = $TranslatePath[$Key]
                            } else {
                                $Path = $Key
                            }
                            if ($PSBoundParameters[$Key]) {
                                if ($ManagerUserName) {
                                    $Value = $ManagerID
                                } elseif ($ManagerDisplayName) {
                                    $Value = @{
                                        displayName = $ManagerDisplayName
                                    }
                                } else {
                                    $Value = $PSBoundParameters[$Key]
                                }
                            } else {
                                $Value = $null
                            }
                            if ($ActionPerProperty) {
                                if ($ActionPerProperty[$Key]) {
                                    $ActionProperty = $ActionPerProperty[$Key]
                                } else {
                                    $ActionProperty = 'replace'
                                }
                            } else {
                                $ActionProperty = 'replace'
                            }
                            [ordered] @{
                                op    = $ActionProperty
                                path  = $Path
                                value = $Value
                            }
                        }
                    }
                )
            }
        } else {

            $Body = [ordered] @{
                schemas                                                      = @(
                    "urn:ietf:params:scim:schemas:core:2.0:User"
                    "urn:ietf:params:scim:schemas:extension:enterprise:2.0:User"
                    "urn:ietf:params:scim:schemas:extension:fd:2.0:User"
                )
                # Mandatory
                "id"                                                         = $Id
                "externalId"                                                 = $ExternalId
                "userName"                                                   = $UserName
                "name"                                                       = [ordered] @{
                    "familyName" = $FamilyName
                    "givenName"  = $GivenName
                }
                "displayName"                                                = $DisplayName
                "nickName"                                                   = $NickName
                "profileUrl"                                                 = $ProfileUrl
                "emails"                                                     = @(
                    if ($EmailAddress) {
                        [ordered]@{
                            "value"   = $EmailAddress
                            "type"    = "work"
                            "primary" = $true
                        }
                    }
                    if ($EmailAddressHome) {
                        [ordered]@{
                            "value" = $EmailAddressHome
                            "type"  = "home"
                        }
                    }
                )
                "addresses"                                                  = @(
                    if ($StreetAddress -or $City -or $Region -or $PostalCode -or $Country) {
                        $StreetHash = [ordered]@{
                            "streetAddress" = $StreetAddress
                            "locality"      = $City
                            "region"        = $Region
                            "postalCode"    = $PostalCode
                            "country"       = $Country
                            "type"          = "work"
                            "primary"       = $true
                        }
                        Remove-EmptyValue -Hashtable $StreetHash
                        if ($StreetHash) { $StreetHash }
                    }
                    if ($StreetAddressHome -or $CityHome -or $RegionHome -or $PostalCodeHome -or $CountryHome) {
                        $StreetHash = [ordered]@{
                            "streetAddress" = $StreetAddressHome
                            "locality"      = $CityHome
                            "region"        = $RegionHome
                            "postalCode"    = $PostalCodeHome
                            "country"       = $CountryHome
                            "type"          = "home"
                        }
                        Remove-EmptyValue -Hashtable $StreetHash
                        if ($StreetHash) { $StreetHash }
                    }
                )
                "phoneNumbers"                                               = @(
                    if ($PhoneNumberWork) {
                        [ordered]@{
                            "value"   = $PhoneNumberWork
                            "type"    = "work"
                            "primary" = $true
                        }
                    }
                    if ($PhoneNumberHome) {
                        [ordered]@{
                            "value" = $PhoneNumberHome
                            "type"  = "home"
                        }
                    }
                    if ($PhoneNumberMobile) {
                        [ordered]@{
                            "value" = $PhoneNumberMobile
                            "type"  = "mobile"
                        }
                    }
                )
                "photos"                                                     = @(
                    if ($PhotoUrl) {
                        [ordered]@{
                            "value" = $PhotoUrl
                            "type"  = "photo"
                        }
                    }
                    if ($ThumbnailUrl) {
                        [ordered]@{
                            "value" = $ThumbnailUrl
                            "type"  = "thumbnail"
                        }
                    }
                )
                "password"                                                   = $Password
                "preferredLanguage"                                          = $PreferredLanguage
                "locale"                                                     = $Locale
                "timeZone"                                                   = $TimeZone
                "userType"                                                   = $UserType
                "title"                                                      = $Title
                "active"                                                     = if ($PSBoundParameters.Keys -contains ('Active')) { $Active.IsPresent } else { $Null }
                "roles"                                                      = @(
                    if ($Role) {
                        @{
                            "value"   = $Role
                            "display" = $Role
                        }
                    } else {
                        #@{
                        #    "value"   = 'user'
                        #    "display" = 'user'
                        #}
                    }
                )
                "urn:ietf:params:scim:schemas:extension:enterprise:2.0:User" = [ordered] @{
                    #"organization"   = $Organization # read only...
                    "department"     = $Department
                    "employeeNumber" = $EmployeeNumber
                    "costCenter"     = $CostCenter
                    "division"       = $Division
                    "manager"        = @{
                        "displayName" = $ManagerDisplayName
                        "value"       = $ManagerID
                    }
                }
                "urn:ietf:params:scim:schemas:extension:fd:2.0:User"         = [ordered] @{
                    "description" = $Description
                    "companyId"   = $CompanyId
                    # "companyLogos" = @(
                    #     if ($CompanyLogoUrl) {
                    #         @{
                    #             "value" = $CompanyLogoUrl
                    #             "type"  = "logo"
                    #         }
                    #     }
                    #     if ($CompanyThumbnailUrl) {
                    #         @{
                    #             "value" = $CompanyThumbnailUrl
                    #             "type"  = "thumbnail"
                    #         }
                    #     }
                    # )
                    #'directoryId'  = $DirectoryID
                    'custom01'    = $Custom01
                    'custom02'    = $Custom02
                    'custom03'    = $Custom03
                }
            }
        }
        Try {
            Remove-EmptyValue -Hashtable $Body -Recursive -Rerun 3

            $MethodChosen = if ($Action -eq 'Update') { 'PATCH' } else { 'PUT' }
            if ($BulkProcessing) {
                # Return body is used for using Invoke-FederatedDirectory to add/set/remove users in bulk
                if ($Action -eq 'Update') {
                    Write-Warning -Message "Bulk processing is not supported for Update action. Only Overwrite action is supported. Change action to Overwrite or don't use bulk processing for updates."
                } else {
                    return [ordered] @{
                        data   = $Body
                        method = $MethodChosen
                        bulkId = $SetID
                    }
                }
            }
            $invokeRestMethodSplat = [ordered] @{
                Method      = $MethodChosen
                Uri         = "https://api.federated.directory/v2/Users/$SetID"
                Headers     = [ordered]  @{
                    'Content-Type'  = 'application/json'
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
            if ($PSCmdlet.ShouldProcess($SetID, "Updating user using $Action method")) {
                $ReturnData = Invoke-RestMethod @invokeRestMethodSplat
                # don't return data as we trust it's been updated
                if (-not $Suppress) {
                    $ReturnData
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
                if ($ErrorDetails.Detail -like '*userName is mandatory*') {
                    Write-Warning -Message "Set-FederatedDirectoryUser - $($ErrorDetails.Detail) [Id: $SetID]"
                } else {
                    Write-Warning -Message "Set-FederatedDirectoryUser - Error $($_.Exception.Message), $($ErrorDetails.Detail) [Id: $SetID]"
                }
            }
        }
    } else {
        Write-Warning -Message 'Set-FederatedDirectoryUser - No authorization found. Please make sure to use Connect-FederatedDirectory first.'
    }
}