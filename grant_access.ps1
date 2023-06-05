$list_user = (Get-LocalGroupMember -Group "Administrators").Name
if($list_user.Contains("APAC\TAD6HC") -eq $false)
{
    Add-LocalGroupMember -Group "Administrators" -Member "APAC\TAD6HC"
}