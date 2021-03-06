# cidr-scan
Bash script to scan your subnets with CIDR. 

Supports `/24` through `/30`, and `/32`.

```
wget liew.co/cidr-scan
chmod u+x cidr-scan
```

Most common use (default ports used): 

```
./cidr-scan.sh 1.2.3.4/26
```

Scan a single host:
```
./cidr-scan.sh 1.2.3.4
./cidr-scan.sh 1.2.3.4/32
```

Specify ports (use _double quotes_):

```
./cidr-scan.sh 1.2.3.4/26 "6000-7999"
```

Note:
* 1st argument must be IP address. CIDR optional
* If CIDR is not supplied, `/32` is default (scanning a single host)
* 2nd argument is optional, but will default to: `"21-23 80"`
* 2nd argument **MUST** be wrapped in quotes if it has a space it in

Please send me any feedback, updates, bugfixes.
