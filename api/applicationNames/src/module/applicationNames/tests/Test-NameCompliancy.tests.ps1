BeforeAll {
    $ModulePath = Split-Path -Parent -Path (Split-Path -Parent -Path $PSCommandPath)
    $ModuleName = 'applicationNames'
    $ManifestPath = "$ModulePath\$ModuleName.psd1"
    if (Get-Module -Name $ModuleName) {
        Remove-Module $ModuleName -Force
    }
    Import-Module $ManifestPath -Verbose:$false
}

Describe 'Only technically compliant names are accepted. Length.' {
    It -name '1a: Name can not be longer than 36 characters' {
        {Test-NameCompliancy("HELsinki application name very long (test)")} | Should -Not -Throw
        (Test-NameCompliancy("HELsinki application name very long (test)"))[1]['result']  | Should -Be "Application name is too long. Maximum of 36 characters"
    }
    It -name '1b: "SITECODE application name (specifier)" is extracted' {
        {Test-NameCompliancy("HEL application name very long (test)")} | Should -Not -Throw
        (Test-NameCompliancy("HEL application name very long (test)"))[1]['result']  | Should -Be "Application name is too long. Maximum of 36 characters"
    }
    It -name '2a: "application name" is extracted' {
        {Test-NameCompliancy("HELsinki application name very long test")} | Should -Not -Throw
        (Test-NameCompliancy("HELsinki application name very long test"))[1]['result']  | Should -Be "Application name is too long. Maximum of 36 characters"
    }
    It -name '2b: "SITECODE application name (specifier)" is extracted' {
        {Test-NameCompliancy("HEL application name very very long test")} | Should -Not -Throw
        (Test-NameCompliancy("HEL application name very very long test"))[1]['result']  | Should -Be "Application name is too long. Maximum of 36 characters"
    }
}

Describe 'Only technically compliant names are accepted. Should not be starting with "_"' {
    It -name '1a: Name can not start with "_".' {
        {Test-NameCompliancy("_HELsinki application name (test)")} | Should -Not -Throw
        (Test-NameCompliancy("_HELsinki application name (test)"))[1]['result']  | Should -Be "Application name can't begin with '_' or with ' '."
    }
    It -name '1b: Name can not start with "_".' {
        {Test-NameCompliancy("_HEL application name (test)")} | Should -Not -Throw
        (Test-NameCompliancy("_HEL application name (test)"))[1]['result']  | Should -Be "Application name can't begin with '_' or with ' '."
    }
    It -name '2a: Name can not start with "_".' {
        {Test-NameCompliancy("_HELsinki application test")} | Should -Not -Throw
        (Test-NameCompliancy("_HELsinki application test"))[1]['result']  | Should -Be "Application name can't begin with '_' or with ' '."
    }
    It -name '2b: Name can not start with "_".' {
        {Test-NameCompliancy("_HEL application name test")} | Should -Not -Throw
        (Test-NameCompliancy("_HEL application name test"))[1]['result']  | Should -Be "Application name can't begin with '_' or with ' '."
    }
}

Describe 'Only technically compliant names are accepted. Should not have special characters ' {
    It -name '1a: Can not contain special charaters "&".' {
        {Test-NameCompliancy("HELsinki application (test & prod)")} | Should -Not -Throw
        (Test-NameCompliancy("HELsinki application (test & prod)"))[1]['result']  | Should -Be "Application name contains non-allowed printable characters: / : \ ~ & % ; @ ' `" ? < > | # $ * } { , . + = [ ] ! ^ `` "
    }
    It -name '1b: Can not contain special charaters "&".' {
        {Test-NameCompliancy("HEL application (test & prod))")} | Should -Not -Throw
        (Test-NameCompliancy("HEL application (test & prod)"))[1]['result']  | Should -Be "Application name contains non-allowed printable characters: / : \ ~ & % ; @ ' `" ? < > | # $ * } { , . + = [ ] ! ^ `` "
    }
    It -name '2a: Can not contain special charaters "&".' {
        {Test-NameCompliancy("HELsinki application test & prod")} | Should -Not -Throw
        (Test-NameCompliancy("HELsinki application test & prod"))[1]['result']  | Should -Be "Application name contains non-allowed printable characters: / : \ ~ & % ; @ ' `" ? < > | # $ * } { , . + = [ ] ! ^ `` "
    }
    It -name '2b: Can not contain special charaters "&".' {
        {Test-NameCompliancy("HEL application name test & prod")} | Should -Not -Throw
        (Test-NameCompliancy("HEL application name test & prod"))[1]['result']  | Should -Be "Application name contains non-allowed printable characters: / : \ ~ & % ; @ ' `" ? < > | # $ * } { , . + = [ ] ! ^ `` "
    }
}