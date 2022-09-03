


### Creating Tokeen

1. Install OpenSSL (manually or using chocolatey)

```powershell
choco install openssl.light
``


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

### Resources

- https://help.federated.directory/
- https://help.federated.directory/developer/getting-started.html