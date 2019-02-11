Clear-Host
$files = Get-ChildItem -Include *.jsp -Recurse
$debugLevel = 1
foreach($file in $files)
{
   'File Name:'+$file.FullName

   $fileCounter = 0
   $lineCounter = 0
   $LineChanged = 0

   $fileContents = Get-Content -Path $file
   $fileContents_orig=$fileContents -replace '\s'

   foreach($line in $fileContents){


        $lineBeforeChange = $line
		
		if($line -match '\s?(type|language)=["'']?(text\/javascript|text\/jscript|javascript|jscript)["'']'){
             $line=$line -replace '\s?(type|language)=["'']?(text\/javascript|text\/jscript|javascript|jscript)["'']', ''
        }

        if($line -match '(\s*|(\s*(.|#)[\w-]*{\s*))valign\s*(:|=)\s*'){
             $line=$line -replace 'valign', 'vertical-align'
        }
		
		if($line -match '(\s*|(\s*(.|#)[\w-]*{\s*))[^-]align\s*(:|=)\s*'){
             $line=$line -replace '[^-]align', ' text-align'
        }
		
		if($line -match '(\s*|(\s*(.|#)[\w-]*{\s*))frameborder\s*(:|=)\s*'){
             $line=$line -replace 'frameborder', ' border'
        }
		
		if($line -match 'window.close\s*\(\)'){
             $line=$line -replace 'window.close\s*\(\)', '_gSUI_SFrame.closeDialog()'
        }
		
        if($line -match '(\s*|(\s*(.|#)[\w-]*{\s*))cellspacing\s*(=|:)\s*'){
             $line=$line -replace '(\s*|(\s*(.|#)[\w-]*{\s*))cellspacing\s*', ' border-spacing'
        }

        if($line -match ('<!--\s*') -or ('\s*-->')){#for changing comment format
        $line= $line -replace '<!--', '/*'
        $line=$line -replace '-->', '*/'
        }

        if($line -match '(\s*|(\s*(.|#)[\w-]*{\s*))cursor\s*:\s*hand\s*(;|})'){#for changing hand to pointer
        $line=$line -replace 'cursor\s*:\s*hand\s*', 'cursor:pointer'
        }
        if($line -match '(\s*|(\s*(.|#)[\w-]*{\s*))cursor\s*:\s*arrow\s*(;|})'){#for changing arrow to default
        $line=$line -replace 'cursor\s*:\s*arrow\s*', 'cursor:default'
        }
        if($line -match '(\s*|(\s*(.|#)[\w-]*{\s*))scroll\s*:\s*no\s*(;|})'){#for changing arrow to default
        $line=$line -replace 'scroll\s*:\s*no\s*', 'overflow:hidden'
        }
        #To convert vertical-align:center to vertical-align:middle
	     if($line -match '\s*vertical-align\s*:\s*center\s*'){ 
             $line=$line -replace '\s*center\s*', 'middle' 
        }
        #To remove ; after }
	     if($line -match '\s*}\s*;\s*'){ 
             $line=$line -replace ';' 
        }
        #To convert font-color to color
	     if($line -match '\s*font-color\s*:\s*'){ 
             $line=$line -replace 'font-color', 'color' 
        }

        if($line -match '((\b[\w-]*\b\s*:\s*"\s*[\d]*)\s*([\w-]*|%)\s*"\s*(;|}))|((\b[\w-]*\b\s*:\s*[\d]*)\s*(;|}))|((\b[\w-]*\b\s*=\s*[\d]*)\s*(;|}))'){
            $line=$line -replace '"'
            $line=$line -replace '=',':'
            $cssProperties = $line.Split(';{}')
            foreach($property in $cssProperties){
                if($property.ToLower() -match 'z-index'-or $property.ToLower() -match 'font-size' -or $property.ToLower() -match
                 'line-height' -or $property -match 'border\s*:\s*'){
                    # Do nothing
                }elseif ($property -match '^\s*(\b[\w-]*\b\s*:\s*[\d]+)\s*$' ){
                $property.Split(':')


                    if(!($property.Split(':')[1].Trim() -eq "0")){
                        $line = $line.Replace($property,$property.TrimEnd()+'px')

                    }
                }

            }
        }

        if($line -match '(border-width|margin|padding)+\s*:\s*\d+(px|,|\s)+(\d+)+'){#for pattern border*: 1 1 1 1;
            $cssProperties = $line.Split(';{}')
            foreach($property in $cssProperties){
                    if($property -match '^\s*(border-width|margin|padding)+\s*:\s*\d+(px|,|\s)+(\d+)+'){
                        $colonSplit = $property.Split(':')
                        if($colonSplit[1]){
                            $valueSplit = $colonSplit[1] -split '\s+|,'
                            $propValues=''
                            foreach($propValue in $valueSplit){
                            if($propValue.Trim().Length -gt 0)
                            {
                                 if(!($propValue -match '(px|pt|em|cm|mm|vh|vw|vmin|in|pc|ex)$')){
                                        if($propValue.Trim() -ne "0" -and !($propValue.Trim() -match 'important')){
                                            $propValues = $propValues + ' '+$propValue+'px'
                                         }else{
                                            $propValues = $propValues + ' '+$propValue
                                         }
                                  }elseif($propValue -match '(\d+)(?>(px|pt|em|cm|mm|vh|vw|vmin|in|pc|ex))'){
                                    $propValues = $propValues + ' '+$propValue
                                  }
                             }
                            }
                            $propString = $colonSplit[0] + ':' + $propValues
                        }

                    $line = $line.Replace($property,$propString)


                }
            }
        }

        if($line -match '(border|border-top|border-bottom|border-right|border-left)\s*:\s*' -and !($line -match 'filter\s*:')){ #for *: border-style width color;
            $cssProperties = $line.Split(';{}')
            foreach($property in $cssProperties){
                    if($property -match '^\s*(border|border-top|border-bottom|border-right|border-left)\s*:\s*'){
                        $colonSplit = $property.Split(':')
                        if($colonSplit[1]){
                            $temp = $colonSplit[1].Trim();
                            $temp = $temp -replace '\b(?<!#)([1-999999])(?!px)\b', "`$1px"
                            $temp = $temp -replace '"'
                            $propString = $colonSplit[0] + ':' + $temp
                        }
                    $line = $line.Replace($property,$propString)

                }
            }
        }




        if($fileContents.GetType().Name -eq 'String'){
            $fileContents = $line
        }else{
            $fileContents.SetValue($line,$lineCounter)
        }
        $lineCounter++

   }


    $fileContents_changed= $fileContents -replace '\s'


    if(Compare-Object $fileContents_changed  $fileContents_orig){
    Write-Host "changing the file"
    $fileContents | Set-Content -Path $file
    $fileCounter++
   }

   #$fileCounter
}
Write-Host 'Done'