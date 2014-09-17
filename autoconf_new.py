#!/usr/bin/env python
import subprocess
import sqlite3
import os
def pool_to_static(ip):
	a = ip.split('.')
	if(int(a[3])>100):
		a[3] = str(int(a[3]) - 100)
	return ".".join(a)
conn = sqlite3.connect('/home/mgr/SZZ/baza.db')
c = conn.cursor()
a = subprocess.check_output(['/usr/sbin/arp -n|grep ether'], shell=True)
b = [(i.split()[0], i.split()[2]) for i in a[:-1].split('\n') if i.split()[0] != "10.13.0.1"]
nowy = False
for node in b:
	print node
	c.execute('select id from nodes where mac = "{mac}";'.format(mac=node[1]))
	if not c.fetchone():
		c.execute('insert into nodes(mac,ip) values("{mac}","{ip}")'.format(mac=node[1],ip=pool_to_static(node[0])))
		print "Dodaje"
		conn.commit()
		nowy = True
if nowy:
	hosts = """127.0.0.1 localhost
127.0.1.1 mgr0
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
"""

	c.execute("select id,ip,mac from nodes")
	for n in c:
		hosts += "{ip} mgr{idd}\n".format(idd=int(n[0])+1, ip=n[1])
		dns += "host mgr{idd} {{\nhardware ethernet {mac};\nfixed-address {ip};\nmax-lease-time 7200;\ndefault-lease-time 7200;\noption host-name \"mgr{idd}\";\n}}\n".format(idd=int(n[0])+1, mac=n[2], ip=n[1])
		#dns += "host mgr{idd} {\nhardware ethernet {mac};\nfixed-address {ip};\n}".format(idd=n[0]+1, mac=n[2], ip=n[1])
	with open('/etc/hosts', 'w') as plik:
		plik.write(hosts)
#	print dns
	with open('/etc/dhcp/dhcpd.conf', 'w') as plik:
		plik.write(dns)
	os.system("/etc/init.d/isc-dhcp-server restart")
