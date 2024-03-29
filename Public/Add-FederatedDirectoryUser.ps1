﻿function Add-FederatedDirectoryUser {
    [alias('Add-FDUser')]
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [System.Collections.IDictionary] $Authorization,
        [string] $ExternalId,
        [parameter()][string] $DirectoryID,
        [parameter(Mandatory)][string] $UserName,
        [Alias('FirstName')] $FamilyName,
        [string] $GivenName,
        [parameter(Mandatory)][string] $DisplayName,
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
        # [string] $CompanyLogoUrl,
        # [string] $CompanyThumbnailUrl,
        [string] $PreferredLanguage,
        [string] $Locale,
        [string] $TimeZone,
        [string] $Title,
        [string] $UserType,
        [string] $Password,
        [string] $ManagerID,
        [string] $ManagerUserName,
        [string] $ManagerDisplayName,
        [switch] $Active,
        [string] $Department,
        [string] $EmployeeNumber,
        [string] $CostCenter,
        [string] $Division,
        [string] $Description,
        [ValidateSet('admin', 'user')][string] $Role = 'user',
        [alias('CustomAttribute01')][string] $Custom01,
        [alias('CustomAttribute02')][string] $Custom02,
        [alias('CustomAttribute03')][string] $Custom03,
        [switch] $Suppress,
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
                Write-Warning -Message "Add-FederatedDirectoryUser - No authorization found. Please run 'Connect-FederatedDirectory' first."
                return
            }
        }
    }
    if ($Authorization) {
        if ($ManagerUserName) {
            $ManagerID = (Get-FederatedDirectoryUser -Authorization $Authorization -UserName $ManagerUserName).Id
        }

        $Body = [ordered] @{
            schemas                                                      = @(
                "urn:ietf:params:scim:schemas:core:2.0:User"
                "urn:ietf:params:scim:schemas:extension:enterprise:2.0:User"
                "urn:ietf:params:scim:schemas:extension:fd:2.0:User"
            )
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
                if ($StreetAddress -or $City -or $Region -or $PostalCode -or $Country) {
                    @{
                        "streetAddress" = $StreetAddress
                        "locality"      = $City
                        "region"        = $Region
                        "postalCode"    = $PostalCode
                        "country"       = $Country
                        "type"          = "work"
                        "primary"       = $true
                    }
                }
                if ($StreetAddressHome -or $CityHome -or $RegionHome -or $PostalCodeHome -or $CountryHome) {
                    @{
                        "streetAddress" = $StreetAddressHome
                        "locality"      = $CityHome
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
                if ($Role) {
                    @{
                        "value"   = $Role
                        "display" = $Role
                    }
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
                    #"`$ref"       = $ManagerReference # readonly
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
                #'directoryId' = $DirectoryID
                'custom01'    = $Custom01
                'custom02'    = $Custom02
                'custom03'    = $Custom03
            }
        }

        Try {
            Remove-EmptyValue -Hashtable $Body -Recursive -Rerun 2

            # for troubleshooting
            if ($VerbosePreference -eq 'Continue') {
                $Body | ConvertTo-Json -Depth 10 | Write-Verbose
            }

            if ($BulkProcessing) {
                # Return body is used for using Invoke-FederatedDirectory to add/set/remove users in bulk

                $ReturnObject = [ordered] @{
                    data   = $Body
                    method = 'POST'
                    bulkId = $Body.userName
                }
                # for troubleshooting
                if ($VerbosePreference -eq 'Continue') {
                    $ReturnObject | ConvertTo-Json -Depth 10 | Write-Verbose
                }
                return $ReturnObject
            }
            $invokeRestMethodSplat = [ordered] @{
                Method      = 'POST'
                Uri         = 'https://api.federated.directory/v2/Users'
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
            if ($PSCmdlet.ShouldProcess("username $UserName, displayname $DisplayName", "Adding user")) {
                $ReturnData = Invoke-RestMethod @invokeRestMethodSplat -Verbose:$false
                # don't return data as we trust it's been created
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
                if ($ErrorDetails.Detail -like '*already exists*directory*') {
                    Write-Warning -Message "Add-FederatedDirectoryUser - $($ErrorDetails.Detail) [UserName: $UserName / DisplayName: $DisplayName]"
                } else {
                    Write-Warning -Message "Add-FederatedDirectoryUser - Error $($_.Exception.Message), $($ErrorDetails.Detail)"
                }
            }
        }
    } else {
        Write-Warning -Message 'Add-FederatedDirectoryUser - No authorization found. Please make sure to use Connect-FederatedDirectory first.'
    }
}