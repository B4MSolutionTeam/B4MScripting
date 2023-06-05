################################################################################################
#                                                                                              #
#           source folder                                                                      #
#                                                                                              #
################################################################################################
$MyDir = [System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition)

################################################################################################
#                                                                                              #
#           read config data                                                                   #
#                                                                                              #
################################################################################################

$ExportConfig           =  $MyDir+"\export.txt"
$ConfigContent          =  Get-Content -Path  $ExportConfig
$VDogAutoexportPath     = $ConfigContent[0] -replace "^VDogAutoexportPath=`(.*)`$",'${1}' 
$VDogClientArchivPath   = $ConfigContent[1] -replace "^VDogClientArchivPath=`(.*)`$",'${1}'
$ExportRootPath         = $ConfigContent[2] -replace "^ExportRootPath=`(.*)`$",'${1}'
 if (-Not (Test-Path  $ExportRootPath -PathType Container))
                            {
                              New-Item  $ExportRootPath -ItemType Container
                             }  

################################################################################################
#                                                                                              #
#           read data from config and create ini files                                         #
#                                                                                              #
################################################################################################
$i=3

Do{
   
   $Source                 = $MyDir+"\"+$ConfigContent[$i]+".txt"
   $content                = Get-Content -Path  $Source
   $ReportType             = $content | Select-String -Pattern "^ReportType="
   $ReportType             = $ReportType  -replace "^ReportType=`(.*)`$",'${1}'      
   $LineCount              = (Get-Content $Source | Measure-Object).count
   $regexExportFile        = '[ExportFile]'
   $LineExportFile         = Get-Content $Source |Select-String  -Pattern ([regex]::Escape($regexExportFile)) | Select-Object -ExpandProperty 'LineNumber' 
   $ExportName             = $content[$LineExportFile] -replace "^Name=`(.*)`$",'${1}'
   $regexDirs              = '[ExportElementsDirs]'
   $LineDirs               = Get-Content $Source |Select-String  -Pattern ([regex]::Escape($regexDirs)) | Select-Object -ExpandProperty 'LineNumber'      
 for ($p=$LineDirs;$p -lt $LineCount; $p++)   
                   {          
        for ($t=0; $t -lt $LineExportFile-1 ; $t++ )
                 {                                  
                   
                  
                   $ConstantText  =$ConstantText+$content[$t] +"`r`n"                                    
                   $IniFolder     =$MyDir+"\"+$ConfigContent[$i] 
                  
                    if (-Not (Test-Path  $IniFolder -PathType Container))
                            {
                              New-Item  $IniFolder -ItemType Container
                             }  
                                
              }   

                                                                                                                       
                     $Dir           = $content[$p]                                                                           
                     $ConstantText  = $ConstantText+"Dir="+$Dir+"`r`n"                 
                     $Dirnew        = ($Dir.replace('\','_')).Substring(1)  
                     $ExportFile    ="ExportFile="+$ExportRootPath+"\"+$Dirnew+"_"+$ExportName 
                     $ExportfileName="export_"+$Dirnew +"_$ReportType"                                                
                     $IniText       =$ConstantText+$ExportFile |Out-File -FilePath $IniFolder\$ExportfileName.ini
                     $ConstantText=$null 
                                  
                   }
                          
         
          
     
     
   $i++
  }while ($ConfigContent[$i] -ne $null)
################################################################################################
#                                                                                              #
#          start export module                                                                 #
#                                                                                              #
################################################################################################
$SourceINI = $MyDir 
$INIfilter =".ini"

foreach ($IniPath in Get-ChildItem -Recurse $SourceINI | Where-Object {$_.Name-Match $INIfilter})
{

   $InIFullPath=$IniPath.Fullname 
   #$InIFullPath 
   cmd.exe /c  "$VDogAutoexportPath" "/rd:$VDogClientArchivPath" "/CFile:$InIFullPath" /Account:AutoReport /Password:IPNRep_205157
    

################################################################################################
#                                                                                              #
#          delete .ini files                                                                   #
#                                                                                              #
################################################################################################
   Remove-Item -Path $InIFullPath -Force
}
Start-Sleep -Seconds 2
foreach ($IniFolder in Get-ChildItem  $SourceINI -Directory)
{

   $IniFolderFullPath=$IniFolder.Fullname  
   
################################################################################################
#                                                                                              #
#          delete empty folder                                                                 #
#                                                                                              #
################################################################################################
   Remove-Item -Path $IniFolderFullPath -Force
}