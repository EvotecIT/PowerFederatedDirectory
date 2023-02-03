#### 0.0.9 - 2023.02.03
- Fixes searching for users in `Get-FederatedDirectoryUser` when using UserName, ExternalID or other fields

#### 0.0.8 - 2023.01.27
- Fixes warning name

#### 0.0.7 - 2022.10.25
- Fixes issue with Native not being respected if there's more people in `Get-FederatedDirectoryUser`

#### 0.0.6 - 2022.10.12
- Fixes issue with manager under certain circumstances and with other fields if manager is not found

#### 0.0.5 - 2022.09.26
- Improved documentation
- Fixed issues with manager
- Added `All` switch to `Remove-FedereatedDirectoryUser` to remove all users from FD at once

#### 0.0.4 - 2022.09.22
- Fixes an issue with EncryptedSecret

#### 0.0.3 - 2022.09.19
- Fixes problem with UTF8 encoding supporting it properly
- Fixes problem with sending in bulk

#### 0.0.2 - 2022.09.16
- Improvements to commands
- Ability to send operations in bulk using `Invoke-FederatedDirectory`

#### 0.0.1 - 2022.09.11
- First, draft version for testing purposes

