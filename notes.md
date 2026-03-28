#### THIS IS VERY PROMISING

https://github.com/nymanjens/quizmaster


```powershell
(Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.PrefixOrigin -ne "WellKnown"}).IPAddress
```

the third ip : 8080 seems to work

(i use 8080 cuz it's alrdy configured in my firewall)

Building it when changing the code or on a new machine:
```bash
. build.sh
```

Running the built image (quizmaster:localv2)
```bash
. run.sh
```