   _____  __      __  _________  _______  .__  __                 
  /  _  \/  \    /  \/   _____/  \      \ |__|/  |________  ____  
 /  /_\  \   \/\/   /\_____  \   /   |   \|  \   __\_  __ \/  _ \ 
/    |    \        / /        \ /    |    \  ||  |  |  | \(  <_> )
\____|__  /\__/\  / /_______  / \____|__  /__||__|  |__|   \____/ 
        \/      \/          \/          \/                        

1. clone repo
2. build docker image, convert to nitro.eif, start enclave:
nitro-cli terminate-enclave --all && docker build -t ssh-test:latest . \
&& nitro-cli build-enclave --docker-uri ssh-test:latest --output-file ssh-test.eif \
&& nitro-cli run-enclave --cpu-count 2 --memory 3072 --eif-path ssh-test.eif --debug-mode --enclave-cid 19

SSH Vsock bridge (https://stefano-garzarella.github.io/posts/2021-01-22-socat-vsock/)

3. On Ec2 Host: socat TCP4-LISTEN:4321,reuseaddr,fork VSOCK-CONNECT:42:22
4. On Ec2 Host: ssh -p 4321 root@localhost -i sshkey
root@(none):~# 



Debug RCE Feature: (requires run-enclave in --debug-mode to connect to console)
On Ec2 Host: 
./ncat --vsock 19 5005   (https://man7.org/linux/man-pages/man1/ncat.1.html)
>>> whoami

On Ec2 Host: nitro-cli  console --enclave-name=ssh-test
<<< root

Random commands / Troubleshoot
	- Nitro-cli terminate-enclave --all 
	- docker build -t ssh-test:latest . 
	- nitro-cli build-enclave --docker-uri ssh-test:latest --output-file ssh-test.eif 
	- nitro-cli run-enclave --cpu-count 2 --memory 3072 --eif-path ssh-test.eif --debug-mode --enclave-cid 19
	- docker exec -i -t b1552bacb1b4 bash
	- docker run -d --rm -ti ssh-test 
	- docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' 


#nitro-cli console --enclave-name=ssh-test
[ E44 ] Enclave console connection failure. Such error appears when the Nitro CLI process fails to establish a connection to a running enclave's console.
CHeck if Debug mode is enabled: nitro-cli describe-enclaves