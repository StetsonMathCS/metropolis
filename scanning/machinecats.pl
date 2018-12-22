
% guess machine category based on ports/software

% grab port software
portsw(host(_, _, _, Ports), PortNum, Software) :-
    member(port(PortNum, _, _, _, _, _, Software), Ports).

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

