## create/helm_component
This role create the the helm components by template via inserted type.

## Tasks:
### 1. Ensures {{ values_dir }}/{{ type }} dir exists
This task ensure, that release folder for value file exists.
It the folder doesn't exist, then creates them.

#### Variables:
 - values_dir: Release directory, where are stored generated files for gitops.
 - type: A type of helm release, which which may be generated.

### 2. Create value file for {{ component_name }}
This task creates the value file for the helm release.

#### Variables:
 - component_name: A name of Helm release.
 - type: A type of Helm release.
 - charts_dir: A directory, where are stored Helm charts.
 
#### Input Variables:
 - chart: A chart name.
 - chart_path: A directory, where are stored Helm charts.

#### Templates:
 - webserver.tpl: A template to create Indy WebServer Helm release.
 
#### Vars:
 - helm_templates:
    webserver: webserver.tpl

#### Output:
 - value file of Helm release

### 3. Helm lint
This task tests the value file for syntax errors/ missing values.
This is done by calling the helm_lint role and passing the value file parameter
When a new helm_component is added, changes should be made in helm_lint role as well

This task calls role from *../../../supplychain-app/configuration/roles/helm_lint*

#### Input Variables:
 - helmtemplate_type: A type of helm release, which may be created.
 - chart_path: A directory, where are stored Helm charts.
 - value_file: A value file which will be generated with path.
 - charts.webserver: Overriden variable for Helm Lint. By default is set to `webserver` 
