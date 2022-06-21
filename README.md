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

Specify ports (use _double quotes_):

```
./cidr-scan.sh 1.2.3.4/26 "6000-7999"
```

Note:
* 1st argument must be IP address with CIDR
* If CIDR is not supplied, `/32` is default (scanning a single host)
* 2nd argument is optional, but will default to: `"21-23 80"`
* 2nd argument **MUST** be wrapped in quotes if it has a space it in

_Perfection is the enemy of progress._

This was hastily put together in under an hour.

Please send me any feedback, updates, bugfixes.
