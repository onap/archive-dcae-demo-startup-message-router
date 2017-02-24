This project hosts the configurations and start-up scripts for instantiating the Open eCOMP Message Router.

To deploy an Open eCOMP Message Router to a host:

0. prepare the docker host:
   a. install the following software:  git, docker, docker-compose
1. login to the docker host
2. git clone this project:
     git clone -b pocorange https://23.253.149.175/lj1412/dcae-startup-vm-message-router.git
3. change dir to dcae-startup-vm-message-router
   edit the deploy.sh file with local configurations such as docker-compose 
4. run the deploy.sh as root




To use the Message Router:
Reference docker_files/tests/test.sh for curl exmples for publishing/subscribing and API key creation.

These examples are for running MR client (curl) on the same VM as the MR.  If running from a 
different location, change the host portion of the HOSTPORT variable to teh IP address/hostname 
of the VM running the MR.  For example from
HOSTPORT="127.0.0.1:3904"
to 
HOSTPORT="10.0.11.1.com:3904"
