# Database scripts
This folder contains SQL scripts (Azure SQL) to generate two tables to "Applications" database.
1. "Applications" table contains a Cloud copy of the Application portfolio with Cloud Governance specific additional information.
2. "State" table to track event/activation state.

There are also Triggers to Applications table to 
1. Update if modified
2. Update modified timestamp when modified.

# Data source
This implementation uses ServiceNow CMDB over ServiceNow REST API (Table api) to obtain Application Portfolio data to Cloud Governance domain.

Integration function source is available in this repository.
