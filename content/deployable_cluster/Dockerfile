# **********************************************************************
# Ericsson Radio Systems AB                                     SCRIPT
# **********************************************************************
#
# (c) Ericsson Radio Systems AB 2016 - All rights reserved.
#
# The copyright to the computer program(s) herein is the property of
# Ericsson Radio Systems AB, Sweden. The programs may be used and/or
# copied only with the written permission from Ericsson Radio Systems AB
# or in accordance with the terms and conditions stipulated in the
# agreement/contract under which the program(s) have been supplied.
#
# **********************************************************************
#   Command Section
#
# **********************************************************************
#
#   Main body of program
#
# ********************************************************************
#
#Pull Spark Base image from Docker Repository
FROM armdocker.rnd.ericsson.se/aia/base/spark_base_1.6.0

#Created Spark Batch folder so that all Spark Batch application dependencies goes into this
CMD mkdir -p  /spark_ML_batch

#overwrite JavaHome
ENV JAVA_HOME /usr/java/latest

#Copy init start script
COPY config/initialization_script /spark_ML_batch/

#Copy Spark Batch jar
ADD target/bps-engine-deployable.jar /spark_ML_batch/

#Copy Config files
COPY config/config.properties /spark_ML_batch/

#Run this script when docker images gets initialized 
ENTRYPOINT ["/spark_ML_batch/initialization_script"]