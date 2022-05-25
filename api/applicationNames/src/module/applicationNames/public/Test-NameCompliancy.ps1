Function Test-NameCompliancy {
    [CmdletBinding()]
    param(
        [string]$name
    )

    # Patterns
    $group_1 = "Application name is too long. Maximum of 36 characters"
    $group_2 = "Application name can't begin with '_' or with ' '."
    $group_3 = "Application name contains non-allowed printable characters: / : \ ~ & % ; @ ' `" ? < > | # $ * } { , . + = [ ] ! ^ `` "

    $pattern0a = "^([\w\W]{37,}$)|(^[_ ].*$)|(^.*[\\\/~%;@'`"<>|$*{},+=!^`._&?:#\[\]].*$)$"

    $Matches = ""
    $name -match $pattern0a 

    switch ($Matches.keys) {
        '1' { $matches.add("result", $group_1); return $matches }        
        '2' { $matches.add("result", $group_2); return $matches }        
        '3' { $matches.add("result", $group_3); return $matches }        
        Default { return ($name).ToLower() }
    }    
}