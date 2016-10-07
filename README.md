# DNSTXT-encoder

Scripts for encoding files through DNS TXT records

To encode, use Encode-DnsTxt.ps1, for example:

powershell .\Encode-DnsTxt.ps1 -Domain my.controlled.domain -FileIn dnscat.ps1 -FileOut dnsmasq.conf

Where -Domain is a domain you control. This will spit out a simple dnsmasq configuration file that can just be put in place.
