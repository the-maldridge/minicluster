keep-in-foreground
log-queries
log-facility=-
interface=eno1
no-resolv
server=8.8.8.8
enable-tftp
expand-hosts
dhcp-range=${cidrhost(subnet, 3)},${cidrhost(subnet, 64)},600
dhcp-option=option:router,${cidrhost(subnet, 1)}
dhcp-option=option:dns-server,${cidrhost(subnet, 2)}
dhcp-option=option:netmask,${cidrnetmask(subnet)}
dhcp-option=option:domain-name,lan
dhcp-option=option:T1,300
dhcp-option=option:T2,525
tftp-root=/tftproot
dhcp-userclass=set:ipxe,iPXE
pxe-service=tag:#ipxe,x86PC,'PXE chainload to iPXE',undionly.kpxe
pxe-service=tag:ipxe,x86PC,'iPXE',http://${shoelaces_host}:8081/poll/1/$${netX/mac:hexhyp}
domain=lan
host-record=bootmaster.lan,${cidrhost(subnet,2)}
host-record=metaldata.lan,${cidrhost(subnet,2)}

%{ for hwaddr, host in hosts ~}
dhcp-host=${lower(replace(hwaddr, "-", ":"))},${host.private-ipv4},${host.hostname}
%{ endfor ~}

%{ for host in hosts ~}
host-record=${host.hostname},${host.private-ipv4}
%{ endfor ~}
