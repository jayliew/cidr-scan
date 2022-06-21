# cidr-scan
Bash script to scan your subnets with CIDR. 

Only supports /24 through /30.

```
wget liew.co/cidr-scan
chmod u+x cidr-scan
```

Usage: 

```
./cidr-scan.sh 1.2.3.4/26 "<port string *MUST* be in quotes>"
```

Note:
* 1st argument must be IP address with CIDR
* 2nd argument is optional, but will default to: `"21-23 80"`
* 2nd argument **MUST** be wrapped in quotes if it has a space it in

_Perfection is the enemy of progress._

This was hastily put together in under an hour.

Please send me any feedback, updates, bugfixes.
