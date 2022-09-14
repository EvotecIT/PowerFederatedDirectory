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
        [ValidateSet('admin', 'user')][string] $Role,
        [alias('CustomAttribute01')][string] $Custom01,
        [alias('CustomAttribute02')][string] $Custom02,
        [alias('CustomAttribute03')][string] $Custom03,
        [switch] $Suppress,
        [ValidateSet('Overwrite', 'Update')][string] $Action = 'Update',
        [System.Collections.IDictionary] $ActionPerProperty = @{}
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
            return
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
                ManagerID          = 'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:manager.value'
                ManagerUserName    = 'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:manager.value'
                ManagerDisplayName = 'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:manager.displayName'
                Description        = "urn:ietf:params:scim:schemas:extension:fd:2.0:User:description"
                Custom01           = "urn:ietf:params:scim:schemas:extension:fd:2.0:User:custom01"
                Custom02           = "urn:ietf:params:scim:schemas:extension:fd:2.0:User:custom02"
                Custom03           = "urn:ietf:params:scim:schemas:extension:fd:2.0:User:custom03"
                CompanyID          = "urn:ietf:params:scim:schemas:extension:fd:2.0:User:companyId"
                #CompanyLogoUrl      = 'urn:ietf:params:scim:schemas:extension:fd:2.0:User:companyLogos[type eq "logo"].value'
                #CompanyThumbnailUrl = 'urn:ietf:params:scim:schemas:extension:fd:2.0:User:companyLogos[type eq "thumbnail"].value'
            }

            if ($ManagerUserName) {
                $ManagerID = (Get-FederatedDirectoryUser -Authorization $Authorization -UserName $ManagerUserName).Id
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
                                $Value = $PSBoundParameters[$Key]
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
                        @{
                            "value"   = $EmailAddress
                            "type"    = "work"
                            "primary" = $true
                        }
                    }
                    if ($EmailAddressHome) {
                        @{
                            "value" = $EmailAddressHome
                            "type"  = "home"
                        }
                    }
                )
                "addresses"                                                  = @(
                    if ($StreetAddress -or $Locality -or $Region -or $PostalCode -or $Country) {
                        @{
                            "streetAddress" = $StreetAddress
                            "locality"      = $Locality
                            "region"        = $Region
                            "postalCode"    = $PostalCode
                            "country"       = $Country
                            "type"          = "work"
                            "primary"       = $true
                        }
                    }
                    if ($StreetAddressHome -or $LocalityHome -or $RegionHome -or $PostalCodeHome -or $CountryHome) {
                        @{
                            "streetAddress" = $StreetAddressHome
                            "locality"      = $LocalityHome
                            "region"        = $RegionHome
                            "postalCode"    = $PostalCodeHome
                            "country"       = $CountryHome
                            "type"          = "home"
                        }
                    }
                )
                "phoneNumbers"                                               = @(
                    if ($PhoneNumberWork) {
                        @{
                            "value"   = $PhoneNumberWork
                            "type"    = "work"
                            "primary" = $true
                        }
                    }
                    if ($PhoneNumberHome) {
                        @{
                            "value" = $PhoneNumberHome
                            "type"  = "home"
                        }
                    }
                    if ($PhoneNumberMobile) {
                        @{
                            "value" = $PhoneNumberMobile
                            "type"  = "mobile"
                        }
                    }
                )
                "photos"                                                     = @(
                    if ($PhotoUrl) {
                        @{
                            "value" = $PhotoUrl
                            "type"  = "photo"
                        }
                    }
                    if ($ThumbnailUrl) {
                        @{
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
                    @{
                        "value"   = $Role
                        "display" = $Role
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
            Remove-EmptyValue -Hashtable $Body -Recursive -Rerun 2

            $invokeRestMethodSplat = [ordered] @{
                Method      = if ($Action -eq 'Update') { 'PATCH' } else { 'PUT' }
                Uri         = "https://api.federated.directory/v2/Users/$SetID"
                Headers     = [ordered]  @{
                    'Content-Type'  = 'application/json'
                    'Authorization' = $Authorization.Authorization
                    'Cache-Control' = 'no-cache'
                }
                Body        = $Body | ConvertTo-Json -Depth 10
                ErrorAction = 'Stop'
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