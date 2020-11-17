## ROLE: `helm_component`
The `helm_component` role helps in generating value files for various Helm releases. `helm_component` uses the `templates` folder to generate Helm value files.  new helm file, it uses template files stored in template folder. The task uses a variable `type` which is used to filter through the templates in template folder.
The mapping for *type* variable and its corresponding value file is provided in `vars/main.yaml`.
To add a new template, add the `.tpl`-file to the `templates` folder and add its key/value entry in `vars/main.yaml`. 

---

### Tasks
(Variables with * are fetched from the playbook which is calling this role)

---

#### 1. "Ensures {{ values_dir }}/{{ name }} dir exists"
This task ensures that the directory to the `values_dir` exists. Calls the `shared/configuration/roles/check/setup` role.
##### Input Variables
- *`name` - Type of the Helm Release file 
- *`path` - The path where the generated files are stored
- `check` - `ensure_dir`, this ensures that the directory exists

---

#### 2. Create value file for {{ component_name }}
This task creates the value file for the role which calls it. 
##### Input Variables
- *`component_name` - The name of the component for whom the value file is created.
- *`name` - The name of the Helm Release file 
- *`values_dir` - The path where the generated files are stored
- *`type` - The type of service/component to deploy

--- 

#### 3. Helm lint
This task tests the value file for syntax errors/missing values by calling the `shared/configuration/roles/helm_lint` role and passing the value file parameter.
##### Input Variables
- `helmtemplate_type` - The type of component to lint, the template file is selected based on this `type` variable.
- `chart_path` - The path for the `charts` directory.
- `value_file` - The final path of the value file to be created along with `name`.
