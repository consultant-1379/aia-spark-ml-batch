
# Introduction
This is a sample project, generated from the AIA Portal using the Batch Processing template.
It illustrates using AIA for batch data processing stored on Hadoop, Process it using Spark-ML for creating model and prediction.

# Requirements
### AIA VM
The project requires Hadoop and Spark ML. AIA provides a VM with these built-in.
Details of how to download the VM are explained on the AIA portal.
### Docker
AIA uses an application deployment mechanism based on Docker images.
To install Docker, follow the steps in https://docs.docker.com/engine/installation

These steps have been tested with Docker Toolbox 1.11 on Windows 7

# Start the Docker Quickstart Terminal
Start the Docker Quickstart Terminal that you just installed.
Other shell or dos based terminals can be used but they require extra environment variables to be setup.

Go to the sample project folder
```
cd <project-location>/deployable_cluster
```

# Build the application

## Compile with Maven
```
mvn clean install
```

## Containerize the application
```
docker login -u <signum> http://armdocker.rnd.ericsson.se
docker build -t armdocker.rnd.ericsson.se/aia/bps-${pbaInfo.pba.name}:${pbaInfo.pba.version} .
```

## Publish the container to Artifactory
```
docker push armdocker.rnd.ericsson.se/aia/bps-${pbaInfo.pba.name}:${pbaInfo.pba.version}
```

## For cluster deployment mode: To run tests without schema registry (ctrl + c to stop running docker)
```
docker run -it --env mainClass=com.ericsson.component.aia.services.bps.engine.service.BPSPipeLineExecuter --env deployMode=cluster --env masterUrl=spark://ip:7077 --env bpsJar=hdfs://localhost:8020/ --env flowPath=hdfs://ip:8020/ --env jobArguments="" armdocker.rnd.ericsson.se/aia/bps-${pbaInfo.pba.name}:${pbaInfo.pba.version}
```
## For cluster deployment mode: To run tests with schema registry
```
docker run -it --env mainClass=com.ericsson.component.aia.services.bps.engine.service.BPSPipeLineExecuter --env deployMode=cluster --env schemaRegistry=-DschemaRegistry.address=http://IP:8081/ --env masterUrl=spark://ip:7077 --env bpsJar=hdfs://localhost:8020/ --env flowPath=hdfs://ip:8020/ --env jobArguments="" armdocker.rnd.ericsson.se/aia/bps-${pbaInfo.pba.name}:${pbaInfo.pba.version}
```

# Deploy the application
The VM is running the AIA Paas Manager, which helps deploying applications.
The PaaS manager internally submits your application to the Spark Cluster using Mesos and Marathon.

## Pepare input data
When deployed, the application starts automatically, so the inputs (data and flow config file) first need to be in place.
Also make sure the url for the spark master is correct, Right now its hard coded so please change according to your environment

### Copy input data into hdfs from virtual Machine

```
   hadoop fs -copyFromLocal <from localtion to flow.xml> <To location on hdfs>
   hadoop fs -copyFromLocal <from location of bps-deployable.jar> <To location on hdfs>
```

### Flow.xml
Copy to the VM under /home/vagrant
The password for the vagrant user is `vagrant`
```
scp -P 2222 ./config/flow.xml vagrant@localhost:/home/vagrant
```

### Test data
The flow.xml file uploaded in the previous step points to the input data.

Let's say it expects data in "hdfs:///tmp/iris.csv", then the steps to upload the data would be
```
scp -P 2222 config/iris.csv vagrant@localhost:/home/vagrant
ssh -p 2222 vagrant@localhost
hadoop fs -copyFromLocal iris.csv /tmp
exit
```

## Submit to AIA Paas Manager
To deploy
```
<project-location>/bin/deploy_app.sh http://localhost:8888
```
To undeploy
```
<project-location>/bin/undeploy_app.sh http://localhost:8888
```
# Publish to Application Manager

Once your BPS application is tested in the local/cluster mode, you can publish it to the application repository. By publishing to the repository your application will be listed under the APP builder page in the AIA portal.

* To publish, unpublish and view application Navigate to portal at : http://analytics.ericsson.se/#/GetStarted/ecosystem/appbuilder/applications

# Wait for results
Check the deployment status on the Paas Manager web interface. It should be in status "Running":
http://localhost:8080
Give it a bit of time to crunch the data, then check the output results.
If the output is in hdfs format, you can browse the file system using the hadoop web interface:
http://localhost:50070/explorer.html#
