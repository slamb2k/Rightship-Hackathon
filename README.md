# Rightship Hackathon Resources

## User/Group Generation Scripts

<br/>


1. Clone/download the repo.
2. Edit the CSV containing the user details to configure the required user and groups.
3. Execute the New-HackUsers.ps1 script to create the users and groups.

![Alt text](images/users.png)

*Note: When the script is first run, a browser window will open to authenticate with your Azure tenant. The user will require sufficient privileges for Azure Active Directory User and Group management.*

<br/>

## Databricks Workspace Provisioning

See the template [README](scripts/deploy/README.md) for more details on the Bicep Template available for provisioning the Databricks workspace.