# This powershell script parses your prisma logs and outputs to csv user, user logout, user login, and session expire. 
# The Prisma Access VPN provides a secure connection between your computing device and the cloud VPN gateway using the GlobalProtect VPN client

$path = "C:\users\user\Documents\prisma.txt"
$destPath = "C:\users\user\Documents\vpnaudit.csv"

$ipAddress = '(?:(?:1\d\d|2[0-5][0-5]|2[0-4]\d|0?[1-9]\d|0?0?\d)\.){3}(?:1\d\d|2[0-5][0-5]|2[0-4]\d|0?[1-9]\d|0?0?\d)'
$email = '[A-Za-z]*\@company\.com'
$globalLogs = "*GLOBALPROTECT*" #all pertinent lines will have GLOBALPROTECT in them
$connected = "*gateway-connected,connected*"
$clientLogOut = "*gateway-logout,logout*client logout*"
$sessionExpire = "*gateway-logout,logout*user session expired*"

write-output "" | out-file $destPath

write-host "Working on File"
$read = [IO.File]::OpenText($path) #will read as a data stream instead of one big file
while ($read.Peek() -ge 0){
$line = $read.readline()

if($line -like $globalLogs){
if(($line -like $connected) -or ($line -like $clientLogOut) -or ($line -like $sessionExpire)){
$IPArray = [regex]::matches($line, $ipAddress).value
$publicIP = $IPArray[1]
$user = [regex]::matches($line, $email).value
$accessTime = $line.Substring(0,15)

if($line -like $connected){
$action = "Connected"
write-output $accessTime','$publicIP','$user','$action | out-file -append $destPath}

if($line -like $clientLogOut){
$action = "User Logged Out"
write-output $accessTime','$publicIP','$user','$action | out-file -append $destPath}

if($line -like $sessionExpire){
$action = "Session Expired"
write-output $accessTime','$publicIP','$user','$action | out-file -append $destPath}
}

}
write-host "Done."





















