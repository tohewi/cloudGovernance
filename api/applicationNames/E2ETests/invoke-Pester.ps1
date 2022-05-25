
[CmdletBinding()]
param (
    [Parameter()]
    [String]
    $environment,
    [Parameter()]
    [String]
    $parameterFile,
    [Parameter()]
    [String]
    $testPath
)
# Import Modules required by tests
Import-Module pester

try {
    # Creating results folder
    #$TestResultsPath = "$env:AGENT_TEMPDIRECTORY/results"
    $TestResultsPath = "$here/results"
    write-host "creating temp folder $TestResultsPath"
    $null = new-item -ItemType Directory "$TestResultsPath" -ErrorAction SilentlyContinue
    
    Write-Host "Reading from Parameter file: $parameterFile"
    if ($parameterFile) {
        $parameters = (Get-Content -path $parameterFile | convertfrom-json).parameters.envParameters.value
    }
    else {
        $parameters = @{}
    }


    if (Test-Path $testPath) {
        # Add Parameters to Powershell Object
        $params = @{
            parameters = $parameters
        }
        # Create Pester Container with Parameters and use with all files
        $container = New-PesterContainer -Data $params -Path *

        # Create Pester Config Object
        $pesterConfig = @{
            Run        = @{
                PassThru  = $true 
                Path      = $testPath
                Container = $container
            }
            Output     = @{
                Verbosity = "Detailed"
            }
            TestResult = @{
                Enabled    = $true
                OutputPath = "$($TestResultsPath)/$($environment).xml"
            }
        }
        # Create Pester Config from object
        $config = New-PesterConfiguration -Hashtable $pesterConfig
        # Run Pester Tests 
        $result = Invoke-Pester -Configuration $config
        

    }
    else {
        throw "Test Path is empty"
    }

    if ($null -eq $result) {
        throw "Error Results are empty"
    }
}

catch {
    Write-Host $_
    exit 1
}