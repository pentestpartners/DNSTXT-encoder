# Encode-DnsTxt
# A simple script to spit out a dnsmasq configuration to transfer files
# To a restricted environment.
#
# Script by David Lodge and Ian Williams


param(
	[alias("dns")][string]$Domain="",
	[alias("in")][string]$FileIn="",
	[alias("out")][string]$FileOut="",
	[alias("h")][switch]$Help=$False
)

if ([string]::IsNullorEmpty($Domain)) {
	Write-Output "Mandatory parameter Domain not passed"
	$Help=$True
}

if ([string]::IsNullorEmpty($FileIn)) {
	Write-Output "Mandatory parameter FileIn not passed"
	$Help=$True
}

if ([string]::IsNullorEmpty($FileOut)) {
	Write-Output "Mandatory parameter FileOut not passed"
	$Help=$True
}

if($Help) {
	"
Encode-DnsTxt: Create dnsmasq configuration to transfer files

-Domain <domain>          The domain of the dnscat2 server
-FileIn	<file>            File to be encoded				
-FileOut <file>           File to save dnsmasq configuration to
-Help -h                  Display this help message
	"
	break
}

# Read FileIn and Base64 it
if (-Not (Test-Path -PathType Leaf $FileIn)) {
	Write-Output "File $FileIn does not exist"
	break
}

$bytes=[System.IO.File]::ReadAllBytes($FileIn)
$cooked=[Convert]::ToBase64String($bytes)

# Split it into 254 byte chunks
$o=[regex]::split($cooked, '(.{254})')

# Simple dnsmasq header
{log-facility=/var/log/dnsmasq.log
log-queries
} | Set-Content $FileOut

# Add each line to dnsmasq.conf
$i=1
foreach($item in $o) {
	if ($item.Length -ne 0) {
		$output="txt-record=dnscat" + $i.toString() + ".$Domain," + $item
		$i++
		Write-Output $output | Add-Content $FileOut
	}
}

# Add a count to make it easier
$i--
$output="txt-record=dnscatcount.$domain," + $i.toString() | Add-Content $FileOut

