## Bind9 for Docker running on Alpine 3.6

### Command to use with this image:
```
docker run -d --name bind9 -p 53:53 -p 53:53/udp -v /absolute/paht/named.conf:/etc/bind/named.conf -v /absolute/path/exemple.com.db:/etc/bind/exemple.com.db resystit/bind9:latest
```
**You can add directory or several files with the -v option.**

### Authoritative nameserver
This is a small basic file named.conf if you want to run bind as an
authoritative nameserver:
```
options {
        directory "/var/bind";

        // Configure the IPs to listen on here.
        listen-on { 127.0.0.1; };
        listen-on-v6 { none; };

        // If you want to allow only specific hosts to use the DNS server:
        //allow-query {
        //      127.0.0.1;
        //};

        // Specify a list of IPs/masks to allow zone transfers to here.
        //
        // You can override this on a per-zone basis by specifying this inside a zone
        // block.
        //
        // Warning: Removing this block will cause BIND to revert to its default
        //          behaviour of allowing zone transfers to any host (!).
        allow-transfer {
                none;
        };

        // If you have problems and are behind a firewall:
        //query-source address * port 53;

        pid-file "/var/run/named/named.pid";

        // Changing this is NOT RECOMMENDED; see the notes above and in
        // named.conf.recursive.
        allow-recursion { none; };
        recursion no;
};

// Example of how to configure a zone for which this server is the master:
//zone "example.com" IN {
//      type master;
//      file "/etc/bind/master/example.com";
//};

// You can include files:
//include "/etc/bind/example.conf";
```


### Recursive DNS resolver
This is a small basic file named.conf if you want to run bind as a
recursive DNS resolver:
```
options {
        directory "/var/bind";

        // Specify a list of CIDR masks which should be allowed to issue recursive
        // queries to the DNS server. Do NOT specify 0.0.0.0/0 here; see above.
        allow-recursion {
                127.0.0.1/32;
        };

        // If you want this resolver to itself resolve via means of another recursive
        // resolver, uncomment this block and specify the IP addresses of the desired
        // upstream resolvers.
        //forwarders {
        //      123.123.123.123;
        //      123.123.123.123;
        //};

        // By default the resolver will attempt to perform recursive resolution itself
        // if the forwarders are unavailable. If you want this resolver to fail outright
        // if the upstream resolvers are unavailable, uncomment this directive.
        //forward only;

        // Configure the IPs to listen on here.
        listen-on { 127.0.0.1; };
        listen-on-v6 { none; };

        // If you have problems and are behind a firewall:
        //query-source address * port 53;

        pid-file "/var/run/named/named.pid";

        // Removing this block will cause BIND to revert to its default behaviour
        // of allowing zone transfers to any host (!). There is no need to allow zone
        // transfers when operating as a recursive resolver.
        allow-transfer { none; };
};

// Briefly, a zone which has been declared delegation-only will be effectively
// limited to containing NS RRs for subdomains, but no actual data beyond its
// own apex (for example, its SOA RR and apex NS RRset). This can be used to
// filter out "wildcard" or "synthesized" data from NAT boxes or from
// authoritative name servers whose undelegated (in-zone) data is of no
// interest.
// See http://www.isc.org/products/BIND/delegation-only.html for more info

//zone "COM" { type delegation-only; };
//zone "NET" { type delegation-only; };

zone "." IN {
        type hint;
        file "named.ca";
};

zone "localhost" IN {
        type master;
        file "pri/localhost.zone";
        allow-update { none; };
        notify no;
};

zone "127.in-addr.arpa" IN {
        type master;
        file "pri/127.zone";
        allow-update { none; };
        notify no;
};
```
