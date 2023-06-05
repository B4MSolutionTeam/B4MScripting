$path_keyword = "C:\Firewall\keyword.json"
$path_ITSP_export = "C:\Firewall\template.json"
# $path_ITSP_import = 
$keyword_json = Get-Content -Raw -Path $path_keyword | ConvertFrom-Json
# Write-Host(($keyword_json.'data').'B4M Server Zone')

$ITSP_export_json = Get-Content -Raw -Path $path_ITSP_export | ConvertFrom-Json
foreach ($entry_ITSP in $ITSP_export_json.'data')
{
    $temp_source_itsp = $entry_ITSP.'source'
    $temp_source_keyword = ($keyword_json.'data').$temp_source_itsp
    $entry_ITSP.'source' = $temp_source_keyword 
    
    $temp_dest_itsp = $entry_ITSP.'destination'
    $temp_dest_keyword = ($keyword_json.'data').$temp_dest_itsp
    $entry_ITSP.'destination' = $temp_dest_keyword 

}

$ITSP_export_json | ConvertTo-Json -Depth 100 | Out-File  "C:\Firewall\test.json"