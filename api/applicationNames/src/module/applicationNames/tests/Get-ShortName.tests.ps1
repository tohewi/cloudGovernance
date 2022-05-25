BeforeAll {
    $ModulePath = Split-Path -Parent -Path (Split-Path -Parent -Path $PSCommandPath)
    $ModuleName = 'applicationNames'
    $ManifestPath = "$ModulePath\$ModuleName.psd1"
    if (Get-Module -Name $ModuleName) {
        Remove-Module $ModuleName -Force
    }
    Import-Module $ManifestPath -Verbose:$false
}

Describe 'Can correctly shorten application names' {
    It -name 'Honors Keeperlist items when shortening application name' {
        {Get-ShortName("ttl application name test long extre")} | Should -Not -Throw
        Get-ShortName("ttl application name test long extre") | Should -BeExactly "ttlantle"

    }
    It -name 'Shortens also with no Keeperlist items application name' {
        {Get-ShortName("application name test long extre")} | Should -Not -Throw
        Get-ShortName("application name test long extre") | Should -BeExactly "apnateloex"
    }
}