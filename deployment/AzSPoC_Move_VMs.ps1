$movevms = @("AzS-DC01","AzS-ERCS01","AzS-SRNG01")

$targetpath = "C:\ClusterStorage\SU1_Volume\Shares\SU1_Infrastructure_1\1.2008.0.59"
Set-Location $targetpath 

foreach ($i in $movevms){
   Write-Host $i 
   New-Item -Path $targetpath -Name $i -ItemType "directory" -ErrorAction SilentlyContinue

   $vmtomove = Get-VM -Name $i
   $vmtargetpath = $targetpath+"\"+$i

   write-host "Moving VM" $i "from" $vmtomove.ConfigurationLocation
   write-host "to" $vmtargetpath
   Write-Host .
   
   Move-VMStorage -VM $vmtomove -DestinationStoragePath $vmtargetpath -ErrorAction Stop
}


