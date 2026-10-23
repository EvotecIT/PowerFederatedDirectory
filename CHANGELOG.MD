#### Unreleased

- Add exact employee-number lookup through SearchEmployeeNumber and its EmployeeNumber alias, preserving the filter across every page and escaping literal values.
- Use the published build tool with approved-dependency pruning and refresh the read/update examples.

#### 0.0.12 - 2026-10-14

- Keep generated ZIPs and unpacked modules out of source control; build and release commands generate them locally.
- Standardize native Manifest, Build and Publish modes, retain the RunMode alias and add CI checks for source tests and packaged behavior on PowerShell 5.1 and 7.

- Remove authentication token values from verbose messages when reusing cached authorization.
- Reuse cached authorization with Suppress and honor an explicit ForceRefresh request.
- Keep authorization caches separate for each directory and use the most recently selected connection as the default.
- Include the final contact at page boundaries, advance by the returned page size, and preserve filters and strict error handling across pages.
- Provide a native module build entrypoint for packed and unpacked artifacts.
#### 0.0.11 - 2023-10-17

- Add support for specifying a directory ID to Connect-FederatedDirectory.

#### 0.0.10 - 2023.02.14
- Updates warning message to be more clear

#### 0.0.9 - 2023.02.06
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

