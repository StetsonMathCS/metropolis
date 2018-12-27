
% guess machine category based on ports/software

% grab port protocol
portprotocol(host(_, _, _, Ports), PortNum, Protocol) :-
    member(port(PortNum, _, Protocol, _, _, _, _), Ports).

% grab port service 
portservice(host(_, _, _, Ports), PortNum, Service) :-
    member(port(PortNum, _, _, _, Service, _, _), Ports).

% grab port software
portsw(host(_, _, _, Ports), PortNum, Software) :-
    member(port(PortNum, _, _, _, _, _, Software), Ports).

machinecat(nessus, Host) :-
    Host = host(_, _, _, Ports),
    findall(PortNum, member(port(PortNum, _, _, _, _, _, _), Ports), PortNums),
    ord_union(PortNums, [22, 8000], [22, 8000]), % only these ports
    portsw(Host, 22, SSH),
    re_match("OpenSSH 5.3"/i, SSH),
    portservice(Host, 8000, "ssl|http"),
    portsw(Host, 8000, HTTPS),
    re_match("lighttpd 1.4.47"/i, HTTPS).

machinecat(ciscoswitch, Host) :-
    portsw(Host, 22, SSH),
    re_match("Cisco"/i, SSH).

machinecat(arubawlan, Host) :-
    portsw(Host, 22, SSH),
    re_match("Linksys WRT45G", SSH),
    portsw(Host, 4343, HTTPS),
    re_match("Apache httpd", HTTPS).

machinecat(vmwareesxi, Host) :-
    portsw(Host, 80, HTTP),
    re_match("VMware ESXi Server httpd", HTTP).

