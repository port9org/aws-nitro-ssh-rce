### This Repository is intended to simplify experimentation with aws nitro enclaves. 

1. Clone repo
2. Build docker image, convert to nitro.eif, start enclave:

```console
nitro-cli terminate-enclave --all && docker build -t ssh-test:latest . \
&& nitro-cli build-enclave --docker-uri ssh-test:latest --output-file ssh-test.eif \
&& nitro-cli run-enclave --cpu-count 2 --memory 3072 --eif-path ssh-test.eif --debug-mode --enclave-cid 19
```

### 1. SSH Vsock bridge (https://stefano-garzarella.github.io/posts/2021-01-22-socat-vsock/)

1. On Ec2 Host: 
```console
socat TCP4-LISTEN:4321,reuseaddr,fork VSOCK-CONNECT:19:22
```


2. On Ec2 Host: 
```console
 ssh -p 4321 root@localhost -i sshkey
**root@(none):~#**
```

Note: Enclave-CID needs to match on nitro-cli and socat.
------------------------------------------


### 2. Debug RCE Feature: (requires run-enclave in --debug-mode to connect to console)

1. On Ec2 Host: 
```console
./ncat --vsock 19 5005
>>> whoami
```

2. On Ec2 Host: 
```console
nitro-cli  console --enclave-name=ssh-test
Connecting to the console for enclave 19...
Successfully connected to the console.
<<< root
```
------------------------------------------

### Random commands / Troubleshoot
	- Nitro-cli terminate-enclave --all 
	- docker build -t ssh-test:latest . 
	- nitro-cli build-enclave --docker-uri ssh-test:latest --output-file ssh-test.eif 
	- nitro-cli run-enclave --cpu-count 2 --memory 3072 --eif-path ssh-test.eif --debug-mode --enclave-cid 19
	- docker exec -i -t b1552bacb1b4 bash
	- docker run -d --rm -ti ssh-test 
	- docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'
	- nitro-cli console --enclave-name=ssh-test
