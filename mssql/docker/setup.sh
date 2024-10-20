#! /bin/zsh

# Create latest Microsoft SQL Server 2022 image
docker pull mcr.microsoft.com/mssql/server:2022-latest

# Run the container for first time (password using default password)
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=$sqlAdminOriginalPassword" \
   -p 1433:1433 --name $sqlServerName --hostname $sqlServerName \
   -d \
   mcr.microsoft.com/mssql/server:2022-latest

# Run bash shell to connect to SQL server
docker exec -it ${sqlServerName} "bash"

# Login to SQL server via sqlcmd
/opt/mssql-tools18/bin/sqlcmd -S $sqlServerName -U sa -P $sqlAdminOriginalPassword -NO

# Create alternative admin account
CREATE LOGIN $sqlAdminAlternativeName WITH PASSWORD = $sqlAdminAlternativePassword;
GO

# Grant admin permissions
ALTER SERVER ROLE [sysadmin] ADD MEMBER $sqlAdminAlternativeName;
GO

# Log out of original admin account
exit

# Log into SQL server with new alternative admin account
/opt/mssql-tools18/bin/sqlcmd -S $sqlServerName -U $sqlAdminAlternativeName -P $sqlAdminPassword -NO

# Rename original admin account
ALTER LOGIN [sa]
WITH NAME = $sqlAdminOriginalRename;
GO

# Disable SA account
ALTER LOGIN $sqlAdminOriginalRename
DISABLE;
GO

# Logout of SQL server and bash
exit