function Join-UriQuery {
    <#
    .SYNOPSIS
    Provides ability to join two Url paths together including advanced querying

    .DESCRIPTION
    Provides ability to join two Url paths together including advanced querying which is useful for RestAPI/GraphApi calls

    .PARAMETER BaseUri
    Primary Url to merge

    .PARAMETER RelativeOrAbsoluteUri
    Additional path to merge with primary url (optional)

    .PARAMETER QueryParameter
    Parameters and their values in form of hashtable

    .PARAMETER EscapeUriString
    If set, will escape the url string

    .EXAMPLE
    Join-UriQuery -BaseUri 'https://evotec.xyz/' -RelativeOrAbsoluteUri '/wp-json/wp/v2/posts' -QueryParameter @{
        page     = 1
        per_page = 20
        search   = 'SearchString'
    }

    .EXAMPLE
    Join-UriQuery -BaseUri 'https://evotec.xyz/wp-json/wp/v2/posts' -QueryParameter @{
        page     = 1
        per_page = 20
        search   = 'SearchString'
    }

    .EXAMPLE
    Join-UriQuery -BaseUri 'https://evotec.xyz' -RelativeOrAbsoluteUri '/wp-json/wp/v2/posts'

    .NOTES
    General notes
    #>
    [alias('Join-UrlQuery')]
    [CmdletBinding()]
    param (
        [parameter(Mandatory)][uri] $BaseUri,
        [parameter(Mandatory = $false)][uri] $RelativeOrAbsoluteUri,
        [Parameter()][System.Collections.IDictionary] $QueryParameter,
        [alias('EscapeUrlString')][switch] $EscapeUriString
    )
    begin {
        Add-Type -AssemblyName System.Web
    }
    process {
        # Join primary url with additional path if needed
        if ($BaseUri -and $RelativeOrAbsoluteUri) {
            $Url = Join-Uri -BaseUri $BaseUri -RelativeOrAbsoluteUri $RelativeOrAbsoluteUri
        } else {
            $Url = $BaseUri
        }

        # Create a http name value collection from an empty string
        if ($QueryParameter) {
            $Collection = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
            foreach ($key in $QueryParameter.Keys) {
                $Collection.Add($key, $QueryParameter.$key)
            }
        }

        # Build the uri
        $uriRequest = [System.UriBuilder] $Url
        if ($Collection) {
            $uriRequest.Query = $Collection.ToString()
        }
        if (-not $EscapeUriString) {
            $uriRequest.Uri.AbsoluteUri
        } else {
            [System.Uri]::EscapeUriString($uriRequest.Uri.AbsoluteUri)
        }
    }
}
function Remove-EmptyValue {
    <#
    .SYNOPSIS
    Removes empty values from a hashtable recursively.

    .DESCRIPTION
    This function removes empty values from a given hashtable. It can be used to clean up a hashtable by removing keys with null, empty string, empty array, or empty dictionary values. The function supports recursive removal of empty values.

    .PARAMETER Hashtable
    The hashtable from which empty values will be removed.

    .PARAMETER ExcludeParameter
    An array of keys to exclude from the removal process.

    .PARAMETER Recursive
    Indicates whether to recursively remove empty values from nested hashtables.

    .PARAMETER Rerun
    Specifies the number of times to rerun the removal process recursively.

    .PARAMETER DoNotRemoveNull
    If specified, null values will not be removed.

    .PARAMETER DoNotRemoveEmpty
    If specified, empty string values will not be removed.

    .PARAMETER DoNotRemoveEmptyArray
    If specified, empty array values will not be removed.

    .PARAMETER DoNotRemoveEmptyDictionary
    If specified, empty dictionary values will not be removed.

    .EXAMPLE
    $hashtable = @{
        'Key1' = '';
        'Key2' = $null;
        'Key3' = @();
        'Key4' = @{}
    }
    Remove-EmptyValue -Hashtable $hashtable -Recursive

    Description
    -----------
    This example removes empty values from the $hashtable recursively.

    .EXAMPLE
    $SplatDictionary = [ordered] @{
        Test  = $NotExistingParameter
        Test1 = 'Existing Entry'
        Test2 = $null
        Test3 = ''
        Test5 = 0
        Test6 = 6
        Test7 = @{}
    }

    Remove-EmptyValue -Splat $SplatDictionary -Recursive -ExcludeParameter 'Test7'

    $SplatDictionary

    #>
    [alias('Remove-EmptyValues')]
    [CmdletBinding()]
    param(
        [alias('Splat', 'IDictionary')][Parameter(Mandatory)][System.Collections.IDictionary] $Hashtable,
        [string[]] $ExcludeParameter,
        [switch] $Recursive,
        [int] $Rerun,
        [switch] $DoNotRemoveNull,
        [switch] $DoNotRemoveEmpty,
        [switch] $DoNotRemoveEmptyArray,
        [switch] $DoNotRemoveEmptyDictionary
    )
    foreach ($Key in [string[]] $Hashtable.Keys) {
        if ($Key -notin $ExcludeParameter) {
            if ($Recursive) {
                if ($Hashtable[$Key] -is [System.Collections.IDictionary]) {
                    if ($Hashtable[$Key].Count -eq 0) {
                        if (-not $DoNotRemoveEmptyDictionary) {
                            $Hashtable.Remove($Key)
                        }
                    } else {
                        Remove-EmptyValue -Hashtable $Hashtable[$Key] -Recursive:$Recursive -ExcludeParameter $ExcludeParameter -DoNotRemoveNull:$DoNotRemoveNull -DoNotRemoveEmpty:$DoNotRemoveEmpty -DoNotRemoveEmptyArray:$DoNotRemoveEmptyArray -DoNotRemoveEmptyDictionary:$DoNotRemoveEmptyDictionary
                    }
                } else {
                    if (-not $DoNotRemoveNull -and $null -eq $Hashtable[$Key]) {
                        $Hashtable.Remove($Key)
                    } elseif (-not $DoNotRemoveEmpty -and $Hashtable[$Key] -is [string] -and $Hashtable[$Key] -eq '') {
                        $Hashtable.Remove($Key)
                    } elseif (-not $DoNotRemoveEmptyArray -and $Hashtable[$Key] -is [System.Collections.IList] -and $Hashtable[$Key].Count -eq 0) {
                        $Hashtable.Remove($Key)
                    }
                }
            } else {
                if (-not $DoNotRemoveNull -and $null -eq $Hashtable[$Key]) {
                    $Hashtable.Remove($Key)
                } elseif (-not $DoNotRemoveEmpty -and $Hashtable[$Key] -is [string] -and $Hashtable[$Key] -eq '') {
                    $Hashtable.Remove($Key)
                } elseif (-not $DoNotRemoveEmptyArray -and $Hashtable[$Key] -is [System.Collections.IList] -and $Hashtable[$Key].Count -eq 0) {
                    $Hashtable.Remove($Key)
                }
            }
        }
    }
    if ($Rerun) {
        for ($i = 0; $i -lt $Rerun; $i++) {
            Remove-EmptyValue -Hashtable $Hashtable -Recursive:$Recursive -ExcludeParameter $ExcludeParameter -DoNotRemoveNull:$DoNotRemoveNull -DoNotRemoveEmpty:$DoNotRemoveEmpty -DoNotRemoveEmptyArray:$DoNotRemoveEmptyArray -DoNotRemoveEmptyDictionary:$DoNotRemoveEmptyDictionary
        }
    }
}
function Split-Array {
    <#
    .SYNOPSIS
    Split an array into multiple arrays of a specified size or by a specified number of elements

    .DESCRIPTION
    Split an array into multiple arrays of a specified size or by a specified number of elements

    .PARAMETER Objects
    Lists of objects you would like to split into multiple arrays based on their size or number of parts to split into.

    .PARAMETER Parts
    Parameter description

    .PARAMETER Size
    Parameter description

    .EXAMPLE
    This splits array into multiple arrays of 3
    Example below wil return 1,2,3  + 4,5,6 + 7,8,9
    Split-array -Objects @(1,2,3,4,5,6,7,8,9,10) -Parts 3

    .EXAMPLE
    This splits array into 3 parts regardless of amount of elements
    Split-array -Objects @(1,2,3,4,5,6,7,8,9,10) -Size 3

    .NOTES

    #>
    [CmdletBinding()]
    param(
        [alias('InArray', 'List')][Array] $Objects,
        [int]$Parts,
        [int]$Size
    )
    if ($Objects.Count -eq 1) {
        return $Objects
    }
    if ($Parts) {
        $PartSize = [Math]::Ceiling($inArray.count / $Parts)
    }
    if ($Size) {
        $PartSize = $Size
        $Parts = [Math]::Ceiling($Objects.count / $Size)
    }
    $outArray = [System.Collections.Generic.List[Object]]::new()
    for ($i = 1; $i -le $Parts; $i++) {
        $start = (($i - 1) * $PartSize)
        $end = (($i) * $PartSize) - 1
        if ($end -ge $Objects.count) {
            $end = $Objects.count - 1
        }
        $outArray.Add(@($Objects[$start..$end]))
    }
    , $outArray
}
function Join-Uri {
    <#
    .SYNOPSIS
    Provides ability to join two Url paths together

    .DESCRIPTION
    Provides ability to join two Url paths together

    .PARAMETER BaseUri
    Primary Url to merge

    .PARAMETER RelativeOrAbsoluteUri
    Additional path to merge with primary url

    .EXAMPLE
    Join-Uri 'https://evotec.xyz/' '/wp-json/wp/v2/posts'

    .EXAMPLE
    Join-Uri 'https://evotec.xyz/' 'wp-json/wp/v2/posts'

    .EXAMPLE
    Join-Uri -BaseUri 'https://evotec.xyz/' -RelativeOrAbsoluteUri '/wp-json/wp/v2/posts'

    .EXAMPLE
    Join-Uri -BaseUri 'https://evotec.xyz/test/' -RelativeOrAbsoluteUri '/wp-json/wp/v2/posts'

    .NOTES
    General notes
    #>
    [alias('Join-Url')]
    [cmdletBinding()]
    param(
        [parameter(Mandatory)][uri] $BaseUri,
        [parameter(Mandatory)][uri] $RelativeOrAbsoluteUri
    )

    return ($BaseUri.OriginalString.TrimEnd('/') + "/" + $RelativeOrAbsoluteUri.OriginalString.TrimStart('/'))
    #return [Uri]::new([Uri]::new($BaseUri), $RelativeOrAbsoluteUri).ToString()
    #return [Uri]::new($BaseUri.OriginalString, $RelativeOrAbsoluteUri).ToString()
}

# PowerForge merged source begin 9f634b39f78e8ea9313128964c83f0fe42b27d8ff7ca3e3ca2458f1b1960e5dc
function Convert-FederatedUser {
    [cmdletBinding()]
    param(
        [Array] $Users
    )

    foreach ($FederatedUser in $Users) {
        $WorkEmail = $null
        $HomeEmail = $null
        $WorkPhone = $null
        $MobilePhone = $null
        $HomePhone = $null

        $Addresses = $FederatedUser.'addresses'
        foreach ($Address in $Addresses) {
            if ($Address.'type' -eq 'work') {
                $streetAddress = $Address.streetAddress
                $postalCode = $Address.PostalCode
                $city = $Address.Locality
                $region = $Address.region
                $country = $Address.country
            } elseif ($Address.'type' -eq 'home') {
                $HomeStreetAddress = $Address.streetAddress
                $HomePostalCode = $Address.PostalCode
                $HomeCity = $Address.Locality
                $HomeRegion = $Address.region
                $HomeCountry = $Address.country
            }
        }
        $Emails = $FederatedUser.'emails'
        foreach ($Email in $Emails) {
            if ($Email.Type -eq 'work') {
                $WorkEmail = $Email.Value
            } elseif ($Email.Type -eq 'home') {
                $HomeEmail = $Email.Value
            }
        }
        $PhoneNumbers = $FederatedUser.'phoneNumbers'
        foreach ($Phone in $PhoneNumbers) {
            if ($Phone.Type -eq 'work') {
                $WorkPhone = $Phone.Value
            } elseif ($Phone.Type -eq 'mobile') {
                $MobilePhone = $Phone.Value
            } elseif ($Phone.Type -eq 'home') {
                $HomePhone = $Phone.Value
            }
        }

        $CompanyLogoUrl = $null
        $CompanyThumbnailUrl = $null
        $CompanyLogos = $FederatedUser.'urn:ietf:params:scim:schemas:extension:fd:2.0:User:companyLogos'
        foreach ($C in $CompanyLogos) {
            if ($Type -eq 'logo') {
                $CompanyLogoUrl = $C.Value
            } elseif ($Type -eq 'thumbnail') {
                $CompanyThumbnailUrl = $C.Value
            }
        }

        $PhotoUrl = $null
        $ThumbnailUrl = $null
        $Photos = $FederatedUser.'photos'
        foreach ($C in $Photos) {
            if ($Type -eq 'photo') {
                $PhotoUrl = $C.Value
            } elseif ($Type -eq 'thumbnail') {
                $ThumbnailUrl = $C.Value
            }
        }

        [PSCustomObject] @{
            Id                  = $FederatedUser.'id'
            ExternalId          = $FederatedUser.'externalId'
            UserName            = $FederatedUser.'userName'
            GivenName           = $FederatedUser.'name'.'givenName'
            FamilyName          = $FederatedUser.'name'.'familyName'
            DisplayName         = $FederatedUser.'displayName'
            NickName            = $FederatedUser.'nickName'
            ProfileUrl          = $FederatedUser.'profileUrl'
            Title               = $FederatedUser.'title'
            UserType            = $FederatedUser.'userType'
            EmailAddress        = $WorkEmail
            EmailAddressHome    = $HomeEmail
            PhoneNumberWork     = $WorkPhone
            PhoneNumberMobile   = $MobilePhone
            PhoneNumberHome     = $HomePhone

            StreetAddress       = $streetAddress
            City                = $City
            Region              = $region
            PostalCode          = $postalCode
            Country             = $country

            StreetAddressHome   = $HomeStreetAddress
            CityHome            = $HomeCity
            RegionHome          = $HomeRegion
            PostalCodeHome      = $HomePostalCode
            CountryHome         = $HomeCountry

            PreferredLanguage   = $FederatedUser.'preferredLanguage'

            Locale              = $FederatedUser.'locale'
            TimeZone            = $FederatedUser.'timezone'
            Active              = $FederatedUser.'active'
            Groups              = $FederatedUser.'groups'
            Roles               = $FederatedUser.'roles'.value
            Organization        = $FederatedUser.'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User'.'organization'
            EmployeeNumber      = $FederatedUser.'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User'.'employeeNumber'
            CostCenter          = $FederatedUser.'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User'.'costCenter'
            Division            = $FederatedUser.'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User'.'division'
            Department          = $FederatedUser.'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User'.'department'
            Manager             = $FederatedUser.'urn:ietf:params:scim:schemas:extension:enterprise:2.0User'.'manager'
            Description         = $FederatedUser.'urn:ietf:params:scim:schemas:extension:fd:2.0:User'.'description'
            DirectoryId         = $FederatedUser.'urn:ietf:params:scim:schemas:extension:fd:2.0:User'.'directoryId'
            CompanyId           = $FederatedUser.'urn:ietf:params:scim:schemas:extension:fd:2.0:User'.'companyId'

            CompanyLogoUrl      = $CompanyLogoUrl
            CompanyThumbnailUrl = $CompanyThumbnailUrl

            PhotoUrl            = $PhotoUrl
            ThumbnailUrl        = $ThumbnailUrl

            Password            = $FederatedUser.Password
            ManagerID           = $FederatedUser.'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User'.'manager'.'value'
            #ManagerUserName     = $FederatedUser.'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:manager'.'displayName'
            #ManagerReference    = $FederatedUser.'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User'.'manager'.'$ref'
            ManagerDisplayName  = $FederatedUser.'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User'.'manager'.'displayName'
            Role                = $FederatedUser.'roles'.value
            Custom01            = $FederatedUser.'urn:ietf:params:scim:schemas:extension:fd:2.0:User'.'custom01'
            Custom02            = $FederatedUser.'urn:ietf:params:scim:schemas:extension:fd:2.0:User'.'custom02'
            Custom03            = $FederatedUser.'urn:ietf:params:scim:schemas:extension:fd:2.0:User'.'custom03'

            ResourceType        = $FederatedUser.Meta.ResourceType
            Created             = $FederatedUser.Meta.Created
            LastModified        = $FederatedUser.Meta.LastModified
            Location            = $FederatedUser.Meta.location
        }
    }
}
# PowerForge merged source end 9f634b39f78e8ea9313128964c83f0fe42b27d8ff7ca3e3ca2458f1b1960e5dc

# PowerForge merged source begin 9f634b39f78e8ea9313128964c83f0fe42b27d8ff7ca3e3ca2458f1b1960e5dc
function Add-FederatedDirectoryUser {
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

        try {
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
# PowerForge merged source end 9f634b39f78e8ea9313128964c83f0fe42b27d8ff7ca3e3ca2458f1b1960e5dc

# PowerForge merged source begin 9f634b39f78e8ea9313128964c83f0fe42b27d8ff7ca3e3ca2458f1b1960e5dc
function Connect-FederatedDirectory {
    <#
    .SYNOPSIS
    Connects to a federated directory.

    .DESCRIPTION
    Connects to a federated directory.

    .PARAMETER Token
    The token to use for authentication to the federated directory from New-JWT command. This is the default.

    .PARAMETER TokenEncrypted
    The encrypted token to use for authentication to the federated directory from New-JWT command.

    .PARAMETER ExpiresTimeout
    The number of seconds before the token expires.

    .PARAMETER ForceRefresh
    Forces a refresh of the authentication

    .PARAMETER Suppress
    Suppresses the output of the command. By default the command will output the connection information.

    .EXAMPLE
    $Token = 'TokenInformation'
    Connect-FederatedDirectory -Token $Token -Suppress

    .NOTES
    General notes
    #>
    [alias('Connect-FD')]
    [cmdletbinding(DefaultParameterSetName = 'ClearText')]
    param(
        [Parameter(Mandatory, ParameterSetName = 'ClearText')]
        [alias('ApplicationSecret', 'ApplicationKey')]
        [string] $Token,

        [Parameter(Mandatory, ParameterSetName = 'Encrypted')]
        [alias('ApplicationSecretEncrypted', 'ApplicationKeyEncrypted')]
        [string] $TokenEncrypted,

        [int] $ExpiresTimeout = 30,
        [switch] $ForceRefresh,
        [string] $DirectoryID,
        [switch] $Suppress
    )
    if (-not $Script:AuthorizationCacheFD) {
        $Script:AuthorizationCacheFD = [ordered] @{}
    }

    if ($TokenEncrypted) {
        try {
            $ApplicationKeyTemp = $TokenEncrypted | ConvertTo-SecureString -ErrorAction Stop
        } catch {
            if ($PSBoundParameters.ErrorAction -eq 'Stop') {
                throw
            } else {
                $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                Write-Warning -Message "Connect-FederatedDirectory - Error: $ErrorMessage"
                return
            }
        }
        $ApplicationKey = [System.Net.NetworkCredential]::new([string]::Empty, $ApplicationKeyTemp).Password
    } else {
        $ApplicationKey = $Token
    }

    $CacheKey = "$($DirectoryID.Length):$DirectoryID$ApplicationKey"

    $RestSplat = @{
        ErrorAction = 'Stop'
        Method      = 'POST'
        Body        = @{
            "grant_type"  = "urn:ietf:params:oauth:grant-type:jwt-bearer"
            "assertion"   = $ApplicationKey
            "directoryId" = $DirectoryID
        }
        Uri         = 'https://api.federated.directory/v2/Login/Oauth2/Token'
    }
    Remove-EmptyValue -Hashtable $RestSplat -Recursive
    if ($Script:AuthorizationCacheFD[$CacheKey] -and -not $ForceRefresh) {
        if ($Script:AuthorizationCacheFD[$CacheKey].ExpiresOn -gt [datetime]::UtcNow) {
            $CachedAuthorization = $Script:AuthorizationCacheFD[$CacheKey]
            $Script:AuthorizationCacheFD.Remove($CacheKey)
            $Script:AuthorizationCacheFD.Insert(0, $CacheKey, $CachedAuthorization)
            Write-Verbose 'Connect-FederatedDirectory - Using cached authorization.'
            if (-not $Suppress) {
                return $CachedAuthorization
            }
            return
        }
    }

    try {
        $Authorization = Invoke-RestMethod @RestSplat
        $Key = [ordered] @{
            'Authorization' = "$($Authorization.token_type) $($Authorization.access_token)"
            'Extended'      = $Authorization
            'Error'         = ''
            'ExpiresOn'     = ([datetime]::UtcNow).AddSeconds($Authorization.expires_in - $ExpiresTimeout)
            'Splat'         = [ordered] @{
                Token = $RestSplat['Body']['assertion']
            }
            'Platform'      = $Platform
        }
        if ($Script:AuthorizationCacheFD.Contains($CacheKey)) { $Script:AuthorizationCacheFD.Remove($CacheKey) }
        $Script:AuthorizationCacheFD.Insert(0, $CacheKey, $Key)
    } catch {
        if ($PSBoundParameters.ErrorAction -eq 'Stop') {
            throw
        } else {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            Write-Warning -Message "Connect-FederatedDirectory - Error: $ErrorMessage"
            $Key = [ordered] @{
                'Authorization' = $Null
                'Extended'      = $Null
                'Error'         = $ErrorMessage
                'ExpiresOn'     = $null
                'Splat'         = [ordered] @{
                    Token = $RestSplat['Body']['assertion']
                }
                'Platform'      = $Platform
            }
        }
    }
    if (-not $Suppress) {
        $Key
    }
}
# PowerForge merged source end 9f634b39f78e8ea9313128964c83f0fe42b27d8ff7ca3e3ca2458f1b1960e5dc

# PowerForge merged source begin 9f634b39f78e8ea9313128964c83f0fe42b27d8ff7ca3e3ca2458f1b1960e5dc
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

    try {
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
# PowerForge merged source end 9f634b39f78e8ea9313128964c83f0fe42b27d8ff7ca3e3ca2458f1b1960e5dc

# PowerForge merged source begin 9f634b39f78e8ea9313128964c83f0fe42b27d8ff7ca3e3ca2458f1b1960e5dc
function Get-FederatedDirectoryUser {
    [alias('Get-FDUser')]
    [cmdletbinding()]
    param(
        [System.Collections.IDictionary] $Authorization,
        [string] $Id,
        [Alias('UserName')][string] $SearchUserName,
        [Alias('ExternalID')][string] $SearchExternalID,
        [string] $Search,
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
        [string] $SearchProperty = 'userName',
        [string] $SearchOperator = 'eq',
        [string] $DirectoryID,
        [int] $MaxResults,
        [int] $StartIndex = 1,
        [int] $Count = 1000,
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
            filter     = if ($SearchUserName) {
                # keep in mind regardless of used operator it will always revert back to co as per API (weird)
                "userName eq `"$SearchUserName`""
            } elseif ($SearchExternalID) {
                "externalId eq `"$SearchExternalID`""
            } elseif ($Search -and $SearchProperty) {
                "$($ConvertAttributes[$SearchProperty]) $SearchOperator `"$Search`""
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
        try {
            $BatchObjects = Invoke-RestMethod -Method Get -Uri $Uri -Headers $Headers -ErrorAction Stop -ContentType 'application/json; charset=utf-8'
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
            if ($BatchObjects.TotalResults -gt 0 -and $BatchObjects.TotalResults -ge $StartIndex) {
                $message = 'Federated Directory returned an empty page before the declared total was retrieved.'
                if ($ErrorActionPreference -eq [System.Management.Automation.ActionPreference]::Stop) { throw $message }
                Write-Warning $message
                return
            }
            Write-Verbose "Get-FederatedDirectoryUser - No users found"
            return
        }
        $ReturnedCount = if ($null -ne $BatchObjects.Resources) { @($BatchObjects.Resources).Count } else { 0 }
        $NextStartIndex = [long] $BatchObjects.StartIndex + $ReturnedCount
        if (-not $Count -and -not $StartIndex) {
            # paging is disabled, we don't do anything
        } elseif (-not $LimitReached -and $ReturnedCount -gt 0 -and $BatchObjects.TotalResults -ge $NextStartIndex) {
            if ($NextStartIndex -le $StartIndex) {
                $message = 'Federated Directory pagination did not advance. A complete result could not be retrieved.'
                if ($ErrorActionPreference -eq [System.Management.Automation.ActionPreference]::Stop) { throw $message }
                Write-Warning $message
                return
            }
            # lets get more users because there's more to get and user wanted more
            if ($MaxResults -gt 0) { $MaxResults = $MaxResults - $ReturnedCount }
            Write-Verbose "Get-FederatedDirectoryUser - Processing more pages (StartIndex: $StartIndex, Count: $Count)."
            $getFederatedDirectoryUserSplat = @{
                Authorization = $Authorization
                StartIndex    = $NextStartIndex
                Count         = $Count
                MaxResults    = $MaxResults
                Filter        = $QueryParameter.filter
                SortBy        = $SortBy
                SortOrder     = $SortOrder
                Attributes    = $Attributes
                DirectoryID   = $DirectoryID
                Native        = $Native
            }
            if ($PSBoundParameters.ContainsKey('ErrorAction')) { $getFederatedDirectoryUserSplat.ErrorAction = $PSBoundParameters.ErrorAction }
            Remove-EmptyValue -Hashtable $getFederatedDirectoryUserSplat
            Get-FederatedDirectoryUser @getFederatedDirectoryUserSplat
        }
    } else {
        Write-Warning -Message 'Get-FederatedDirectoryUser - No authorization found. Please make sure to use Connect-FederatedDirectory first.'
    }
}
# PowerForge merged source end 9f634b39f78e8ea9313128964c83f0fe42b27d8ff7ca3e3ca2458f1b1960e5dc

# PowerForge merged source begin 9f634b39f78e8ea9313128964c83f0fe42b27d8ff7ca3e3ca2458f1b1960e5dc
function Invoke-FederatedDirectory {
    <#
    .SYNOPSIS
    Provides a way to invoke multiple operations on FederatedDirectory in a single request (bulk).

    .DESCRIPTION
    Provides a way to invoke multiple operations on FederatedDirectory in a single request (bulk).
    While the official limit is 1000 operations in a single request, it's actually much lower due to payload size

    .PARAMETER Authorization
    The authorization identity to use for the request from Connect-FederatedDirectory. If not specified, the default authorization identity will be used.

    .PARAMETER Operations
    Operations to perform as part of bulk request

    .PARAMETER Size
    Batch size of operations to send in a single request. Default is 100.

    .PARAMETER ReturnHashtable
    Return results as a hashtable for quick matching BulkId

    .PARAMETER ReturnNative
    Return results the same way REST API returns it

    PARAMETER Suppress
    Prevent returning results

    .EXAMPLE
    Connect-FederatedDirectory -Token $Token -Suppress

    $Operations = for ($i = 1; $i -le 1; $i++) {
        Add-FederatedDirectoryUser -UserName "TestNewwwww$i@test.pl" -DisplayName "TestUserNew$i" -ManagerDisplayName 'TestUser' -FamilyName 'Kłys' -GivenName 'Przemysłąw' -BulkProcessing
        #Set-FederatedDirectoryUser -Id '69c6b3c0-34dd-11ed-a621-4b6b819dffa2' -DisplayName 'New name' -FamilyName 'New namme' -EmailAddressHome 'test@evo.pl' -PhoneNumberHome '502469000' -Custom01 'test123' -Action Update -BulkProcessing
        Set-FederatedDirectoryUser -Id '0c50c6f0-3428-11ed-98e2-11027423d1f1' -DisplayName 'New name' -GivenName "Test" -EmailAddressHome 'test@evo.pl' -PhoneNumberHome '502469000' -Custom01 'test123' -UserName 'TestMe@verymuch.pl' -Action Overwrite -StreetAddress "Test me" -BulkProcessing
        Set-FederatedDirectoryUser -Id '69c6b3c0-34dd-11ed-a621-4b6b819dffa2' -DisplayName 'New name' -GivenName "Test" -EmailAddressHome 'test@evo.pl' -PhoneNumberHome '502469000' -Custom01 'test123' -UserName 'TestMe@verymuch.pl' -Action Overwrite -StreetAddress "Test me" -BulkProcessing
    }
    $Response = Invoke-FederatedDirectory -Operations $Operations -ReturnHashtable
    $Response | Format-Table

    .NOTES
    General notes
    #>
    [cmdletbinding(SupportsShouldProcess)]
    param(
        [System.Collections.IDictionary] $Authorization,
        [Array] $Operations,
        [int] $Size = 1000,
        [switch] $ReturnHashtable,
        [switch] $ReturnNative,
        [switch] $Suppress
    )
    $TranslateMethod = @{
        'PUT'    = 'Update'
        'POST'   = 'Add'
        'DELETE' = 'Remove'
    }
    $TranslateStatus = @{
        '200' = $true
        '201' = $true
        '204' = $true
        '400' = $false
        '401' = $false
        '403' = $false
        '404' = $false
        '409' = $false
        '500' = $false
        '503' = $false
    }

    if (-not $Authorization) {
        if ($Script:AuthorizationCacheFD) {
            $Authorization = $Script:AuthorizationCacheFD[0]
        }
        if (-not $Authorization) {
            if ($PSBoundParameters.ErrorAction -eq 'Stop') {
                throw "No authorization found. Please run 'Connect-FederatedDirectory' first."
            } else {
                Write-Warning -Message "Invoke-FederatedDirectory - No authorization found. Please run 'Connect-FederatedDirectory' first."
                return
            }
        }
    }
    if ($Authorization) {
        $SplitOperations = Split-Array -Objects $Operations -Size $Size
        foreach ($O in $SplitOperations) {
            $Body = [ordered] @{
                schemas    = @('urn:ietf:params:scim:api:messages:2.0:BulkRequest')
                Operations = @($O)
            }
            Remove-EmptyValue -Hashtable $Body -Recursive -Rerun 2

            $invokeRestMethodSplat = [ordered] @{
                Method      = 'POST'
                Uri         = 'https://api.federated.directory/v2/Bulk'
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
            # for troubleshooting
            if ($VerbosePreference -eq 'Continue') {
                $Body | ConvertTo-Json -Depth 10 | Write-Verbose
            }
            $Count = ($O | Measure-Object).Count
            try {
                if ($PSCmdlet.ShouldProcess("Federated Directory", "Bulk sending $($Count) operations")) {
                    $ReturnData = Invoke-RestMethod @invokeRestMethodSplat -Verbose:$false
                    # don't return data as we trust it's been created
                }
            } catch {
                if ($PSBoundParameters.ErrorAction -eq 'Stop') {
                    throw
                } else {
                    $ErrorDetails = $_.ErrorDetails.Message | ConvertFrom-Json -ErrorAction SilentlyContinue
                    Write-Warning -Message "Invoke-FederatedDirectory - Error processing $($_.Exception.Message), $($ErrorDetails.Detail)"
                }
            }

            if ($ReturnData -and -not $Suppress) {
                if ($ReturnNative) {
                    $ReturnData.Operations
                } elseif ($ReturnHashtable) {
                    $ResultsPrepared = [ordered] @{}
                    foreach ($Operation in $ReturnData.Operations) {
                        if ($Operation.method -and $Operation.status) {
                            $ResultsPrepared[$Operation.bulkid] = [PSCustomObject] @{
                                BulkID         = $Operation.bulkid
                                Method         = $TranslateMethod[$Operation.method]
                                Status         = $TranslateStatus[$Operation.status.code.ToString()]
                                StatusResponse = $Operation.status.code
                                Detail         = $Operation.response.detail
                                ScimType       = $Operation.response.scimType
                                Location       = $Operation.location

                            }
                        } else {
                            Write-Warning -Message "Invoke-FederatedDirectory - Error processing, wrong return code. Error: $($Operation.details.message)"
                        }
                    }
                    $ResultsPrepared
                } else {
                    foreach ($Operation in $ReturnData.Operations) {
                        if ($Operation.method -and $Operation.status) {
                            [PSCustomObject] @{
                                BulkID         = $Operation.bulkid
                                Method         = $TranslateMethod[$Operation.method]
                                Status         = $TranslateStatus[$Operation.status.code.ToString()]
                                StatusResponse = $Operation.status.code
                                Detail         = $Operation.response.detail
                                ScimType       = $Operation.response.scimType
                                Location       = $Operation.location
                            }
                        } else {
                            Write-Warning -Message "Invoke-FederatedDirectory - Error processing, wrong return code. Error: $($Operation.details.message)"
                        }
                    }
                }
            }
            # # for troubleshooting
            # if ($VerbosePreference -eq 'Continue') {
            #     $invokeRestMethodSplat.Remove('body')
            #     $invokeRestMethodSplat | ConvertTo-Json -Depth 10 | Write-Verbose
            # }
        }
    } else {
        Write-Warning -Message 'Invoke-FederatedDirectory - No authorization found. Please make sure to use Connect-FederatedDirectory first.'
    }
}
# PowerForge merged source end 9f634b39f78e8ea9313128964c83f0fe42b27d8ff7ca3e3ca2458f1b1960e5dc

# PowerForge merged source begin 9f634b39f78e8ea9313128964c83f0fe42b27d8ff7ca3e3ca2458f1b1960e5dc
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

    .PARAMETER SearchUserName
    The user name of the user to remove from the federated directory.

    .PARAMETER DirectoryID
    The id of the directory to remove the user from. If not specified, the default directory will be used.

    .PARAMETER All
    Remove all users from the directory.

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
    [CmdletBinding(DefaultParameterSetName = 'Id', SupportsShouldProcess)]
    param(
        [System.Collections.IDictionary] $Authorization,
        [parameter(Position = 0, ValueFromPipeline, Mandatory, ParameterSetName = 'User')][PSCustomObject[]] $User,
        [parameter(Mandatory, ParameterSetName = 'Id')][string[]] $Id,
        [parameter(Mandatory, ParameterSetName = 'UserName')][string[]] $SearchUserName,
        [parameter()][string] $DirectoryID,
        [switch] $BulkProcessing,
        [switch] $Suppress,
        [parameter(ParameterSetName = 'All')][switch] $All
    )
    begin {
        if (-not $Authorization) {
            if ($Script:AuthorizationCacheFD) {
                $Authorization = $Script:AuthorizationCacheFD[0]
            }
            if (-not $Authorization) {
                if ($PSBoundParameters.ErrorAction -eq 'Stop') {
                    throw "No authorization found. Please run 'Connect-FederatedDirectory' first."
                } else {
                    Write-Warning -Message "Remove-FederatedDirectoryUser - No authorization found. Please run 'Connect-FederatedDirectory' first."
                    return
                }
            }
        }
    }
    process {
        if ($Authorization) {
            if ($All) {
                # lets simplify this for all
                $Users = Get-FederatedDirectoryUser -Authorization $Authorization -DirectoryID $DirectoryID
                $Remove = foreach ($U in $Users) {
                    Remove-FederatedDirectoryUser -Authorization $Authorization -Id $U.Id -BulkProcessing -DirectoryID $DirectoryID
                }
                Invoke-FederatedDirectory -Authorization $Authorization -Operations $Remove -Suppress:$Suppress.IsPresent
            } else {
                if ($Id) {
                    $RemoveID = $Id
                } elseif ($User) {
                    $RemoveID = $User.Id
                } elseif ($SearchUserName) {
                    $RemoveID = foreach ($U in $SearchUserName) {
                        (Get-FederatedDirectoryUser -Authorization $Authorization -UserName $U).Id
                    }
                } else {
                    return
                }
                foreach ($I in $RemoveID) {
                    try {
                        if ($BulkProcessing) {
                            # Return body is used for using Invoke-FederatedDirectory to add/set/remove users in bulk
                            return [ordered] @{
                                data   = @{
                                    schemas = @("urn:ietf:params:scim:schemas:core:2.0:User")
                                    id      = $I
                                }
                                method = 'DELETE'
                                bulkId = $I
                            }
                        }
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
                            ContentType = 'application/json; charset=utf-8'
                        }
                        Remove-EmptyValue -Hashtable $invokeRestMethodSplat -Recursive

                        if ($VerbosePreference -eq 'Continue') {
                            $invokeRestMethodSplat | ConvertTo-Json -Depth 10 | Write-Verbose
                        }
                        if ($PSCmdlet.ShouldProcess($I, "Removing user")) {
                            $ReturnData = Invoke-RestMethod @invokeRestMethodSplat
                            if (-not $Suppress) {
                                $ReturnData
                            }
                        }
                    } catch {
                        $ErrorDetails = $_.ErrorDetails.Message | ConvertFrom-Json -ErrorAction SilentlyContinue
                        if ($ErrorDetails.Detail -like "*not found*") {
                            Write-Warning -Message "Remove-FederatedDirectoryUser - $($ErrorDetails.Detail)."
                        } else {
                            Write-Warning -Message "Remove-FederatedDirectoryUser - Error $($_.Exception.Message), $($ErrorDetails.Detail)"
                        }
                    }
                }
            }
        } else {
            Write-Warning -Message 'Remove-FederatedDirectoryUser - No authorization found. Please make sure to use Connect-FederatedDirectory first.'
        }
    }
}
# PowerForge merged source end 9f634b39f78e8ea9313128964c83f0fe42b27d8ff7ca3e3ca2458f1b1960e5dc

# PowerForge merged source begin 9f634b39f78e8ea9313128964c83f0fe42b27d8ff7ca3e3ca2458f1b1960e5dc
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
            $SetID = foreach ($U in $SearchUserName) {
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
                            if ($null -ne $PSBoundParameters[$Key]) {
                                if ($Key -eq 'ManagerUserName') {
                                    if ($ManagerID) {
                                        $Value = $ManagerID
                                    } else {
                                        $Value = $null
                                    }
                                } elseif ($Key -eq 'ManagerDisplayName') {
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
                            if ($null -ne $Value) {
                                [ordered] @{
                                    op    = $ActionProperty
                                    path  = $Path
                                    value = $Value
                                }
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
                "active"                                                     = if ($PSBoundParameters.Keys -contains ('Active')) { $Active } else { $Null }
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
        try {
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
# PowerForge merged source end 9f634b39f78e8ea9313128964c83f0fe42b27d8ff7ca3e3ca2458f1b1960e5dc

$FunctionsToExport = @('Add-FederatedDirectoryUser', 'Connect-FederatedDirectory', 'Get-FederatedDirectorySchema', 'Get-FederatedDirectoryUser', 'Invoke-FederatedDirectory', 'Remove-FederatedDirectoryUser', 'Set-FederatedDirectoryUser')
$CmdletsToExport = @()
$AliasesToExport = @('Add-FDUser', 'Connect-FD', 'Get-FDSchema', 'Get-FDUser', 'Remove-FDUser', 'Set-FDUser')
Export-ModuleMember -Function $FunctionsToExport -Alias $AliasesToExport -Cmdlet $CmdletsToExport
