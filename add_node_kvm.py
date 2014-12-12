#!/usr/bin/python
#create table nodes(id INTEGER PRIMARY KEY AUTOINCREMENT, name char(30));
import sqlite3
import sys
import subprocess
import os

def mac_from_id(id):
	return "aa:bb:cc:dd:ee:%02d"%(id+2)
def ip_from_id(id):
	return "10.13.0.%d"%(id+10)


#if len(sys.argv)<2:
#	print "Podaj nazwe"
#	sys.exit(-1)
conn = sqlite3.connect('/home/mgr/SZZ/nodes.db')
c = conn.cursor()

last = c.execute('select max(id) from nodes').fetchone()[0]
if not last:
	last = 0
last += 1
last = str(last).zfill(2)
print last


c.execute("insert into nodes(name) values ('mgr{num}')".format(num=last))
conn.commit()

hosts = """127.0.0.1 localhost
127.0.1.1 mgr0
10.13.0.250 lxc
"""
dns = """ddns-update-style none;
option domain-name "example.org";
option domain-name-servers ns1.example.org, ns2.example.org;

default-lease-time 60;
max-lease-time 60;
log-facility local7;
subnet 10.13.0.0 netmask 255.255.255.0 {
default-lease-time 60;
max-lease-time 60;
range 10.13.0.110 10.13.0.200;
option routers 10.13.0.1;
option domain-name-servers 10.13.0.1;
}
host lxc {
hardware ethernet 52:54:00:6f:da:68;
fixed-address 10.13.0.250;
max-lease-time 7200;
default-lease-time 7200;
option host-name "lxc";
}
"""

c.execute("select id,name from nodes")
for n in c:
	hosts += "{ip} {name}\n".format(name=n[1], ip=ip_from_id(n[0]))
	dns += "host {name} {{\nhardware ethernet {mac};\nfixed-address {ip};\nmax-lease-time 7200;\ndefault-lease-time 7200;\noption host-name \"{name}\";\n}}\n".format(mac=mac_from_id(n[0]), ip=ip_from_id(n[0]),name=n[1])
	#dns += "host mgr{idd} {\nhardware ethernet {mac};\nfixed-address {ip};\n}".format(idd=n[0]+1, mac=n[2], ip=n[1])
with open('/etc/hosts', 'w') as plik:
	plik.write(hosts)
#	print dns
with open('/etc/dhcp/dhcpd.conf', 'w') as plik:
	plik.write(dns)
os.system("pkill dhcpd")
#os.system("/etc/init.d/isc-dhcp-server restart")
os.system("virt-clone --connect qemu+ssh://torgiren@10.13.0.1:2233/system --auto-clone -m {mac} -o mgr_template_new -n mgr{num}".format(mac=mac_from_id(n[0]), num=last))
os.system("virsh --connect qemu+ssh://torgiren@10.13.0.1:2233/system start mgr{num}".format(num=last))
#os.system("ssh root@lxc lxc-clone mgr_template mgr{num}".format(num=last))
#os.system("ssh root@lxc \"sed -i 's/lxc.network.hwaddr.*/lxc.network.hwaddr = {mac}/' /var/lib/lxc/mgr{num}/config\"".format(mac=mac_from_id(n[0]), num=last))
#os.system("ssh root@lxc lxc-start -d -n mgr{num}".format(num=last))
