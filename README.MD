


### Creating Tokeen

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

#### Attributes

The attributes, filter and sortBy parameters can be configured by the below list of attributes.

| Attribute                                                                 | Filter operator         |
| ------------------------------------------------------------------------- | ----------------------- |
| id                                                                        | eq                      |
| externalId                                                                | co (admin only)         |
| userName                                                                  | co (admin only)         |
| name.givenName                                                            |                         |
| name.familyName                                                           |                         |
| displayName                                                               | co                      |
| nickName                                                                  |                         |
| profileUrl                                                                |                         |
| title                                                                     | co                      |
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
| urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:division       | co                      |
| urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:department     | co                      |
| urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:manager        | eq (use manager.value)  |
| urn:ietf:params:scim:schemas:extension:fd:2.0:User:description            |                         |
| urn:ietf:params:scim:schemas:extension:fd:2.0:User:directoryId            | eq                      |
| urn:ietf:params:scim:schemas:extension:fd:2.0:User:companyId              | eq                      |
| urn:ietf:params:scim:schemas:extension:fd:2.0:User:companyLogos           |                         |


### Resources

- https://help.federated.directory/
- https://help.federated.directory/developer/getting-started.html