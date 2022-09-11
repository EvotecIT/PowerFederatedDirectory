# PowerFederatedDirectory - PowerShell Module

<p align="center">
  <a href="https://dev.azure.com/evotecpl/PowerFederatedDirectory/_build/results?buildId=latest"><img src="https://img.shields.io/azure-devops/build/evotecpl/39c74615-8f34-4af0-a835-68dc33f9214f/14?label=Azure%20Pipelines&style=flat-square"></a>
  <a href="https://www.powershellgallery.com/packages/PowerFederatedDirectory"><img src="https://img.shields.io/powershellgallery/v/PowerFederatedDirectory.svg?style=flat-square"></a>
  <a href="https://www.powershellgallery.com/packages/PowerFederatedDirectory"><img src="https://img.shields.io/powershellgallery/vpre/PowerFederatedDirectory.svg?label=powershell%20gallery%20preview&colorB=yellow&style=flat-square"></a>
  <a href="https://github.com/EvotecIT/PowerFederatedDirectory"><img src="https://img.shields.io/github/license/EvotecIT/PowerFederatedDirectory.svg?style=flat-square"></a>
</p>

<p align="center">
  <a href="https://www.powershellgallery.com/packages/PowerFederatedDirectory"><img src="https://img.shields.io/powershellgallery/p/PowerFederatedDirectory.svg?style=flat-square"></a>
  <a href="https://github.com/EvotecIT/PowerFederatedDirectory"><img src="https://img.shields.io/github/languages/top/evotecit/PowerFederatedDirectory.svg?style=flat-square"></a>
  <a href="https://github.com/EvotecIT/PowerFederatedDirectory"><img src="https://img.shields.io/github/languages/code-size/evotecit/PowerFederatedDirectory.svg?style=flat-square"></a>
  <a href="https://www.powershellgallery.com/packages/PowerFederatedDirectory"><img src="https://img.shields.io/powershellgallery/dt/PowerFederatedDirectory.svg?style=flat-square"></a>
</p>

<p align="center">
  <a href="https://twitter.com/PrzemyslawKlys"><img src="https://img.shields.io/twitter/follow/PrzemyslawKlys.svg?label=Twitter%20%40PrzemyslawKlys&style=flat-square&logo=twitter"></a>
  <a href="https://evotec.xyz/hub"><img src="https://img.shields.io/badge/Blog-evotec.xyz-2A6496.svg?style=flat-square"></a>
  <a href="https://www.linkedin.com/in/pklys"><img src="https://img.shields.io/badge/LinkedIn-pklys-0077B5.svg?logo=LinkedIn&style=flat-square"></a>
</p>

`PowerFederatedDirectory` is a PowerShell module to interact with service https://www.federated.directory/. This module uses API exposed by **Federated Directory** and allows to Add, Get, Set and Remove users from **Federated Directory**.
This is unofiicial module and is not supported by **Federated Directory**, but it does work just fine.

### Creating Token

1. Install OpenSSL (manually or using chocolatey)

```powershell
choco install openssl.light
```


2. Install PowerShell Module called `jwtPS`

```powershell
Install-Module jwtPS -Force -Verbose
```

3. Get the token by providing Key, Issuer and Private Key that are available on Federated Directory

```powershell
$Key = Get-Content -Raw -LiteralPath $PrivateKeyPath # Saved private key from Federated Directory
$Payload = @{
    aud     = "eyJhbGciOiJI6Imtl" # Key from Federated Directory
    iss     = "ws06v" # Issuer name from Federated Directory
    "scope" = @("directoryKey")
}
$JWT = New-JWT -PrivateKey $Key -Algorithm RS256 -Payload $Payload
$JWT
```

4. Use the token in the `Connect-FederatedDirectory`. Once created token works forever, so the OpenSSL / jwtPS is not required on production environment.

### Using the module

Connect to Federated Directory using created token. This token will automatically be used for all commands.

```powershell
Connect-FederatedDirectory -Token $JWT -Suppress
```

#### Get users

```powershell
Get-FederatedDirectoryUser -Attributes id, userName, 'custom01', 'custom02', 'employeeNumber' -Verbose | Format-Table *
```

#### Create users

```powershell
for ($i = 1; $i -le 10; $i++) {
    Add-FederatedDirectoryUser -UserName "TestUserNew$i@test.pl" -DisplayName "TestUserNew$i" -Suppress
}
```

#### Update users

```powershell
Set-FederatedDirectoryUser -Id '11105df0-31cf-11ed-ada4-2bbc677ce86d' -DisplayName 'New name' -FamilyName 'New namme' -EmailAddressHome 'test@evo.pl' -PhoneNumberHome '50246000' -Verbose -Custom01 'test123' -Action Update
```

#### Remove users

```powershell
Remove-FederatedDirectoryUser -Id '11105df0-31cf-11ed-ada4-2bbc677ce86d' -Verbose
```

### Attributes

The attributes, filter and sortBy parameters can be configured by the below list of attributes.

| Attribute                                                                 | Filter operator         |
| ------------------------------------------------------------------------- | ----------------------- |
| **id**                                                                    | eq                      |
| externalId                                                                | co (admin only)         |
| userName                                                                  | co (admin only)         |
| name.givenName                                                            |                         |
| name.familyName                                                           |                         |
| **displayName**                                                           | co                      |
| nickName                                                                  |                         |
| profileUrl                                                                |                         |
| **title**                                                                 | co                      |
| userType                                                                  |                         |
| emails                                                                    |                         |
| phoneNumbers                                                              |                         |
| addresses                                                                 |                         |
| preferredLanguage                                                         |                         |
| locale                                                                    |                         |
| timezone                                                                  |                         |
| active                                                                    |                         |
| groups                                                                    | eq (group members only) |
| roles                                                                     |                         |
| meta                                                                      |                         |
| urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:organization   |                         |
| urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:employeeNumber |                         |
| urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:costCenter     |                         |
| **urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:division**   | co                      |
| **urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:department** | co                      |
| urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:manager        | eq (use manager.value)  |
| urn:ietf:params:scim:schemas:extension:fd:2.0:User:description            |                         |
| urn:ietf:params:scim:schemas:extension:fd:2.0:User:directoryId            | eq                      |
| urn:ietf:params:scim:schemas:extension:fd:2.0:User:companyId              | eq                      |
| urn:ietf:params:scim:schemas:extension:fd:2.0:User:companyLogos           |                         |

When no attributes are specified as a parameter in the query, it will default to the bold printed attributes above.

Every filter attribute has a default filter operator which will be used, no matter which filter operator you use in the query. This default filter operator query can be found in the above attribute table. You can only filter on those attributes that have a default filter operator value.

### Resources

- https://help.federated.directory/
- https://help.federated.directory/developer/getting-started.html