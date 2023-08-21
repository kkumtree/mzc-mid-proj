# Tailscale(subnet-router)

## How to get CIDRs

```bash
$ kubectl cluster-info dump | grep -m 1 service-cluster-ip-range
                            "--service-cluster-ip-range=10.96.0.0/12",
$ kubectl cluster-info dump | grep -m 1 cluster-cidr
                            "--cluster-cidr=10.85.0.0/16",
```

## default /etc/resolv.conf

```
nameserver 127.0.0.53
options edns0 trust-ad
search .
```

## modified /etc/resolv.conf

```
nameserver 100.100.100.100
nameserver 127.0.0.53

options edns0 trust-ad
search panda-ule.ts.net
```