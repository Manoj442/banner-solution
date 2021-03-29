
function Add-SPBanner($SiteUrl, $Credentials)
{
   Connect-PnPOnline -url $SiteUrl -UseWebLogin
  $context = Get-PnPContext  
  #$context.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Credentials.UserName,$Credentials.Password)
  $site = $context.Web
  $context.Load($site)
  $context.ExecuteQuery()
  $UserCustomActions = $site.UserCustomActions
  $context.Load($UserCustomActions)
  $context.ExecuteQuery()

  #add custom js injection action
  $customJSAction = $UserCustomActions.Add()
  $customJSAction.Location = “ScriptLink”
  #reference to JS file
  $customJSAction.ScriptSrc = “/SiteAssets/js/index.js”
  #load it last
  $customJSAction.Title= “banner"
  $customJSAction.Sequence = 1000
  #make the changes
  $customJSAction.Update()
  $context.ExecuteQuery()

  #add jquery injection action
  <#$customJSAction = $UserCustomActions.Add()
  $customJSAction.Location = “ScriptLink”
  #reference to JS file
  $customJSAction.ScriptSrc = “/SiteAssets/js/jquery.min.js”
  #load it last
  $customJSAction.Title= “jquery"
  $customJSAction.Sequence = 1000
  #make the changes
  $customJSAction.Update()
  $context.ExecuteQuery()
  #>

   #add custom js injection action
  <#$CSSURL="/SiteAssets/css/style.css";
  
  $customJSAction = $UserCustomActions.Add()
  $customJSAction.Location = “ScriptLink”
  #reference to JS file
  $customJSAction.ScriptBlock = "document.write('<link rel=""stylesheet"" href=""$($CSSURL)"" crossorigin=""anonymous"" type=""text/css""/>')"
  #load it last
  $customJSAction.Title= “css for Banner"
  $customJSAction.Sequence = 1000
  #make the changes
  $customJSAction.Update()
  $context.ExecuteQuery()
  #>
  

  Write-Host “Banner has been Added…” -ForegroundColor Green
}
function Remove-SPBanner($SiteUrl, $Credentials)
{
  $context = New-Object Microsoft.SharePoint.Client.ClientContext($SiteUrl)
  $context.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Credentials.UserName,$Credentials.Password)
  $site = $context.Web
  $context.Load($site)
  $context.ExecuteQuery()
  $UserCustomActions = $site.UserCustomActions
  $context.Load($UserCustomActions)
  $context.ExecuteQuery()
  $UserCustomActions  | Select Title, Sequence
  if($UserCustomActions.Count -gt 0)
  {
    for ($i=0;$i -lt $UserCustomActions.Count;$i++)
    {
    $CA =$UserCustomActions[$i]
    $CA.DeleteObject()
    $context.ExecuteQuery()
    Write-Host “Banner has been Removed…” -ForegroundColor Green
  }
}
}
#$Creds = Get-Credential
$SiteUrl = “https://captureclicks.sharepoint.com/sites/ccTeamsClassic/”
Add-SPBanner -SiteUrl $SiteUrl -Credentials $Creds