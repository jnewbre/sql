#! /bin/zsh

# Create latest Microsoft SQL Server 2022 image
docker pull mcr.microsoft.com/mssql/server:2022-latest

# Run the container for first time (password using default password)
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=${password}" \
   -p 1433:1433 --name sql1 --hostname sql1 \
   -d \
   mcr.microsoft.com/mssql/server:2022-latest