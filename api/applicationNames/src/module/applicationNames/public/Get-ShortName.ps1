Function Get-ShortName {
    [CmdletBinding()]
    param(
        [string]$namestring
    )
    $maxLength = 12
    $shortname = ""

    if ($namestring.Length -gt $maxLength) {
        # Split parameter to an array
        $shortenThis = @()
        $shortenThis = $namestring -split " "
        
        # Initialize Keepers and Filters maps
        Initialize-Maps
  
        # Characters to pick from each word before round down.
        $charleft = $maxLength / ($shortenThis.count) 
        $charsNotAvailable = 0
        $keeperCount = 0
        # If there are Keeper words, then rest of the words get fewer chars.
        foreach ($keeper in $keeperList) {
            if ($shortenThis.Contains($keeper)) { 
                $charsNotAvailable = + $keeper.Length
                $keeperCount        ++
            }
        }        
        $charleft = ($maxLength - $charsNotAvailable) / ($shortenThis.count - $keeperCount) 
        if ($charleft -lt 1) {
            # can't handle this short short names.
            exit
        }
        
        $charspick = [Math]::Truncate($charleft)
               
        # Shorten name
        foreach ( $i in $shortenThis.GetEnumerator()) {            
            if ($keeperList.Contains($i)) {
                $shortname = $shortname + $i
            }
            else {
                if ($charspick -le $i.length) {
                    $shortname = $shortname + ($i).Substring(0, $charspick)
                    continue
                }
                if ($charspick -gt $i.length) {
                    $shortname = $shortname + ($i).Trim()
                    continue
                }
            }
        }
        return $shortname.ToLower()

    }
    else {
        return $namestring.Replace(" ", "").ToLower()
    }  
}