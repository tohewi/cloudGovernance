Function Test-SiteValidity {
    [CmdletBinding()]
    param(
        [string]$siteCode
    )    

    # Initialize SiteList
    Initialize-SiteList


    if ($sitelist.Replace("\b","").Split("|") -contains $siteCode.ToLower()) {
        return 1
    } else {
        return 0
    }
}
