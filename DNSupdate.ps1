$VMs = $env:VMDisplayNames -split ","

foreach ($vm in $VMs) {
    # Example: Update DNS record
    dnscmd /recorddelete yourdomain.local $vm A
    dnscmd /recordadd yourdomain.local $vm A 192.168.100.10
}
