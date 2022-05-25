BeforeAll {
    $ModulePath = Split-Path -Parent -Path (Split-Path -Parent -Path $PSCommandPath)
    $ModuleName = 'applicationNames'
    $ManifestPath = "$ModulePath\$ModuleName.psd1"
    if (Get-Module -Name $ModuleName) {
        Remove-Module $ModuleName -Force
    }
    Import-Module $ManifestPath -Verbose:$false
}

Describe 'Can correctly replace and filter words in application names' {
    It -name 'This word just disappears' {
        {Get-FilteredName("application thismustdisappear name")} | Should -Not -Throw
        Get-FilteredName("application thismustdisappear name") | Should -BeExactly "application name"

    }
    It -name 'Thistoolong turns into an abbreviation' {
        {Get-FilteredName("thistoolong application name")} | Should -Not -Throw
        Get-FilteredName("thistoolong application name") | Should -BeExactly "ttl application name"
    }
}