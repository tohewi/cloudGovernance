Function Get-FilteredName {
    [CmdletBinding()]
    param(
        [string]$namestring
    )
    
    # Initialize Keepers and Filters maps
    Initialize-Maps

    # Split parameter to an array
    $filterThis = @()
    $filterThis = -split ($namestring, " ") 

    $target = @()
    foreach ($i in $filterThis.GetEnumerator()) {            
        if ($replaceMap.keys -contains $i) {
            if ($replaceMap[$i]) {
                # word to replace
                $target += $replaceMap[$i]; continue 
            }
            else {
                # Word to filter out
                continue
            }
        }
        if ($i -eq "") { continue }
        $target += $i.ToLower()
    }
    return $target -join " "
}
