## Node-RED

Made for i386 architecture based devices and compatibles

### Docker repository

https://hub.docker.com/r/hilschernetiotedge/netfield-nodered

### Container features

The image provided hereunder deploys a container with installed Debian, Node-RED and several useful common Node-RED nodes maintained by the community.

Base of the image builds [debian](https://hub.docker.com/_/debian) with installed Internet of Things flow-based programming web-tool [Node-RED](https://nodered.org/).

Additionally the nodes [node-red-contrib-opcua](https://flows.nodered.org/node/node-red-contrib-opcua), [node-red-dashboard](https://flows.nodered.org/node/node-red-dashboard), [node-red-contrib-ibm-watson-iot](https://www.npmjs.com/package/node-red-contrib-ibm-watson-iot), [node-red-contrib-azure-iot-hub](https://flows.nodered.org/node/node-red-contrib-azure-iot-hub), [node-red-contrib-modbus](https://flows.nodered.org/node/node-red-contrib-modbus), [node-red-contrib-influxdb](https://flows.nodered.org/node/node-red-contrib-influxdb), [node-red-contrib-mssql-plus](https://flows.nodered.org/node/node-red-contrib-mssql-plus) come preinstalled.

### Container hosts

The container has been successfully tested on the following hosts

* netIOT OnPremise, product name NIOT-E-TIJCX-GB-RE
* netFIELD OnPremise, product name NIOT-E-TIJCX-GB-RE/NFLD

### Container setup

#### Volume mapping (optional)

To store the Node-RED flow and settings files permanently on the Docker host they can be outsourced in a "separate" volume outside the container. This keeps the files on the system even if the container is removed. If later the volume is remapped to a new container the files are available again to it and reused.

#### Port mapping, network mode

The container needs to run in `host` network mode. 

This mode makes port mapping unnecessary. The following TCP/UDP container ports are exposed to the host automatically

Used port | Protocol | By application | Remark
:---------|:------ |:------ |:-----
*1880* | TCP | Node-RED

### Container deployments

Pulling the image may take 10 minutes.

#### netIOT OnPremise example

STEP 1. Open device's web UI in your browser (https).

STEP 2. Click the Docker tile to open the [Portainer.io](http://portainer.io/) Docker management user interface.

STEP 3. Click *Volumes > + Add Volume*. Enter `nodered` as *Name* and click `Create the volume`. 

STEP 4. Enter the following parameters under *Containers > + Add Container*

Parameter | Value | Remark
:---------|:------ |:------
*Image* | **hilschernetiotedge/netfield-nodered** |
*Network > Network* | **host** |
*Restart policy* | **always**
*Port mapping* | *host* **1880** -> *container* **1880** |
*Volumes > Volume mapping > map additional volume* | *volume* **/nodered** -> *container* **/root/.node-red** | optional for flow persistence

STEP 5. Press the button *Actions > Start/Deploy container*

#### Docker command line example

`docker volume create nodered` `&&`
`docker run -d --network=host --restart=always -p 1880:1880/tcp -v nodered:/root/.node-red hilschernetiotedge/netfield-nodered`

#### Docker compose example

A `docker-compose.yml` file could look like this

    version: "2"

    services:
     nodered:
       image: hilschernetiotedge/netfield-nodered
       restart: always
       network_mode: host
       ports:
         - 1880:1880
       volumes:
         - nodered:/root/.node-red

### Container access

The container starts Node-RED and all involved services automatically when deployed.

The container configures Node-RED to support https secured web communications. So open it in your browser with `https://<device-ip-address>:1880` e.g. `https://192.168.0.1:1880`.

The container configures Node-RED to ask for a login in case it runs on a device with admin web UI like netFIELD OnPremise. Use the same users/password as setup in the UI to login.

### License

Copyright (c) Hilscher Gesellschaft fuer Systemautomation mbH. All rights reserved.
Licensed under the LICENSE.txt file information stored in the project's source code repository.

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).
As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.

[![N|Solid](http://www.hilscher.com/fileadmin/templates/doctima_2013/resources/Images/logo_hilscher.png)](http://www.hilscher.com)  Hilscher Gesellschaft fuer Systemautomation mbH  www.hilscher.com


