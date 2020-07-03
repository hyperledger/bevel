# **Ansible**

[Ansible](https://docs.ansible.com/ansible/latest/index.html) is an automation command line tool that helps IT technicians easily achieve system configuration, software deployment and other complex tasks in orchestration.

Ansible provisions several types of command line tools such as ansible, ansible-playbook and ansible-galaxy etc. Each serves different scenarios so that a user can choose the most appropriate one or more to be adopted in the chosen scenario(s).

Below gives a simple description of the three mentioned above, and a user can use the link to find more information for each of them.
- [ansible](https://docs.ansible.com/ansible/latest/user_guide/intro_getting_started.html): it is the simplistic command line tool that enables a user to quickly achieve simple IT tasks, e.g. list one or more local/remote machines' information.
- [ansible-playbook](https://docs.ansible.com/ansible/latest/user_guide/playbooks.html): it is an advanced command line that will run one or more Ansible playbooks (i.e. YAML files that have all the steps configured to achieve one or more complex tasks). Ansible [roles](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html) are defined to group relavant configurations together that can be resuable in multi playbooks.
- [ansible-galaxy](https://docs.ansible.com/ansible/latest/reference_appendices/galaxy.html): it is an advanced command line that can run existing Ansible roles predefined by other users in the Ansible community.

The Blockchain Automation Framework extensively uses Ansible playbooks along with roles to spin up a DLT/Blockchain network. For instance, to issue certificates for each node in the DLT/Blockchain network, and then put the certificates to HashiCorp [Vaults](./vault.md). In the Blockchain Automation Framework, there are different Ansible playbooks being designed, and the key player that makes the whole DLT/Blockchain network set-up to happen automatically is the roles defined in the playbooks following a specific order. 