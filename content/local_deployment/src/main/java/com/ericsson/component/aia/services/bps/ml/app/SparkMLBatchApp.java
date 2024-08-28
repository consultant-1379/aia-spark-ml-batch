/*------------------------------------------------------------------------------
 *******************************************************************************
 * COPYRIGHT Ericsson 2016
 *
 * The copyright to the computer program(s) herein is the property of
 * Ericsson Inc. The programs may be used and/or copied only with written
 * permission from Ericsson Inc. or in accordance with the terms and
 * conditions stipulated in the agreement/contract under which the
 * program(s) have been supplied.
 * 
 * Problem Statement
 * 
 * *****************
 * 
 * The input data is the iris dataset. It contains recordings of
 * information about flower samples. For each sample, the petal and
 * sepal length and width are recorded along with the type of the
 * flower. We need to use this dataset to build a decision tree
 * model that can predict the type of flower based on the petal
 * and sepal information.
 * 
 * Techniques Used
 * 
 * 1. Decision Trees
 * 2. Training and Testing
 * 3. Confusion Matrix
 *  
 *******************************************************************************
 *----------------------------------------------------------------------------*/
package com.ericsson.component.aia.services.bps.ml.app;

import org.apache.spark.sql.DataFrame;
import com.ericsson.component.aia.services.bps.core.service.streams.BpsStream;
import com.ericsson.component.aia.services.bps.spark.jobrunner.ml.SparkMLBatchJobRunner;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ${metaInfo.pbaNameInCamelCase}  extends SparkMLBatchJobRunner {

private static final Logger LOGGER=LoggerFactory.getLogger(${metaInfo.pbaNameInCamelCase}.class);


    @Override
    public void executeJob() {

    //Gets Batch data as defined in flow.xml  
    final DataFrame df = getBpsInputStreams().<DataFrame> getStreams("input-stream").getStreamRef();

         /**
          * Write your business logic here and deploy application
          * 
         **/
        
       /*
        * To save model/Output to Hdfs, file etc as defined in flow.xml use getOutGoing() .
        */
       // getOutGoing().write(df);
    }

    @Override
    public void cleanUp() {
    }
}
