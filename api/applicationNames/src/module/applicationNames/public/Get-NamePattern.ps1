Function Get-NamePattern {
    [CmdletBinding()]
    param(
        [string]$applicationname
    )
    # Initialize SiteList
    Initialize-SiteList

    $Matches = @{}

    $pattern1a_sample = "Application Name (Specifier)"
    $pattern1a = "^(?!$($sitelist))\s*((?:\b\w*\W*\b\s*|-|_)*)\s+(?:\((.+)\))$"
    
    $pattern1b_sample = "SITECODE Application Name (Specifier)"
    $pattern1b = "^($($sitelist))\s*((?:\b\w*\W*\b\s*|-|_)*)\s+(?:\((.+)\))$"
    
    $pattern2a_sample = "Application Name"
    $pattern2a = "^(?!$($sitelist))\s*((?:\b\w*\W*\b\s*|-|_)*)(?!\s+\(.*\))$"
    
    $pattern2b_sample = "SITECODE Application Name"
    $pattern2b = "^($($sitelist))\s*((?:\b\w*\W*\b\s*|-|_)*)(?!\s+\(.*\))$"

    switch -regex ($applicationname) {
        $pattern1a { $matches.add($matches.count, "1a"); return $matches }
        $pattern1b { $matches.add($matches.count, "1b"); return $matches }
        $pattern2a { $matches.add($matches.count, "2a"); return $matches }
        $pattern2b { $matches.add($matches.count, "2b"); return $matches }
        Default { $matches.add($matches.count, "no match"); return $matches }
    }
}
