function Add-Banner($siteUrl){
try{
Connect-PnPOnline -Url $siteUrl -UseWebLogin

#This command will get the Application installed on the tenant app catalog and install it on the current site
#Get-PnPApp -Identity e3de670a-8155-469a-a4e2-164d6fa3b7d5 | Install-PnPApp -Wait
#Uninstall-PnPApp -Identity e3de670a-8155-469a-a4e2-164d6fa3b7d5
$app = Get-PnPApp -Identity e3de670a-8155-469a-a4e2-164d6fa3b7d5
$app | ForEach-Object{
$_.InstalledVersion
if($_.InstalledVersion){
$appCustomizer = Get-PnPApplicationCustomizer -ClientSideComponentId 600ee604-34c9-4a99-ba68-034fe838dc34
if($appCustomizer){
    Write-Host -ForegroundColor Yellow "Application Customizer is already available!"
}
else{
    Add-PnPApplicationCustomizer -Title "TopBanner" -ClientSideComponentId 600ee604-34c9-4a99-ba68-034fe838dc34 -Scope Web -ClientSideComponentProperties "{`"testMessage`":`"Test Message`"}"
    Write-Host -ForegroundColor Green "Application Customizer is added successfully!"
}
    
}
else{
     Get-PnPApp -Identity e3de670a-8155-469a-a4e2-164d6fa3b7d5 | Install-PnPApp -Wait
     Write-Host -ForegroundColor Green "Application Customizer is added successfully!"
}
}
#Write-Host -ForegroundColor Green "Application Customizer is added successfully!"

}
catch{
   Write-Host "`Error Message: " $_.Exception.Message
   Write-Host "`Error in Line: " $_.InvocationInfo.Line
   Write-Host "`Error in Line Number: "$_.InvocationInfo.ScriptLineNumber
   Write-Host "`Error Item Name: "$_.Exception.ItemName
}

}

function Remove-Banner($siteUrl){
Connect-PnPOnline -Url $siteUrl -UseWebLogin
$appCustomizer = Get-PnPApplicationCustomizer -ClientSideComponentId 600ee604-34c9-4a99-ba68-034fe838dc34 -Scope web
if($appCustomizer){
Remove-PnPApplicationCustomizer -ClientSideComponentId 600ee604-34c9-4a99-ba68-034fe838dc34 -Scope web
Write-Host -ForegroundColor Green "Application Customizer is removed successfully!"  
}
else{
Write-Host -ForegroundColor Red "Application Customizer specified is not found!"
}
}
$path = "C:\banner-files\sites.csv"
Import-Csv -Path $path | ForEach-Object {
Add-Banner $_.Sites
#Remove-Banner $-.Sites
}
#Add-Banner
#Remove-Banner
