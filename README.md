# cloudGovernance
Cloud Governance APIs and automats.

## Naming API
This naming API handles Application naming within Application Portfolio. It ensures naming meets set Patterns and that naming meets technical requirements.
### Application naming Patterns
Applications in this context mean "solutions" that support business capabilities. They are seldom just a piece of software, but more complex entities consisting of different technologies. Applications are logical level entities and are deployed as Environments on infrastructure of some kind.

Following patterns are defined:
- Sitecode \<application name\>
- Sitecode \<application name\> (specifier)
- \<application name\>
- \<application name\> (specifier)

where
- *Sitecode* refers to Business Location where application is used.
- *Specifier* provides additional information on the scope or use.
  
Both Sitecode and Specifier are also managed as attributes and target is to not to store them in the name. This is primarily caused by lack of UI development on the portfolio tools hence the pieces of information are added to the name itself.
Caveat of having this additional information in the name is that the name becomes tighly coupled to location and organization and changing application name is fairly tedious task if (when) organizations or locations change.
  
Note: Patterns themselves can be modified/customized in the code. They are the base line patterns in the context where API development has been happening.
### Application name modifiers
Typically, there are words that should not be included in Application names. Those words can be for example company name, organization name, certain technology, etc.
Such words may be completely blocked from the Application name or there may be an abbreviation that is to be used.

#### Filter or Replace
There is a separate function *Get-FilteredName* for which a hash table with 'findthis:replacewith' word pairs can be provided. 'Replace with' can also be empty string if a word should be completely removed. Typical usage is to replace words with common acronyms.

This map is embedded in Initialize-Maps function together with "keeperList".
~~~
Function Initialize-Maps {
    $Global:replaceMap = @{
        "thismustdisappear"   = ""
        "thistoolong"         = "ttl"
    }

    $Global:keeperList = @("ttl")    
}
~~~

#### Keep do not shortened
There may also be words that are not to be shortened in the short name function. They are added to 'keeperList' array. Note that due to Active Directory CN limitations, it may be necessary to have additional failsafe methods to not to run into problems with too many words in a single name that can't be shortened.

### Technical requirements
Technical requirements originate from the technologies in use
- On-premises AD: class specific character and length limits
- Azure DevOps: project and component naming limitations on non-compliant characters
- Azure: resource naming limitations, as in storage account with character and length limitations
- Application portfolio systems: character set limitations that prevent/cause issues in data replication
- Human aspect: a readable and understandable name for the Application helps application users to communicate with Application Support and people tend to invent names for apps that they use rather than a noncomprehensable string.

### API Output
To facilitate above requirements, each Application is provided with three versions of its name
- Full name, which equals to the name as in Application Portfolio
- Application name, which is used in Cloud Resource containers and supports easy programmatic access
- Short name, which is tailored to be used as application identifies in Cloud Resource Names that require short name with tight character set limitation

#### Successful processing

