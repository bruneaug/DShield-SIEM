# Firewall Example
<pre>
:INPUT DROP [0:0]
:FORWARD DROP [0:0]
:OUTPUT ACCEPT [0:0]

# allow all on loopback
-A INPUT -i lo -j ACCEPT
# allow all for established connections
-A INPUT -i ens3 -m state --state ESTABLISHED,RELATED -j ACCEPT
# add rule to allow for custom rules
-A INPUT -j LOCALINPUT
-A LOCALINPUT -j RETURN
# allow ping from local network
-A INPUT -i ens3 -s 192.168.152.149/32 -p icmp -m icmp --icmp-type 8 -j ACCEPT
# START: IPs / Ports honeypot should be disabled for
-A INPUT -i ens3 -s 192.168.152.149/32 -p tcp --dport 2222 -j REJECT
-A INPUT -i ens3 -s 192.168.152.149/32 -p tcp --dport 2223 -j REJECT
-A INPUT -i ens3 -s 192.168.152.149/32 -p tcp --dport 8000 -j REJECT
-A INPUT -i ens3 -s <b>XX.XX.13.214</b> -p tcp --dport 2222 -j REJECT
-A INPUT -i ens3 -s <b>XX.XX.13.214</b> -p tcp --dport 2223 -j REJECT
-A INPUT -i ens3 -s <b>XX.XX.13.214</b> -p tcp --dport 8000 -j REJECT
# END: IPs / Ports honeypot should be disabled for
# START: allow access to admin ports for local IPs
-A INPUT -i ens3 -s 192.168.152.149/32 -p tcp --dport 12222 -j ACCEPT
-A INPUT -i ens3 -s <b>XX.XX.13.214</b> -p tcp --dport 12222 -j ACCEPT
# END: allow access to admin ports for local IPs
# START: Ports honeypot should be enabled for
-A INPUT -i ens3 -p tcp --dport 2222 -j ACCEPT
-A INPUT -i ens3 -p tcp --dport 2223 -j ACCEPT
-A INPUT -i ens3 -p tcp --dport 8000 -j ACCEPT
# END: Ports honeypot should be enabled for
COMMIT
*nat
:PREROUTING ACCEPT [0:0]
:INPUT ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
# ignore multicasts, no logging
-A PREROUTING -i ens3 -m pkttype --pkt-type multicast -j RETURN
# ignore broadcast, no logging
-A PREROUTING -i ens3 -d 255.255.255.255 -j RETURN
# START: IPs firewall logging should be disabled for
-A PREROUTING -i ens3 -s 192.168.152.149/32 -j RETURN
-A PREROUTING -i ens3 -s <b>XX.XX.13.214</b> -j RETURN
# END: IPs firewall logging should be disabled for
# log all traffic with original ports, but exclude traffic from unused/private IPs.
-N DSHIELDLOG
-A DSHIELDLOG -s 10.0.0.0/8 -j RETURN
-A DSHIELDLOG -s 100.64.0.0/10 -j RETURN
-A DSHIELDLOG -s 127.0.0.0/8 -j RETURN
-A DSHIELDLOG -s 169.254.0.0/16 -j RETURN
-A DSHIELDLOG -s 172.16.0.0/12 -j RETURN
-A DSHIELDLOG -s 192.0.0.0/24 -j RETURN
-A DSHIELDLOG -s 192.0.2.0/24 -j RETURN
-A DSHIELDLOG -s 192.168.0.0/16 -j RETURN
-A DSHIELDLOG -s 224.0.0.0/4 -j RETURN
-A DSHIELDLOG -s 240.0.0.0/4 -j RETURN
-A DSHIELDLOG -s 255.255.255.255/32 -j RETURN
-A DSHIELDLOG -j LOG --log-prefix " DSHIELDINPUT "
-A DSHIELDLOG -j RETURN
-A PREROUTING -i ens3 -m state --state NEW,INVALID -j DSHIELDLOG
# redirect honeypot ports
# - ssh ports
-A PREROUTING -p tcp -m tcp --dport 22 -j REDIRECT --to-ports 2222
# - telnet ports
-A PREROUTING -p tcp -m tcp --dport 23 -j REDIRECT --to-ports 2223
-A PREROUTING -p tcp -m tcp --dport 2323 -j REDIRECT --to-ports 2223
# - web ports
-A PREROUTING -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 8000
-A PREROUTING -p tcp -m tcp --dport 8080 -j REDIRECT --to-ports 8000
-A PREROUTING -p tcp -m tcp --dport 7547 -j REDIRECT --to-ports 8000
-A PREROUTING -p tcp -m tcp --dport 5555 -j REDIRECT --to-ports 8000
-A PREROUTING -p tcp -m tcp --dport 9000 -j REDIRECT --to-ports 8000
COMMIT
</pre>
