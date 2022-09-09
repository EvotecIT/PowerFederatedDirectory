function Set-FederatedDirectoryUser {
    [alias('Set-FDUser')]
    param(
        [System.Collections.IDictionary] $Authorization,
        [string] $Id,
        [string] $ExternalId,
        [parameter()][string] $DirectoryID,
        [parameter()][string] $UserName,
        [Alias('FirstName')] $FamilyName,
        [string] $GivenName,
        [parameter()][string] $DisplayName,
        [string] $NickName,
        [string] $ProfileUrl,
        [string] $EmailAddressWork,
        [string] $EmailAddressHome,
        [string] $StreetAddress,
        [string] $Locality,
        [string] $Region,
        [string] $PostalCode,
        [string] $Country,
        [string] $StreetAddressHome,
        [string] $PostalCodeHome,
        [string] $LocalityHome,
        [string] $RegionHome,
        [string] $CountryHome,
        [string] $PhoneNumberWork,
        [string] $PhoneNumberHome,
        [string] $PhoneNumberMobile,
        [string] $PhotoUrl,
        [string] $ThumbnailUrl,
        [string] $Title,
        [string] $UserType,
        [bool] $Active,
        [string] $EmployeeNumber,
        [string] $CostCenter,
        [string] $Division,
        [string] $Description,

        [switch] $Suppress
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
                if ($EmailAddressWork) {
                    @{
                        "value"   = $EmailAddressWork
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
            "userType"                                                   = $UserType
            "title"                                                      = $Title
            "active"                                                     = $Active # true or false
            # "roles"                                                      = @(
            #     # Always include the mandatory attributes userName & displayName when creating a user.
            #     # However a contact does not contain a userName. Do not include an id attribute or the meta object.
            #     @{
            #         "value"   = "user"
            #         "display" = "user"
            #     }
            # )
            "urn:ietf:params:scim:schemas:extension:enterprise:2.0:User" = [ordered] @{
                "employeeNumber" = $EmployeeNumber
                "costCenter"     = $CostCenter
                "division"       = $Division
            }
            "urn:ietf:params:scim:schemas:extension:fd:2.0:User"         = [ordered] @{
                "description" = $Description
                #'directoryId' = $DirectoryID
            }
        }

        Try {
            Remove-EmptyValue -Hashtable $Body -Recursive -Rerun 2

            $invokeRestMethodSplat = [ordered] @{
                Method      = 'PATCH'
                Uri         = "https://api.federated.directory/v2/Users/$Id"
                Headers     = [ordered]  @{
                    'Content-Type'  = 'application/json'
                    'Authorization' = $Authorization.Authorization
                    'Cache-Control' = 'no-cache'
                }
                Body        = $Body
                ErrorAction = 'Stop'
            }
            if ($DirectoryID) {
                $invokeRestMethodSplat['Headers']['directoryId'] = $DirectoryID
            }
            # for troubleshooting
            if ($VerbosePreference -eq 'Continue') {
                $Body | ConvertTo-Json -Depth 10 | Write-Verbose
            }
            $ReturnData = Invoke-RestMethod @invokeRestMethodSplat
            # don't return data as we trust it's been updated
            if (-not $Suppress) {
                $ReturnData
            }
            # # for troubleshooting
            # if ($VerbosePreference -eq 'Continue') {
            #     $invokeRestMethodSplat.Remove('body')
            #     $invokeRestMethodSplat | ConvertTo-Json -Depth 10 | Write-Verbose
            # }
        } catch {
            $ErrorDetails = $_.ErrorDetails.Message | ConvertFrom-Json -ErrorAction SilentlyContinue
            Write-Warning -Message "Set-FederatedDirectoryUser - Error $($_.Exception.Message), $($ErrorDetails.Detail)"
            return
        }
    } else {
        Write-Warning -Message 'Set-FederatedDirectoryUser - No authorization found. Please make sure to use Connect-FederatedDirectory first.'
    }
}