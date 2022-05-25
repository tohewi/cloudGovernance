param (
  [Parameter(Mandatory)]
  [object] $parameters
)
BeforeAll { 

}
Describe '1a "application name (specifier)" pattern' {
    It 'Should extract Application and specifier in Lower case with two word application name in mixed case' {
        $assert = @{}
        $assert.add("name","reliability Reporting (specifier)")

        $Application = Add-ApiResource "" $assert
        $Application.status | Should -Be "success"        
        $Application.shortApplicationName | Should -BeExactly "relirepospec"
        $Application.applicationname |Should -BeExactly "reliabilityreportingspecifier"
        $Application.sitecode |Should -Be ""
        $Application.specifier | Should -Be "specifier"
        $Application.application |Should -BeExactly "reliability reporting"
    }

    It 'Should extract Application and specifier in Lower case with two word application name in mixed case where one word is less than 3 char.' {
        $assert = @{}
        $assert.add("name","HR Reporting (spec)")

        $Application = Add-ApiResource "" $assert
        $Application.status | Should -Be "success"        
        $Application.shortApplicationName | Should -BeExactly "hrrepospec"
        $Application.applicationname |Should -BeExactly "hrreportingspec"
        $Application.sitecode |Should -Be ""
        $Application.specifier | Should -Be "spec"
        $Application.application |Should -BeExactly "hr reporting"
    }

    It 'Should extract Site and Application in Lower case with three word application name in mixed case' {
        $assert = @{}
        $assert.add("name","reliability Reporting (specifier)")
        
        $Application = Add-ApiResource "" $assert
        $Application.status | Should -Be "success"        
        $Application.shortApplicationName | Should -BeExactly "relirepospec"
        $Application.applicationname |Should -BeExactly "reliabilityreportingspecifier"
        $Application.sitecode |Should -Be ""
        $Application.specifier | Should -Be "specifier"
        $Application.application |Should -BeExactly "reliability reporting"
    }
    
    It 'Should report Failure with error code on Name length when name is longer than 36 characters' {
        $assert = @{}
        $assert.add("name","reliability Reporting Very Long /Name)")
        
        $Application = Add-ApiResource "" $assert        
        $Application.status | Should -Be "failed"        
        $Application.error | Should -BeLike "Application name is too long. Maximum of 36 characters"
    }
}

Describe '2a "application name" pattern' {
    It 'Should extract Application in Lower case with two word application name in mixed case' {
        $assert = @{}
        $assert.add("name","reliability Reporting")

        $Application = Add-ApiResource "" $assert
        $Application.status | Should -Be "success"        
        $Application.shortApplicationName | Should -BeExactly "reliabreport"
        $Application.applicationname |Should -BeExactly "reliabilityreporting"
        $Application.sitecode |Should -Be ""
        $Application.specifier | Should -Be ""
        $Application.application |Should -BeExactly "reliability reporting"
    }

    It 'Should extract Application in Lower case with two word application name in mixed case where one word is less than 3 char.' {
        $assert = @{}
        $assert.add("name","HR Reporting")

        $Application = Add-ApiResource "" $assert
        $Application.status | Should -Be "success"        
        $Application.shortApplicationName | Should -BeExactly "hrreporting"
        $Application.applicationname |Should -BeExactly "hrreporting"
        $Application.sitecode |Should -Be ""
        $Application.specifier | Should -Be ""
        $Application.application |Should -BeExactly "hr reporting"
    }

    It 'Should extract Site and Application in Lower case with three word application name in mixed case' {
        $assert = @{}
        $assert.add("name","HEL reliability Reporting")
        
        $Application = Add-ApiResource "" $assert
        $Application.status | Should -Be "success"        
        $Application.shortApplicationName | Should -BeExactly "helrelirepo"
        $Application.applicationname |Should -BeExactly "helreliabilityreporting"
        $Application.sitecode |Should -Be "HEL"
        $Application.specifier | Should -Be ""
        $Application.application |Should -BeExactly "reliability reporting"
    }
    
    It 'Should report Failure with error code on Name length when name is longer than 36 characters' {
        $assert = @{}
        $assert.add("name","HEL reliability Reporting Very Long Name")
        
        $Application = Add-ApiResource "" $assert        
        $Application.status | Should -Be "failed"        
        $Application.error | Should -BeLike "Application name is too long. Maximum of 36 characters"
    }

    It 'Should not partially match Site Names to words but select correct Pattern: 2a "application name"' {
        $assert = @{}
        $assert.add("name","HELsinki reliability reporting")        
        $Application = Add-ApiResource "" $assert        
        $Application.status | Should -Be "success"        
        $Application.shortApplicationName | Should -BeExactly "helsrelirepo"
        $Application.applicationname |Should -BeExactly "helsinkireliabilityreporting"
        $Application.sitecode |Should -Be ""
        $Application.specifier | Should -Be ""
        $Application.application |Should -BeExactly "helsinki reliability reporting"
    }   
}

Describe '2b "SITE application name" pattern' {
    It 'Should extract Site and Application in Lower case with two word application name in mixed case' {
        $assert = @{}
        $assert.add("name","HEL reliability Reporting")

        $Application = Add-ApiResource "" $assert
        $Application.status | Should -Be "success"        
        $Application.shortApplicationName | Should -BeExactly "helrelirepo"
        $Application.applicationname |Should -BeExactly "helreliabilityreporting"
        $Application.sitecode |Should -Be "HEL"
        $Application.specifier | Should -Be ""
        $Application.application |Should -BeExactly "reliability reporting"
    }
    
    It 'Should extract Site and Application in Lower case with three word application name in mixed case' {
        $assert = @{}
        $assert.add("name","HEL reliability Reporting")
        
        $Application = Add-ApiResource "" $assert
        $Application.status | Should -Be "success"        
        $Application.shortApplicationName | Should -BeExactly "helrelirepo"
        $Application.applicationname |Should -BeExactly "helreliabilityreporting"
        $Application.sitecode |Should -Be "HEL"
        $Application.specifier | Should -Be ""
        $Application.application |Should -BeExactly "reliability reporting"
    }

    It 'Should extract Site and Application in Lower case with two word application name in mixed case where one word is less than 3 char.' {
        $assert = @{}
        $assert.add("name","HEL HR Reporting")

        $Application = Add-ApiResource "" $assert
        $Application.status | Should -Be "success"        
        $Application.shortApplicationName | Should -BeExactly "helhrrepo"
        $Application.applicationname |Should -BeExactly "helhrreporting"
        $Application.sitecode |Should -Be "HEL"
        $Application.specifier | Should -Be ""
        $Application.application |Should -BeExactly "hr reporting"
    }
}




Describe 'Shortening and Filtering words should work' {
    It 'Word in replaceMap should be replaced with replace-with-word independent of word location' {
        $assert = @{}
        $assert.add("name","nonamecompany thistoolong name")

        $Application = Add-ApiResource "" $assert
        $Application.status | Should -Be "success"        
        $Application.shortApplicationName | Should -BeExactly "nonattlname"
        $Application.applicationname |Should -BeExactly "nonamecompanyttlname"
        $Application.sitecode |Should -Be ""
        $Application.specifier | Should -Be ""
        $Application.application |Should -BeExactly "nonamecompany ttl name"
    }
    It 'Word in replaceMap should be replaced with replace-with-word independent of word location' {
        $assert = @{}
        $assert.add("name","name thistoolong nonamecompany")

        $Application = Add-ApiResource "" $assert
        $Application.status | Should -Be "success"        
        $Application.shortApplicationName | Should -BeExactly "namettlnona"
        $Application.applicationname |Should -BeExactly "namettlnonamecompany"
        $Application.sitecode |Should -Be ""
        $Application.specifier | Should -Be ""
        $Application.application |Should -BeExactly "name ttl nonamecompany"
    }
    It 'Full Word in replaceMap should be Filtered from the name when replace-with-word is "" independent of word location' {
        $assert = @{}
        $assert.add("name","thistoolong thismustdisappear nonamecompany")

        $Application = Add-ApiResource "" $assert
        $Application.status | Should -Be "success"        
        $Application.shortApplicationName | Should -BeExactly "ttlnonamecom"
        $Application.applicationname |Should -BeExactly "ttlnonamecompany"
        $Application.sitecode |Should -Be ""
        $Application.specifier | Should -Be ""
        $Application.application |Should -BeExactly "ttl nonamecompany"
    }
}

