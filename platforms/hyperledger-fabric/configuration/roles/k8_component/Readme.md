#### [ROLE] k8_component
k8_component roles helps in generating value file for various k8 deployments.
This role consists of the following tasks

- **Ensures {{ values_dir }} dir exists:** This task ensures that the value directory is present on the ansible container which is refered by `values_dir` variable which is defined at `/platforms/hyperledger-fabric/playbooks/roles/k8_component/vars/main.yaml`

- **create {{ component_type }} file for {{ component_type_name }}:** This task creates the value file for the role which calls it. The variables, `component_type` and `component_type_name` are passes on by the role which calls this role. This task takes in the variable `type` which is the corresponding template file is chosen based on this type variable. The mapping is stored at `/platforms/hyperledger-fabric/playbooks/roles/k8_component/vars/main.yaml`. If the type is not found in the mapping then it takes in the default `default.tpl` template.