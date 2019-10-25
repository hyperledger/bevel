## Jenkins Pipelines

## About ##
This folder contains the Jenkins Pipelines as code, these pipelines can be used to automate your CI/CD.

### Getting started
Ensure that you already have a Cloudbees Jenkins with master slave configuration. These jenkinsfiles have been tested with Master image: cloudbees/cje-mm:2.89.3.4

### Prerequisites
1. To run the Jenkins pipelines, a few custom slave configurations are required.
    * docker-large
    * gradleslave
    * ansible
2. Docker Registry to store the docker images.
3. Working DLT Platform installed using The Blockchain Automation Framework.

All environment variables and parameters are described in the respective jenkinsfiles. Please check them and update according to your environment.

### How-to Use the Files 

**Pipeline Files**
* buildImages.Jenkinsfile: This pipeline builds the Supply-chain docker images required for the chosen DLT Platform, and uploads them into the specified Docker Image Registry.
* deploySmartContracts.Jenkinsfile: This pipeline deploys Supply-chain smart-contracts onto the chosen DLT Platform.
* deployAPI.Jenkinsfile: This pipeline deploys the Suppyly-chain APIs (Corda Springbootserver, Fabric REST Server and Express API)

**Steps to configure pipeline**
1. On Jenkins portal, click "New Item" from the left menu, provide a name, and select  **Pipeline** from the options. Then click "OK".
2. In the **Pipeline** section below, select "Pipeline script from SCM". All other sections can be left as default or configured according to your project needs.
3. Select "Git" from the "SCM" dropdown and provide the Repository URL and branch where the jenkinsfile is stored. Also select a "Credential" from the dropdown.
4. Change the "Script Path" to the correct Jenkinsfile path depending on what pipeline you are creating. Keep all other values as default.
5. **Save** and your pipeline is configured.
6. Go to the created pipeline on Jenkins portal, and click **"Build"** or **"Build with parameters"** from the left menu. For first run, the build will take the default parameters from the jenkinsfiles, in subsequent runs, you will be able to choose the parameter on Jenkins.
7. Select the appropriate parameters and click "Build". The pipeline will start and you can see the progress.
8. Check the "Console output" for detailed output.
