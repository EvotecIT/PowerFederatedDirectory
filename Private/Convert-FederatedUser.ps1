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