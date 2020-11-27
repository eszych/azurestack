$VMpwd = 'Pa$$w0rd4D3ll'
$sqlServerInstance = '(localdb)\MSSQLLocalDB'
$secureVMpwd = ConvertTo-SecureString -AsPlainText $VMpwd -Force
$databaseName = 'AzSPoC'
$tableName = "Progress"

$AzSPoCSqlLoginExists = Get-SqlLogin -ServerInstance $sqlServerInstance -LoginName "azspocadmin" -ErrorAction SilentlyContinue | Out-String
if (!$AzSPoCSqlLoginExists) {
    $sqlLocalDbAdmin = "azspocadmin"
    $sqlLocalDbCreds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $sqlLocalDbAdmin, $secureVMpwd -ErrorAction Stop
    Add-SqlLogin -ServerInstance $sqlServerInstance -LoginName "azspocadmin" -LoginPSCredential $sqlLocalDbCreds -LoginType SqlLogin -DefaultDatabase "AzSPoC" -Enable -GrantConnectSql -ErrorAction SilentlyContinue -Verbose:$false
} else {
    Write-Host "The AzSPoC Admin Login already exists. No need to recreate."
}

Invoke-Sqlcmd -ServerInstance $sqlServerInstance -Database AzSPoC -Query "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES"
Invoke-Sqlcmd -ServerInstance $sqlServerInstance -Database AzSPoC -Query "SELECT st.name AS TableName, sc.name AS ColumnName FROM sys.tables AS st INNER JOIN sys.columns sc ON st.OBJECT_ID = sc.OBJECT_ID ORDER BY st.name, sc.name"

Invoke-Sqlcmd -ServerInstance $sqlServerInstance -Database AzSPoC -Query "SELECT * FROM Progress"
Invoke-Sqlcmd -ServerInstance $sqlServerInstance -Database AzSPoC -Query "UPDATE Progress SET SQLServerGalleryItem ='Incomplete'"
Invoke-Sqlcmd -ServerInstance $sqlServerInstance -Database AzSPoC -Query "SELECT UbuntuServerImage FROM Progress"


#before recreating the table with new values drop the Table
$AzSPoCSqlTableExists = Read-SqlTableData -ServerInstance $sqlServerInstance -DatabaseName "$databaseName" -SchemaName "dbo" -TableName "$tableName" -ErrorAction SilentlyContinue | Out-String
if ($AzSPoCSqlTableExists) {
    Invoke-Sqlcmd -ServerInstance $sqlServerInstance -Database AzSPoC -Query "Drop Table Progress"
}

$progressHashTable = [ordered]@{
    GetScripts           = "Complete";
    CheckPowerShell      = "Complete";
    InstallPowerShell    = "Complete";
    DownloadTools        = "Complete";
    CheckCerts           = "Skipped";
    HostConfiguration    = "Complete";
    Registration         = "Complete";
    AdminPlanOffer       = "Complete";
    UbuntuServerImage    = "Complete";
    WindowsUpdates       = "Complete";
    ServerCore2016Image  = "Complete";
    ServerFull2016Image  = "Complete";
    ServerCore2019Image  = "Complete";
    ServerFull2019Image  = "Complete";
    MySQL57GalleryItem   = "Complete";
    MySQL80GalleryItem   = "Complete";
    SQLServerGalleryItem = "Complete";
    AddVMExtensions      = "Complete";
    MySQLRP              = "Incomplete";
    SQLServerRP          = "Incomplete";
    MySQLSKUQuota        = "Incomplete";
    SQLServerSKUQuota    = "Incomplete";
    UploadScripts        = "Complete";
    MySQLDBVM            = "Incomplete";
    SQLServerDBVM        = "Incomplete";
    MySQLAddHosting      = "Incomplete";
    SQLServerAddHosting  = "Incomplete";
    AppServiceFileServer = "Incomplete";
    AppServiceSQLServer  = "Incomplete";
    DownloadAppService   = "Incomplete";
    AddAppServicePreReqs = "Incomplete";
    DeployAppService     = "Incomplete";
    RegisterNewRPs       = "Complete";
    UserPlanOffer        = "Complete";
    InstallHostApps      = "Complete";
    CreateOutput         = "Complete";
}

$progressHashTable.ForEach( { $_.ForEach( { [PSCustomObject]$_ }) }) | Format-Table
$progressHashTable.ForEach( { $_.ForEach( { [PSCustomObject]$_ }) }) | Get-Member

# The SQL Server database already exists, but not the table. The Force parameter creates the table automatically:
$progressHashTable.ForEach( { $_.ForEach( { [PSCustomObject]$_ }) | Write-SqlTableData -ServerInstance $sqlServerInstance `
            -DatabaseName $databaseName -SchemaName dbo -TableName $tableName -Force -ErrorAction Stop -Verbose })

$AzSPoCSqlTable = Read-SqlTableData -ServerInstance $sqlServerInstance -DatabaseName "$databaseName" -SchemaName "dbo" -TableName "$tableName" -ErrorAction SilentlyContinue | Out-String
$AzSPoCSqlTable




