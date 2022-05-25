BeforeAll {
    $ModulePath = Split-Path -Parent -Path (Split-Path -Parent -Path $PSCommandPath)
    $ModuleName = 'applicationNames'
    write-host $ModulePath
    $ManifestPath = "$ModulePath\$ModuleName.psd1"
}

Describe 'Static Analysis: Module Validation' {

    Context 'Validate Module files' {
        Describe -Name 'Module Manifest File is valid' {
            It -name 'Passed Module Manifest Validation' {
                Test-ModuleManifest $ManifestPath
            }
        }
    }

    Context 'Module Import and Export' {

        BeforeAll {
            $ModulePath = Split-Path -Parent -Path (Split-Path -Parent -Path $PSCommandPath)
            $ModuleName = 'applicationNames'
            $ManifestPath = "$ModulePath\$ModuleName.psd1"
            if (Get-Module -Name $ModuleName) {
                Remove-Module $ModuleName -Force
            }
            Import-Module $ManifestPath -Verbose:$false
        }

        Describe -Name 'Module applicationNames was imported' {
            It -name 'Passed Module load' {
                { Import-Module (Join-Path $ModulePath "$ModuleName.psm1") -Force } | Should -Not -Throw
            }

            It -name 'Passed Module removal' {
                $Script = {
                    Remove-Module $ModuleName
                    Import-Module (Join-Path -Path $ModulePath -ChildPath "$ModuleName.psm1")
                }
                $Script | Should -Not -Throw
            }
        }        
    }
}