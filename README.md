# Running AWS IoT Greengrass in a Docker Container
## Overview
AWS IoT Greengrass can run in a Docker container. You can use the Dockerfile in this package to build a container image that runs on ```x86_64``` platforms. The resulting Greengrass Docker image is 532 MB in size. 
* To build a Docker image that runs on other platforms supported by the AWS IoT Greengrass Core software (such as Armv7l or AArch64), edit the Dockerfile as described in the "Enable Multi-Platform Support for the AWS IoT Greengrass Docker Image" section. 
* To reduce the size of the Greengrass Docker image, see the "Reduce the Size of the AWS IoT Greengrass Docker Image" section.  

 Note: To learn how to run a Greengrass Docker image for ```x86_64``` platform instead of building one, see the "Running AWS IoT Greengrass in a Docker Container" tutorial (https://docs.aws.amazon.com/greengrass/latest/developerguide/run-gg-in-docker-container.html).

* This guide will show you how to:
 * Build a Docker image from the Dockerfile for multi-architecture platforms. Default platform is ```x86_64```.
 * Run Amazon Linux or Alpine as the default base Docker image. Default Docker Base image is ```amazonlinux:2```.
 * Use ```docker-compose``` to build and run AWS IoT Greengrass (v1.7.0 or later) in the Docker container.
 * The Docker image supports Windows, Mac OSX, and Linux as Docker host platforms to run the Greengrass core software.
 * (Optional) Techniques to reduce the size of Greengrass Docker image.
 * (Optional) Troubleshooting techniques if Greengrass Docker image fails to work.

## Prerequisites
* Mac OSX, Windows, or Linux host computer running Docker and Docker Compose (optional).
 * The Docker installation (version 18.09 or later) can be found here: https://docs.docker.com/install/.
 * The Docker Compose installation (version 1.22 or later) can be found here: https://docs.docker.com/compose/install/.  
   Docker for Mac OS or Windows and Docker Toolbox include Compose, so those platforms don't need a separate Compose installation. Note: You must have version 1.22 or later because ```init``` support is required.
* Notepad++ (for Windows host computers only). This is used to convert an .sh file to Unix-style line endings.
 * Download Notepad++ from here: https://notepad-plus-plus.org/. 

### Linux Configuration
If you're using a Linux computer to run Docker, you must enable symlink and hardlink protection and IPv4 network forwarding. On Mac and Windows computers, these settings are already enabled in the virtual machine that Docker runs in.

Run the following commands in the host computer's terminal.

#### Enable Symlink and Hardlink Protection (Linux only)
The symlink and hardlink protection settings must be enabled to run the AWS IoT Greengrass core software. 

* To enable the settings only for the current boot:

```
echo 1 > /proc/sys/fs/protected_hardlinks
echo 1 > /proc/sys/fs/protected_symlinks
```

* To enable the settings to persist across restarts:

```
echo '# AWS Greengrass' >> /etc/sysctl.conf
echo 'fs.protected_hardlinks = 1' >> /etc/sysctl.conf
echo 'fs.protected_symlinks = 1' >> /etc/sysctl.conf

sysctl -p
```

Note: You may need to use ```sudo``` to run these commands.

#### Enable IPv4 Network Forwarding (Linux only)
IPv4 network forwarding must be enabled for AWS IoT Greengrass cloud deployment and MQTT communications to work.

* To enable IPv4 forwarding, edit the ```/etc/sysctl.conf``` file to set ```net.ipv4.ip_forward``` to 1 and then reload ```sysctls```:

```
sudo nano /etc/sysctl.conf
# set this net.ipv4.ip_forward = 1
sudo sysctl -p
```
Note: You can use the editor of your choice in place of nano.

If you don't enable this setting, you receive an error message such as ```WARNING: IPv4 is disabled. Networking will not work```. For more information, see "Configure namespaced kernel parameters (sysctls) at runtime" (https://docs.docker.com/engine/reference/commandline/run/#configure-namespaced-kernel-parameters-sysctls-at-runtime).

## Reduce the Size of the AWS IoT Greengrass Docker Image (Optional)
Currently, the Greengrass Docker image is about 532 MB. Most of this size is attributed to the heavy ```amazonlinux``` Docker base image that AWS IoT Greengrass runs on. 

Use following techniques to reduce the size of your Greengrass Docker image. Otherwise, continue to the "Running AWS IoT Greengrass in a Docker Container" procedure.

### AWS IoT Greengrass Docker Image Size Comparison 
 
| Base Image    | Installed Dependencies | Platform | Size  | Instructions                        |
|---------------+------------------------+----------+-------+-------------------------------------|
| AmazonLinux:2 | Python, Nodejs, Java   | x86_64   | 532MB | Default Dockerfile                  |
| AmazonLinux:2 | Python                 | x86_64   | 370MB | Reduce Lambda Runtime Installations |
| Alpine:3.8    | Python                 | x86_64   | 95MB  | Change the Base Docker Image        |

## Running AWS IoT Greengrass in a Docker Container
The following steps show how to build the Docker image from the Dockerfile and configure AWS IoT Greengrass to run in a Docker container.


### Step 1. Build the AWS IoT Greengrass Docker Image
#### On Linux or Mac OSX
1- Download and decompress the ```aws-greengrass-docker-1.9.2``` package.  

2- In a terminal, run the following commands in the location where you decompressed the ```aws-greengrass-docker-1.9.2``` package. 
```
docker login
cd ~/Downloads/aws-greengrass-docker-1.9.2 
docker build -t "x86_64/aws-iot-greengrass:1.9.2" ./
```

 Note: If you have ```docker-compose``` installed, you can run the following commands instead:
```
docker login
cd ~/Downloads/aws-greengrass-docker-1.9.2 
docker-compose -f docker-compose.yml build
```

Note: If you want to use a smaller size docker image, run below command:
```
docker-compose -f docker-compose.alpine-x86-64.yml build
```

3- Verify that the Greengrass Docker image was built.
```
docker images
REPOSITORY                          TAG                 IMAGE ID            CREATED             SIZE
x86-64/aws-iot-greengrass           1.9.2               3f152d6707c8        17 seconds ago      532MB
```

#### On RaspberryPi for armv7l platform
If you want to build docker images for armv7l platform, follow below steps on RaspberryPi with Docker and Docker-compose installed.

1- Download and decompress the ```aws-greengrass-docker-1.9.2``` package.  

2- In a terminal, run the following commands in the location where you decompressed the ```aws-greengrass-docker-1.9.2``` package. 
```
docker login
cd ~/Downloads/aws-greengrass-docker-1.9.2 
docker build -t "armv7l/aws-iot-greengrass:1.9.2" -f Dockerfile.alpine-armv7l ./
```

 Note: If you have ```docker-compose``` installed, you can run the following commands instead:
```
docker login
cd ~/Downloads/aws-greengrass-docker-1.9.2 
docker-compose -f docker-compose.alpine-armv7l.yml build
```

3- Verify that the Greengrass Docker image was built.
```
docker images
REPOSITORY                          TAG                 IMAGE ID            CREATED             SIZE
armv7l/aws-iot-greengrass           1.9.2               3f152d6707c8        17 seconds ago      532MB
```


#### On a Windows Computer
1- Download and decompress the ```aws-greengrass-docker-1.9.2``` package using a utility like WinZip or 7-Zip.  

2- Using Notepad++, convert the ```greengrass-entrypoint.sh``` file to use Unix-style line endings. For more information, see "Converting from Windows-style to UNIX-style line endings" (https://support.nesi.org.nz/hc/en-gb/articles/218032857-Converting-from-Windows-style-to-UNIX-style-line-endings).   
Otherwise, you will get this error while running the build Docker image: ```[FATAL tini (6)] exec /greengrass-entrypoint.sh failed: No such file or directory```.
    
 a. Open ```greengrass-entrypoint.sh``` in Notepad++.   
 b. In the "Edit" menu, choose "EOL Conversion", and then choose "UNIX (LF)".   
 c. Save the file.
    
3- In a command prompt, run the following command in the location where you decompressed the ```aws-greengrass-docker-1.9.2``` package.
```
docker login
cd C:\Users\%USERNAME%\Downloads\aws-greengrass-docker-1.9.2
docker build -t "x86_64/aws-iot-greengrass:1.9.2" ./
```

 Note: If you have ```docker-compose``` installed, you can run the following commands instead:
```
docker login
cd C:\Users\%USERNAME%\Downloads\aws-greengrass-docker-1.9.2
docker-compose -f docker-compose.yml build
```

4- Verify that the Greengrass Docker image was built.
```
docker images
REPOSITORY                          TAG                 IMAGE ID            CREATED             SIZE
x86-64/aws-iot-greengrass           1.9.2               3f152d6707c8        17 seconds ago      532MB
```

### Step 2. Run AWS IoT Greengrass Locally
#### On Linux or Mac OSX
1- Use the AWS IoT Greengrass console to create a Greengrass group. Follow the steps in "Configure AWS IoT Greengrass on AWS IoT" (https://docs.aws.amazon.com/greengrass/latest/developerguide/gg-config.html). This process includes downloading certificates and the core configuration file.   
Skip step 8b of the procedure because AWS IoT Greengrass core and its runtime dependencies are already set up in the Docker image.   

2- Decompress the certificates and config file that you downloaded into your working directory where ```Dockerfile``` and ```docker-compose.yml``` are located. For example: (replace ```guid``` in your command)
```
cp ~/Downloads/guid-setup.tar.gz ~/Downloads/aws-greengrass-docker-1.9.2
cd ~/Downloads/aws-greengrass-docker-1.9.2
tar xvzf guid-setup.tar.gz
```

3- Download the root CA certificate into the directory where you decompressed the certificates and configuration file. The certificates enable your device to communicate with AWS IoT using the MQTT messaging protocol over TLS. For more information, including how to choose the appropriate root CA certificate, see the documentation on "Server Authentication in AWS IoT Core" (https://docs.aws.amazon.com/iot/latest/developerguide/managing-device-certs.html).  

**Important**: Your root CA certificate must match your endpoint, which uses Amazon Trust Services (ATS) server authentication (preferred) or legacy server authentication. You can find your endpoint on the **Settings** page in the AWS IoT Core console.   
 - For ATS endpoints, you must use an ATS root CA certificate. ATS endpoints include the ```ats``` segment (for example: ```<prefix>-ats.iot.us-west-2.amazonaws.com```).  
 Make sure the Docker host is connected to the internet, and run the following command. This example uses the ```AmazonRootCA1.pem``` root CA certificate.
```
cd ~/Downloads/aws-greengrass-docker-1.9.2/certs 
sudo wget -O root.ca.pem https://www.amazontrust.com/repository/AmazonRootCA1.pem
```
 - For legacy endpoints, you must use a Verisign root CA certificate. Legacy endpoints **do not** include the ```ats``` segment (for example: ```<prefix>.iot.us-west-2.amazonaws.com```).
 Make sure the Docker host is connected to the internet, and run the following command.
```
cd ~/Downloads/aws-greengrass-docker-1.9.2/certs 
sudo wget -O root.ca.pem https://www.symantec.com/content/en/us/enterprise/verisign/roots/VeriSign-Class%203-Public-Primary-Certification-Authority-G5.pem
``` 

4- Run the following command to confirm that the ```root.ca.pem``` file is not empty.
```
cat ~/Downloads/aws-greengrass-docker-1.9.2/certs/root.ca.pem
```

#### On a Windows Computer
1- Use the AWS IoT Greengrass console to create a Greengrass group. Follow the steps in "Configure AWS IoT Greengrass on AWS IoT" (https://docs.aws.amazon.com/greengrass/latest/developerguide/gg-config.html). This process includes downloading certificates and the core configuration file.   
Skip step 8b of the procedure because AWS IoT Greengrass core and its runtime dependencies are already set up in the Docker image.   

2- Decompress the certificates and config file that you downloaded into your working directory where ```Dockerfile``` and ```docker-compose.yml``` are located. Use a utility like WinZip or 7-Zip to decompress ```<guid>-setup.tar.gz``` to ```C:\Users\%USERNAME%\Downloads\aws-greengrass-docker-1.9.2\```.

3- Download the root CA certificate into the directory where you decompressed the certificates and configuration file. The certificates enable your device to communicate with AWS IoT using the MQTT messaging protocol over TLS. For more information, including how to choose the appropriate root CA certificate, see the documentation on "Server Authentication in AWS IoT Core" (https://docs.aws.amazon.com/iot/latest/developerguide/managing-device-certs.html).  

**Important**: Your root CA certificate must match your endpoint, which uses Amazon Trust Services (ATS) server authentication (preferred) or legacy server authentication. You can find your endpoint on the **Settings** page in the AWS IoT Core console.   
 - For ATS endpoints, you must use an ATS root CA certificate. ATS endpoints include the ```ats``` segment (for example: ```<prefix>-ats.iot.us-west-2.amazonaws.com```).  
 Make sure the Docker host is connected to the internet. If you have ```curl``` installed, run the following commands in your command prompt. This example uses the ```AmazonRootCA1.pem``` root CA certificate.
```
cd C:\Users\%USERNAME%\Downloads\aws-greengrass-docker-1.9.2\certs
curl https://www.amazontrust.com/repository/AmazonRootCA1.pem -o root.ca.pem
```
 - For legacy endpoints, you must use a Verisign root CA certificate. Legacy endpoints **do not** include the ```ats``` segment (for example: ```<prefix>.iot.us-west-2.amazonaws.com```).  
 Make sure the Docker host is connected to the internet. If you have ```curl``` installed, run the following commands in your command prompt.
```
cd C:\Users\%USERNAME%\Downloads\aws-greengrass-docker-1.9.2\certs
curl https://www.symantec.com/content/en/us/enterprise/verisign/roots/VeriSign-Class%203-Public-Primary-Certification-Authority-G5.pem -o root.ca.pem
```

Note: If you don't have ```curl``` installed, follow these steps:
- In a web browser, open the root CA certificate:
 - For ATS endpoints, open an ATS root CA certificate (such as ```AmazonRootCA1.pem``` https://www.amazontrust.com/repository/AmazonRootCA1.pem).
 - For legacy endpoints, open the VeriSign Class 3 Public Primary G5 root CA certificate (https://www.symantec.com/content/en/us/enterprise/verisign/roots/VeriSign-Class%203-Public-Primary-Certification-Authority-G5.pem)
- Save the document as ```root.ca.pem``` in the ```C:\Users\%USERNAME%\Downloads\aws-greengrass-docker-1.9.2\certs``` directory, which contains the decompressed certificates. Depending on your browser, save the file directly from the browser or copy the displayed key to the clipboard and save it in Notepad.

4- Run the following command to confirm that the ```root.ca.pem``` file is not empty.
```
type C:\Users\%USERNAME%\Downloads\aws-greengrass-docker-1.9.2\certs\root.ca.pem
```

### Step 3. Run the Docker Container 
#### On Linux or Mac OSX
1- In the terminal, run the following command:
 -  To run the container using the default x86_64 configuration
```
docker run --rm --init -it --name aws-iot-greengrass \
--entrypoint /greengrass-entrypoint.sh \
-v ~/Downloads/aws-greengrass-docker-1.9.2/certs:/greengrass/certs \
-v ~/Downloads/aws-greengrass-docker-1.9.2/config:/greengrass/config \
-p 8883:8883 \
x86_64/aws-iot-greengrass:1.9.2
```

 Note: If you have ```docker-compose``` installed, you can run the following commands instead:
```
cd ~/Downloads/aws-greengrass-docker-1.9.2
docker-compose -f docker-compose.yml down
docker-compose -f docker-compose.yml up
```

The output should look like this example:
```
Setting up greengrass daemon
Validating hardlink/softlink protection
Waiting for up to 30s for Daemon to start

Greengrass successfully started with PID: 10
```
Note: This command starts AWS IoT Greengrass and bind-mounts the certificates and config file. This will keep the interactive shell open, so that the Greengrass container can be removed/released later. You can find "Debugging" steps below if the container doesn't open the shell and exits immediately.

#### On RaspberryPi for armv7l platform
1- In the terminal, run the following command:
 -  To run the container using the armv7l platform such as RaspberryPi.
```
docker run --rm --init -it --name aws-iot-greengrass \
--entrypoint /greengrass-entrypoint.sh \
-v ~/Downloads/aws-greengrass-docker-1.9.2/certs:/greengrass/certs \
-v ~/Downloads/aws-greengrass-docker-1.9.2/config:/greengrass/config \
-p 8883:8883 \
armv7l/aws-iot-greengrass:1.9.2
```

 Note: If you have ```docker-compose``` installed, you can run the following commands instead:
```
cd ~/Downloads/aws-greengrass-docker-1.9.2
docker-compose -f docker-compose.alpine-armv7l.yml down
docker-compose -f docker-compose.alpine-armv7l.yml up
```

The output should look like this example:
```
Setting up greengrass daemon
Validating hardlink/softlink protection
Waiting for up to 30s for Daemon to start

Greengrass successfully started with PID: 10
```
Note: This command starts AWS IoT Greengrass and bind-mounts the certificates and config file. This will keep the interactive shell open, so that the Greengrass container can be removed/released later. You can find "Debugging" steps below if the container doesn't open the shell and exits immediately.


#### On a Windows Computer
1- In the command prompt, run the following command:
```
docker run --rm --init -it --name aws-iot-greengrass --entrypoint /greengrass-entrypoint.sh -v c:/Users/%USERNAME%/Downloads/aws-greengrass-docker-1.9.2/certs:/greengrass/certs -v c:/Users/%USERNAME%/Downloads/aws-greengrass-docker-1.9.2/config:/greengrass/config -p 8883:8883 x86-64/aws-iot-greengrass:1.9.2
```

Note: If you have ```docker-compose``` installed, you can run the following commands instead:
```
cd C:/Users/%USERNAME%/Downloads/aws-greengrass-docker-1.9.2
docker-compose -f docker-compose.yml down
docker-compose -f docker-compose.yml up
```

Docker will prompt you to share your ```C:\``` drive with the Docker daemon. Allow it to bind-mount the ```C:\``` directory inside the Docker container. For more information, see "Shared drives" (https://docs.docker.com/docker-for-windows/#shared-drives) in the Docker documentation.

The output should look like this example:
```
Setting up greengrass daemon
Validating hardlink/softlink protection
Waiting for up to 30s for Daemon to start

Greengrass successfully started with PID: 10
```
Note: This command starts AWS IoT Greengrass and bind-mounts the certificates and config file. This will keep the interactive shell open, so that the Greengrass container can be removed/released later. You can find "Debugging" steps below if the container doesn't open the shell and exits immediately.

### Step 4: Configure "No container" Containerization for the Greengrass Group

When you run AWS IoT Greengrass in a Docker container, all Lambda functions must run without containerization. In this step, you set the the default containerization for the group to "No container". You must do this before you deploy the group for the first time.

1- In the AWS IoT console, choose "Greengrass", and then choose "Groups".  
2- Choose the group whose settings you want to change.  
3- Choose "Settings".  
4- Under "Lambda runtime environment", choose "No container".

For more information, see "Setting Default Containerization for Lambda Functions in a Group" (https://docs.aws.amazon.com/greengrass/latest/developerguide/lambda-group-config.html#lambda-containerization-groupsettings).

  Note: By default, Lambda functions use the group containerization setting. If you override the "No container" setting for any Lambda functions when AWS IoT Greengrass is running in a Docker container, the deployment fails.


### Step 5: Deploy Lambda Functions to the AWS IoT Greengrass Docker Container

You can deploy long-lived Lambda functions to the Greengrass Docker container.

1- Follow the steps in "Module 3 (Part 1): Lambda Functions on AWS IoT Greengrass" (https://docs.aws.amazon.com/greengrass/latest/developerguide/module3-I.html) to deploy a long-lived Hello-World Lambda function to the container.

### Debugging the Docker Container
To debug issues with the container, you can persist the runtime logs or attach an interactive shell.

#### Persist Greengrass Runtime Logs outside the Greengrass Docker Container
You can run the AWS IoT Greengrass Docker container after bind-mounting the ```/greengrass/ggc/var/log``` directory to persist logs even after the container has exited or is removed.
##### On Linux or Mac OSX
Run the following command in the terminal.

```
docker run --rm --init -it --name aws-iot-greengrass \
--entrypoint /greengrass-entrypoint.sh \
-v ~/Downloads/aws-greengrass-docker-1.9.2/certs:/greengrass/certs \
-v ~/Downloads/aws-greengrass-docker-1.9.2/config:/greengrass/config \
-v ~/Downloads/aws-greengrass-docker-1.9.2/log:/greengrass/ggc/var/log \
-p 8883:8883 \
<platform>/aws-iot-greengrass:1.9.2
```
You can then check your logs at ```~/Downloads/aws-greengrass-docker-1.9.2/log``` on your host to see what happened while Greengrass was running inside the Docker container.
##### On a Windows Computer
Run the following command in the command prompt.
```
cd C:\Users\%USERNAME%\Downloads\aws-greengrass-docker-1.9.2
mkdir log
docker run --rm --init -it --name aws-iot-greengrass --entrypoint /greengrass-entrypoint.sh -v c:/Users/%USERNAME%/Downloads/aws-greengrass-docker-1.9.2/certs:/greengrass/certs -v c:/Users/%USERNAME%/Downloads/aws-greengrass-docker-1.9.2/config:/greengrass/config -v c:/Users/%USERNAME%/Downloads/aws-greengrass-docker-1.9.2/log:/greengrass/ggc/var/log -p 8883:8883 x86-64/aws-iot-greengrass:1.9.2
```
You can then check your logs at ```c:/Users/%USERNAME%/Downloads/aws-greengrass-docker-1.9.2/log``` on your host to see what happened while Greengrass was running inside the Docker container.

#### Attach an Interactive Shell to the Greengrass Docker Container
You can attach an interactive shell to a running AWS IoT Greengrass Docker container. This can help you to investigate the state of the Greengrass Docker container.
##### On Linux or Mac OSX
Run the following command in the terminal.
```
docker exec -it $(docker ps -a -q -f "name=aws-iot-greengrass") /bin/bash
```

##### On a Windows Computer
Run the following commands in the command prompt.
```
docker ps -a -q -f "name=aws-iot-greengrass"
```

Replace ```<GG_CONTAINER_ID>``` with the ```container_id``` result from the previous command.
```
docker exec -it <GG_CONTAINER_ID> /bin/bash
```
### Stopping the Docker Container
To stop the AWS IoT Greengrass Docker Container, press Ctrl+C in your terminal or command prompt. 

This action will send SIGTERM to the Greengrass daemon process to tear down the Greengrass daemon process and all Lambda processes that were started by the daemon process. The Docker container is initialized with ```/dev/init``` process as PID 1, which helps in removing any leftover zombie processes. For more information, see the Docker run reference: https://docs.docker.com/engine/reference/commandline/run/#options.

## Troubleshooting
* If you see the message ```Firewall Detected while Sharing Drives``` when running Docker on a Windows computer, see the following Docker article for troubleshooting help: https://success.docker.com/article/error-a-firewall-is-blocking-file-sharing-between-windows-and-the-containers. This error can also occur if you are logged in on a Virtual Private Network (VPN) and your network settings are preventing the shared drive from being mounted. In that situation, turn off VPN and re-run the Docker container.
* If you receive an error like ```Cannot create container for the service greengrass: Conflict. The container name "/aws-iot-greengrass" is already in use.``` This is because the container name is used by the older run. To resolve this, remove the old Docker container by running: ```docker rm -f $(docker ps -a -q -f "name=aws-iot-greengrass")```
* If you see the error message ```[FATAL]-Failed to reset thread's mount namespace due to an unexpected error: "operation not permitted". To maintain consistency, GGC will crash and need to be manually restarted.``` in ```/greengrass/ggc/var/log/system/runtime.log```. This is most probably caused by deploying a ```GreengrassContainer``` lambda to ```GGC running in Docker Container``` as this use-case is not yet supported. All the lambdas should be deployed in ```NoContainer``` mode. To fix this, disregard the current deployment stuck ```In Progress```. Start a new deployment and make sure that all the lambdas are deployed in ```NoContainer``` mode. After that, while starting the GGC Docker Container, do not bind-mount the existing ```deployment``` directory onto ```GGC Docker Container```. Create a new empty ```deployment``` directory in its place and bind-mount that in the ```GGC Docker container``` instead. New GGC Docker Container should receive the latest deployment with lambdas running in ```NoContainer``` mode.
