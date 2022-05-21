# cloudGovernance
Cloud Governance APIs and automats.

## Naming API
This naming API handles Application naming within Application Portfolio. It ensures naming meets set Patterns and that naming meets technical requirements.
### Application naming Patterns
Applications in this context mean "solutions" that support business capabilities. They are seldom just a piece of software, but more complex entities consisting of different technologies. Applications are logical level entities and are deployed as Environments on infrastructure of some kind.

Following patterns are defined:
- Sitecode <application name>
- Sitecode <application name> (specifier)
- <application name>
- <application name> (specifier)

*Sitecode* refers to Business Location where application is used.
*Specifier* provides additional information on the scope or use.
  
Both Sitecode and Specifier are also managed as attributes and target is to not to store them in the name. This is primarily caused by lack of UI development on the portfolio tools hence the pieces of information are added to the name itself.
Caveat of having this additional information in the name is that the name becomes tighly coupled to location and organization and changing application name is fairly tedious task if (when) organizations or locations change.
  
Note: Patterns themselves can be modified/customized in the code. They are the base line patterns in the context where API development has been happening.

### Technical requirements
Technical requirements originate from the technologies in use
- On-premises AD: class specific character and length limits
- Azure DevOps: project and component naming limitations on non-compliant characters
- Azure: resource naming limitations, as in storage account with character and length limitations
- Application portfolio systems: character set limitations that prevent/cause issues in data replication
