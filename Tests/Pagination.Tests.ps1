BeforeAll {
    . (Join-Path $PSScriptRoot '../Public/Get-FederatedDirectoryUser.ps1')
    Import-Module PSSharedGoods -MinimumVersion 0.0.313 -ErrorAction Stop
    function Join-UriQuery { param($BaseUri, $QueryParameter) "${BaseUri}?startIndex=$($QueryParameter.startIndex)&filter=$([uri]::EscapeDataString($QueryParameter.filter))" }
    function Invoke-RestMethod { [CmdletBinding()] param($Method, $Uri, $Headers, $ContentType) }
}

Describe 'Federated Directory page completeness' {
    BeforeEach {
        $script:Requests = [Collections.Generic.List[string]]::new()
        $script:Authorization = @{ Authorization = 'synthetic' }
    }
    It 'retains an exact employee number filter across pages using <Parameter>' -ForEach @(
        @{ Parameter = 'SearchEmployeeNumber'; Value = 'employee-42'; Literal = '"employee-42"' },
        @{ Parameter = 'EmployeeNumber'; Value = 'EMP"\42'; Literal = '"EMP\"\\42"' }
    ) {
        Mock Invoke-RestMethod {
            $script:Requests.Add([string] $Uri)
            $start = [int] [regex]::Match([string] $Uri, 'startIndex=(\d+)').Groups[1].Value
            [pscustomobject] @{ StartIndex = $start; TotalResults = 2; Resources = @([pscustomobject] @{ id = "user-$start" }) }
        }
        $selector = @{ $Parameter = $Value }
        $users = @(Get-FederatedDirectoryUser @selector -Authorization $script:Authorization -Count 1 -Native -ErrorAction Stop)
        $users.id | Should -Be @('user-1', 'user-2')
        $script:Requests | Should -HaveCount 2
        $expected = 'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:employeeNumber eq ' + $Literal
        foreach ($request in $script:Requests) {
            ([uri]::UnescapeDataString($request) -split '&filter=', 2)[1] | Should -Be $expected
        }
    }
    It 'includes contact 1001 with a server page size of <PageSize>' -ForEach @(
        @{ PageSize = 1000; Starts = @('1', '1001') },
        @{ PageSize = 500; Starts = @('1', '501', '1001') }
    ) {
        Mock Invoke-RestMethod {
            $script:Requests.Add([string] $Uri)
            $start = [int] [regex]::Match([string] $Uri, 'startIndex=(\d+)').Groups[1].Value
            $end = [math]::Min($start + $PageSize - 1, 1001)
            $resources = @($start..$end | ForEach-Object { [pscustomobject] @{ id = "user-$_" } })
            [pscustomobject] @{ StartIndex = $start; TotalResults = 1001; Resources = $resources }
        }
        $users = @(Get-FederatedDirectoryUser -Authorization $script:Authorization -SearchUserName 'user@example.test' -Native -ErrorAction Stop)
        $users | Should -HaveCount 1001
        $users[-1].id | Should -Be 'user-1001'
        @($script:Requests | ForEach-Object { [regex]::Match($_, 'startIndex=(\d+)').Groups[1].Value }) | Should -Be $Starts
        foreach ($request in $script:Requests) { [uri]::UnescapeDataString($request) | Should -Match 'userName eq "user@example.test"' }
    }

    It 'propagates strict failure from a later page' {
        Mock Invoke-RestMethod {
            $script:Requests.Add([string] $Uri)
            if ($script:Requests.Count -eq 2) { throw 'Directory later page failed' }
            [pscustomobject] @{ StartIndex = 1; TotalResults = 2; Resources = @([pscustomobject] @{ id = 'first' }) }
        }
        { $users = @(Get-FederatedDirectoryUser -Authorization $script:Authorization -Count 1 -Native -ErrorAction Stop) } | Should -Throw '*Directory later page failed*'
    }

    It 'honors a maximum result count across server-limited pages' {
        Mock Invoke-RestMethod {
            $script:Requests.Add([string] $Uri)
            $start = [int] [regex]::Match([string] $Uri, 'startIndex=(\d+)').Groups[1].Value
            [pscustomobject] @{ StartIndex = $start; TotalResults = 10; Resources = @($start..($start + 1) | ForEach-Object { [pscustomobject] @{ id = "user-$_" } }) }
        }
        $users = @(Get-FederatedDirectoryUser -Authorization $script:Authorization -MaxResults 3 -Native -ErrorAction Stop)
        $users.id | Should -Be @('user-1', 'user-2', 'user-3')
        $script:Requests.Count | Should -Be 2
    }

    It 'rejects an empty later page before the declared total' {
        Mock Invoke-RestMethod {
            $script:Requests.Add([string] $Uri)
            if ($script:Requests.Count -eq 2) { return [pscustomobject] @{ StartIndex = 2; TotalResults = 2; Resources = @() } }
            [pscustomobject] @{ StartIndex = 1; TotalResults = 2; Resources = @([pscustomobject] @{ id = 'first' }) }
        }
        { $users = @(Get-FederatedDirectoryUser -Authorization $script:Authorization -Count 1 -Native -ErrorAction Stop) } | Should -Throw '*empty page before the declared total*'
    }
}
