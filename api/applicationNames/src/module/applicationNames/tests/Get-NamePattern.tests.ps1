BeforeAll {
    $ModulePath = Split-Path -Parent -Path (Split-Path -Parent -Path $PSCommandPath)
    $ModuleName = 'applicationNames'
    $ManifestPath = "$ModulePath\$ModuleName.psd1"
    if (Get-Module -Name $ModuleName) {
        Remove-Module $ModuleName -Force
    }
    Import-Module $ManifestPath -Verbose:$false
}

Describe 'Can pick all four application name patterns' {
    It -name '1a: "application name (specifier)" is extracted' {
        {Get-NamePattern("HELsinki application name (test)")} | Should -Not -Throw
        (Get-NamePattern("HELsinki application name (test)"))[3] | Should -Be "1a"
    }
    It -name '1b: "SITECODE application name (specifier)" is extracted' {
        {Get-NamePattern("HEL application name (test)")} | Should -Not -Throw
        (Get-NamePattern("HEL application name (test)"))[4] | Should -Be "1b"
    }
    It -name '2a: "application name" is extracted' {
        {Get-NamePattern("HELsinki application name test")} | Should -Not -Throw
        (Get-NamePattern("HELsinki application name test"))[2] | Should -Be "2a"
    }
    It -name '2b: "SITECODE application name (specifier)" is extracted' {
        {Get-NamePattern("HEL application name test")} | Should -Not -Throw
        (Get-NamePattern("HEL application name test"))[3] | Should -Be "2b"
    }
}