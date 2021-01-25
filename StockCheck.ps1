# 10/11/2018 - Jeff Ferguson
# http://www.jeff-ferguson.com
# URL checking script
# 
# Description
# This script downloads web pages to compare against previous downloads to see if content has changed.
# If it has changed, an email is sent to the recipient with the information
#
# Instructions
# Change variables on lines containing file paths and login credentials. These are marked with CHANGE below.

#CHANGE
#Path to CSV file
$list = import-csv "C:\temp\check-url\list.csv"

#CHANGE
#Email info
$EmailFrom = "from@email.com"
$EmailTo = "to@gmail.com"
$Subject = "URL Change Update"
$SMTPServer = "mail.yourprovider.com" 
while($true) {
foreach ($item in $list)
{
    $id = $item.("ID")
    $title = $item.("Title")
    $url = $item.("URL")

    #CHANGE
    #Customize these paths
    $newfile = "C:\temp\check-url\$id.old"
    $oldfile = "C:\temp\check-url\$id.new"

    Invoke-WebRequest -Uri $url -OutFile $newfile

    

    $SEL = Select-String -Path $newfile -Pattern "FREE delivery available"

    #if ((compare-object (get-content $newfile ) (get-content $oldfile )) -ne $null)
if ($SEL -ne $null)
    {
        #URL changed, let's tell the world
        #$Body = "$title - $url"
        #$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587) 
        #$SMTPClient.EnableSsl = $true 
        echo "Page updated - $title - $id"
        start chrome $url
         [console]::beep(500,1000)
         $date = Get-Date
         echo $date
        #CHANGE
        #Change credentials in the following string
        #$SMTPClient.Credentials = New-Object System.Net.NetworkCredential("user@email.com", "Password12345!"); 
        Start-Sleep -s 600
        #$SMTPClient.Send($EmailFrom, $EmailTo, $Subject, $Body)
    }
    Else
   {
        #nothing changed - do nothing
      
        
    }

#copy new to old so we can compare against it again
copy $newfile $oldfile
}

$sleeptime = Get-Random -Minimum 20 -Maximum 40
echo "Waiting for $sleeptime seconds"
Start-Sleep -s $sleeptime
}