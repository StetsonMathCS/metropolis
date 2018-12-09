
:- set_prolog_flag(double_quotes, codes).
:- set_prolog_flag(back_quotes, string).

readNmapGreppableOutput(Filename, Hosts) :-
    absolute_file_name(Filename, NmapFile),
    read_file_to_codes(NmapFile, NmapCodes, []),
    nmapHosts(Hosts, NmapCodes, []).

nmapHosts([]) --> "".
nmapHosts([]) --> "#", ignoreRestOfLine, newlines.
nmapHosts(Hosts) --> "#", ignoreRestOfLine, newlines, nmapHosts(Hosts).
nmapHosts(Hosts) -->
    "Host: ", ipAddress(_), " (", hostname(_), ")", tabOrSpace, "Status: Down\n", !,
    nmapHosts(Hosts).
nmapHosts(Hosts) -->
    "Host: ", ipAddress(_), " (", hostname(_), ")", tabOrSpace, "Status: Up\n", !,
    nmapHosts(Hosts).
nmapHosts([Host|Hosts]) --> nmapHost(Host), !, nmapHosts(Hosts).

nmapHost(host(IpAddr, Hostname, up, Ports)) -->
    "Host: ", ipAddress(IpAddr), " (", hostname(Hostname), ")\tPorts: ", ports(Ports), !.

port(port(PortNum, State, Protocol, Owner, Service, RpcInfo, Version)) -->
    number(PortNum), "/", nonSlash(StateStr), "/", nonSlash(ProtocolStr), "/",
    nonSlash(Owner), "/", nonSlash(Service), "/", nonSlash(RpcInfo), "/",
    nonSlash(Version), "/", { atom_string(State, StateStr), atom_string(Protocol, ProtocolStr) }.

ports([Port|Ports]) --> port(Port), ", ", ports(Ports).
ports([Port]) --> port(Port), ignoreRestOfLine, newlines.

ipAddress([A,B,C,D]) --> number(A), ".", number(B), ".", number(C), ".", number(D).

hostnameChar(C) --> [C], { dif([C], ")") }.
hostname([]) --> "".
hostname([C|Cs]) --> hostnameChar(C), hostname(Cs).

nonSlashChar(C) --> [C], { dif([C], "/") }.
nonSlash([]) --> "".
nonSlash([C|Cs]) --> nonSlashChar(C), nonSlash(Cs).

newline --> "\n".
newlines --> newline.
newlines --> newline, newlines.

ignoreRestOfLine --> "".
ignoreRestOfLine --> [C], { dif([C], "\n") }, ignoreRestOfLine.

tabOrSpace --> "\t".
tabOrSpace --> " ".

digit(D) --> [D], { code_type(D, digit) }.
digits([D]) --> digit(D).
digits([D|Ds]) --> digit(D), digits(Ds).
number(N) --> digits(Ds), { number_codes(N, Ds) }.

