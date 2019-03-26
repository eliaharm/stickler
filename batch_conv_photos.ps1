
Clear-Host
Set-PSDebug -Off
# get script path and make others relative
$PSScriptRoot # Contains the directory from which the script module is being executed.

## Script variables:
#  Since PS2EXE converts a script to an executable, script related variables are not available anymore. 
# Especially the variable $PSScriptRoot is empty.
#  The variable $MyInvocation is set to other values than in a script.
# You can retrieve the script/executable path independant of compiled/not compiled with the following code 
# (thanks to JacquesFS):
if ($MyInvocation.MyCommand.CommandType -eq "ExternalScript")
{ $ScriptPath = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition }
else
{ $ScriptPath = Split-Path -Parent -Path ([Environment]::GetCommandLineArgs()[0])
    if (!$ScriptPath){ $ScriptPath = "." } }


$v_images_list = "C:\AppsPortable\IMbat\Photos.txt"
$p_convert = "C:\AppsPortable\ImageMagick-7.0.8-14-portable-Q16-x64\convert.exe"
$p_output_dir = "D:\Photos\tmp_photos"
$FILESARRAY = get-content $v_images_list
foreach ($FILE in $FILESARRAY)
{
  $FILE_ext = (Get-Item $FILE ).Extension
  $FILE_Base = (Get-Item $FILE ).Basename
  $FILE_name = (Get-Item $FILE ).Name
  $FILE_dir = (Get-Item $FILE ).DirectoryName
  $FILE_last_dir = (Get-Item $FILE ).DirectoryName|split-path -leaf
  $FILE_full = (Get-Item $FILE ).FullName
  Write-Host "Processing $FILE_name"
  if(!(Test-Path -Path "$p_output_dir\$FILE_last_dir" )){
    New-Item -ItemType directory -Path "$p_output_dir\$FILE_last_dir"|out-null 
  }
  # Elia's original convertion
  # child scope
  #& $p_convert $FILE_full -normalize -sigmoidal-contrast 2.5 -colorspace HCL -channel g -sigmoidal-contrast 2.5,0% +channel -colorspace sRGB +repage -colorspace RGB -filter Lanczos -define filter:lobes=2 -define filter:blur=0.88451002338585141 -resize "2200x2200>" -colorspace sRGB -quality 92 "$p_output_dir\$FILE_last_dir\$FILE_name"
  # current scope
  #. $p_convert $FILE_full -normalize -sigmoidal-contrast 2.5 -colorspace HCL -channel g -sigmoidal-contrast 2.5,0% +channel -colorspace sRGB +repage -colorspace RGB -filter Lanczos -define filter:lobes=2 -define filter:blur=0.88451002338585141 -resize "2200x2200>" -colorspace sRGB -quality 92 "$p_output_dir\$FILE_last_dir\$FILE_name"

   $dddd = $p_convert+" "+$FILE_full+" -normalize -sigmoidal-contrast 2.5 -colorspace HCL -channel g -sigmoidal-contrast 2.5,0% +channel -colorspace sRGB +repage -colorspace RGB -filter Lanczos -define filter:lobes=2 -define filter:blur=0.88451002338585141 -resize `"2200x2200>`" -colorspace sRGB -quality 92 "+"`"$p_output_dir\$FILE_last_dir\$FILE_name`""
   
   #invoke-expression $dddd
   #Start-Process $dddd

   $cmdOutput = invoke-expression $dddd | Out-String
   $cmdOutput
   $cmdOutput

}

$NULL = Read-Host "Press enter to exit"
