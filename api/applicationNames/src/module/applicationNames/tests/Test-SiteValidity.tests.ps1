BeforeAll {
    $ModulePath = Split-Path -Parent -Path (Split-Path -Parent -Path $PSCommandPath)
    $ModuleName = 'applicationNames'
    $ManifestPath = "$ModulePath\$ModuleName.psd1"
    if (Get-Module -Name $ModuleName) {
        Remove-Module $ModuleName -Force
    }
    Import-Module $ManifestPath -Verbose:$false
}

Describe 'Site validity can be tested' {
    It -name 'If site is not found, $false is returned' {
        {Test-SiteValidity("ton")} | Should -Not -Throw
        Test-SiteValidity("ton") | Should -BeFalse

    }
    It -name 'If site is found, $true is returned' {
        {Test-SiteValidity("hel")} | Should -Not -Throw
        Test-SiteValidity("hel") | Should -BeTrue
    }
}