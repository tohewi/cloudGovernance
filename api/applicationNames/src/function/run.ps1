using namespace System.Net

param($Request, $TriggerMetadata)


$name = $Request.Query.Name
if (-not $name) {
    $name = $Request.Body.Name
}

# Stop if an error occurs for Try-Catch to work correctly.
$global:erroractionpreference   = 1

$global:statuscode              = ""

$application                    = ""
$sitecode                       = ""
$specifier                      = ""


###############################################
# main program
###############################################

if ($name) {
    $nameN = Get-FilteredName($name)
    # Check if Name complies with character restrictions
    $isCompliant = Test-NameCompliancy($nameN)
    if ($isCompliant.result) {
        $ValueObject = [PSCustomObject]@{
            "Status" = "Failed"
            "Error"  = $isCompliant.result
        }        
        $ValueJSON = ConvertTo-Json($ValueObject)
        $statuscode = [HttpStatusCode]::BadRequest

        Write-Output "name not compliant. $($isCompliant.result)"
    }    
    else {
        # Split application name into parts (four patterns)
        $sticks = Get-NamePattern -applicationname $nameN
        Write-Output $sticks

        switch ($sticks[$sticks.Count - 1]) {
            '1a' { $applicationName = "$($sticks[1]) $($sticks[2])"; $application = $sticks[1]; $specifier = $sticks[2]; }
            '1b' { $applicationName = "$($sticks[1]) $($sticks[2]) $($sticks[3])"; $sitecode = $sticks[1]; $application = $sticks[2]; $specifier = $sticks[3]; }
            '2a' { $applicationName = "$($sticks[1])"; $application = $sticks[1]; }
            '2b' { $applicationName = "$($sticks[1]) $($sticks[2])"; $sitecode = $sticks[1]; $application = $sticks[2]; }
            Default { $applicationName = "" }
        }
        # application = name of of application (no Site or Specifier)
        # specifier   = additional details of the application usage scope
        # sitecode    = three letter acronym of the site
        # applicationname = [sitecode] applicationname [specifier]

        if ($applicationName) {          

            Write-Output $applicationName
            # Filter and Replace
            $filteredApplicationName = Get-FilteredName($applicationName)
            $filteredApplication = Get-FilteredName($application)
            $short = Get-shortName($filteredApplicationName)
        
            Write-Output $short
            $ValueObject = [PSCustomObject]@{
                "status"               = "Success"
                "fullApplicationName"  = "$($nameN.ToLower())"
                "shortApplicationName" = "$($short.ToLower())"
                "applicationname"      = "$($filteredApplicationName.Replace(' ','').ToLower())"
                "sitecode"             = "$($sitecode.ToLower())"
                "specifier"            = "$($specifier.ToLower())"
                "application"          = "$($filteredApplication.ToLower())"
            }        
            $ValueJSON = ConvertTo-Json($ValueObject)
            $statuscode = [HttpStatusCode]::OK
        }
        else {
            $ValueObject = [PSCustomObject]@{
                "status" = "Failed"
                "error"  = "Provided Application Name does not match to any Standard Naming Pattern. Please fix Application name and re-Submit."
            }        
            $ValueJSON = ConvertTo-Json($ValueObject)    
            $statuscode = [HttpStatusCode]::BadRequest
        }
    }
}
else {    
    $ValueObject = [PSCustomObject]@{
        "status" = "Failed"
        "error"  = "Required Parameter not found or payload in incorrect format. Submit 'name' parameter in payload and use json format."
    }        
    $ValueJSON = ConvertTo-Json($ValueObject)    
    $statuscode = [HttpStatusCode]::BadRequest    
}

Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = $statuscode
        Body       = $ValueJSON
    })