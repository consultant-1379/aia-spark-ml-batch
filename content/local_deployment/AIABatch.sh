#!/bin/sh

makeDirectory()
{
	if [ ! -d "$1" ]; then 
 
		mkdir $1

	fi
}



TakeUserInput()
{

echo 

read -p "To run ${pbaInfo.pba.name} application: Please press R or for Tearing Down dependencies please press T or Press Q for Quit:::   " status
 
if [ "${status}" = "q" ] || [ "${status}" = "Q" ]; then
 exit 0
elif [ "${status}" = "t" ] || [ "${status}" = "T" ]; then
	echo ".....Tear Down...!"  

	rm -rf "${aiapath}"
elif [ "${status}" = "r" ] || [ "${status}" = "R" ]; then


	if [ ! -f "$(pwd)/target/uber-spark-batch-processing-local.jar" ]
	then
   
		${AIA_MAVEN_HOME}/bin/mvn clean install -s ${settings_path}
	fi
		
	${AIA_JAVA_HOME}/bin/java -jar "$(pwd)/target/uber-spark-batch-processing-local.jar" "$(pwd)/sample-flows/flow.xml"
	
	if [ $? -eq 0 ]; then
	
	echo Successfully written output to /tmp/batch-op.
	
	fi	
	
else
	 TakeUserInput
	fi 
}
 
install()
{

echo 
	if [ ! -d "$2" ]; then  

	echo 	Could not locate, so installing $4 $3. this might take a little while
	
	NoExistingTypeName $1 $2 $3 $4 $5
	
  elif [ -d "$2" ]; then   
	echo 	$1 has been found 
	fi
}
  


NoExistingTypeName()
{

echo  

folder=$2.zip
  
 

if [ -f "${folder}" ]; then 
	echo 	using existing zip file, unzipping $4 "${aiapath}/" "${folder}"
	UnZipFile "${folder}" "${aiapath}/" 
else 

	echo 	Downloading files $4
 
	wget -q $5 -O ${folder}
	echo 	downloaded ${folder}
	echo 
	echo 	unzipping $4

	UnZipFile ${folder} ${aiapath}/
	  
	echo 	No Existing value of $1 is available
	
	echo 	Sucessfuly  $2 path end

fi
    
}

UnZipFile()
{
	unzip -n -qq $1 -d $2
}


makeDirectory ~/aia 
makeDirectory ~/aia/components
 
aiapath=~/aia/components
settings_url=https://arm101-eiffel004.lmera.ericsson.se:8443/nexus/content/repositories/snapshots/com/ericsson/aia/bps/engine/settings_xml/0.0.1-SNAPSHOT/settings_xml-0.0.1-20160614.114555-4.xml
hadoop_url=https://arm101-eiffel004.lmera.ericsson.se:8443/nexus/content/repositories/snapshots/com/ericsson/aia/bps/engine/hadoop-bin/0.0.1-SNAPSHOT/hadoop-bin-0.0.1-20160612.123002-2.zip
maven_url=http://mirror.ox.ac.uk/sites/rsync.apache.org/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.zip
scala_url=http://downloads.lightbend.com/scala/2.11.0/scala-2.11.0.zip
jdk_url=https://arm101-eiffel004.lmera.ericsson.se:8443/nexus/content/repositories/snapshots/com/ericsson/aia/bps/engine/jdk/0.0.1-SNAPSHOT/jdk-0.0.1-20160615.120707-2.zip
jre_url=https://arm101-eiffel004.lmera.ericsson.se:8443/nexus/content/repositories/snapshots/com/ericsson/aia/bps/engine/jre/0.0.1-SNAPSHOT/jre-0.0.1-20160615.120529-2.zip
settings_path=${aiapath}/settings.xml 


if [ ! -f "${aiapath}/jdk-8u91-linux-x64.tar.gz" ]; then

echo Installing AIA_JAVA_HOME, this might take a little while
	wget -q --no-cookies \
	--no-check-certificate \
	--header "Cookie: oraclelicense=accept-securebackup-cookie" \
	"http://download.oracle.com/otn-pub/java/jdk/8u91-b14/jdk-8u91-linux-x64.tar.gz" \
	-O ${aiapath}/jdk-8u91-linux-x64.tar.gz
	
	tar -xzf ${aiapath}/jdk-8u91-linux-x64.tar.gz -C ${aiapath}/
	
	AIA_JAVA_HOME=${aiapath}/jdk1.8.0_91
	
	else 

	if [ ! -d "${aiapath}/jdk1.8.0_91" ]; then
 
		tar -xzf ${aiapath}/jdk-8u91-linux-x64.tar.gz -C ${aiapath}/
	fi	
fi
echo AIA_JAVA_HOME has been found 
AIA_JAVA_HOME=${aiapath}/jdk1.8.0_91
echo 

install AIA_MAVEN_HOME ${aiapath}/apache-maven-3.3.9 3.3.9 maven ${maven_url} AIA_MAVEN_HOME=${aiapath}/apache-maven-3.3.9

AIA_MAVEN_HOME=${aiapath}/apache-maven-3.3.9

echo 
  
if [ ! -f "${settings_path}" ]
then 
wget -q ${settings_url} -O ${settings_path}
fi
 
TakeUserInput
