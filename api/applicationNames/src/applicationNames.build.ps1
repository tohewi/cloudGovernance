<#
Build script to be used with all build tasks for the applicationNames API modules
.Synopsis
    Build script (https://github.com/nightroman/Invoke-Build)
    
#>


#region use the most strict mode
Set-StrictMode -Version Latest
#endregion

$modulename = "applicationNames"

#region Task to Copy PowerShell Module files to Azure Function Modules folder
task CopyModuleFiles {

    # Copy Module Files to Output Folder
    if (-not (Test-Path ".\function\Modules\$($modulename)")) {

        $null = New-Item -Path ".\function\Modules\$($modulename)" -ItemType Directory

    }

    Copy-Item -Path ".\src\module\$($modulename)\Private\" -Filter *.* -Recurse -Destination ".\function\Modules\$($modulename)" -Force
    Copy-Item -Path ".\src\module\$($modulename)\Public\" -Filter *.* -Recurse -Destination ".\function\Modules\$($modulename)" -Force
    Copy-Item -Path ".\src\module\$($modulename)\Tests\" -Filter *.* -Recurse -Destination ".\function\Modules\$($modulename)" -Force

    #Copy Module Manifest files
    Copy-Item -Path @(
        ".\src\module\$($modulename)\$($modulename).psd1"
        ".\src\module\$($modulename)\$($modulename).psm1"
    ) -Destination .\function\Modules\$($modulename) -Force        
}
#endregion

#region Module tests
task Test {
    $Tests = Get-ChildItem -Path .\src\module\$($modulename)\Tests  -Filter "*.tests.ps1"    
    $Result = 0
    Foreach ($Test in $Tests) {
        $TestResult = Invoke-Pester "$($Test)" -PassThru -Output Detailed
        $Result = $Result + $TestResult.FailedCount 
    }
    if ($Result -gt 0) {
        throw 'Pester tests failed'
    }
}
#endregion

#region start azure function
task Startfunction {
    exec { Set-Location .\Function\appnaming-convention; Invoke-Expression ('func {0}' -f 'start --functions applicationNames') }
}
#endregion

#region Task clean up Output folder
task Clean {
    # Clean output folder
    if ((Test-Path ".\function\Modules\$($modulename)")) {
        Remove-Item -Path ".\function\Modules\$($modulename)" -Recurse -Force
    }
}
#endregion

#region Default Task. Runs Clean, Test, CopyModuleFiles Tasks
task . Clean, Test, CopyModuleFiles, Startfunction
#endregion

#region Default Task. Runs Clean, Test, CopyModuleFiles Tasks
task TestFunction Clean, CopyModuleFiles, Startfunction
#endregion