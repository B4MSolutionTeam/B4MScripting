$SmtpServer  = "rb-smtp-int.bosch.com"
$parameters = @{
From = ‘Duy.TaThai@vn.bosch.com’
To = ‘an.phamnhat@vn.bosch.com’
Subject = ‘Backup Version Overdate 10 year'
Attachments = @('C:\vdServerAchieve\report.csv')
Body = “Hello, after examine all file backup version, we have discover these files are overdate. Please kindly review and delete these files. Thank you”
BodyAsHTML = $True
Priority = 'High'
SmtpServer = $SmtpServer
}

Send-MailMessage @parameters