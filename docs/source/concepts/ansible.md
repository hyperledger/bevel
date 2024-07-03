[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Ansible

[Ansible](https://docs.ansible.com/ansible/latest/index.html) is an open-source automation tool that simplifies the process of managing IT infrastructure and automating repetitive tasks. It is designed to make complex configuration and deployment processes easier, faster, and more consistent. Ansible is agentless, meaning it doesn't require any software to be installed on the managed hosts, making it lightweight and easy to set up.

!!! tip

    With 1.1 Release, Ansible is optional and can be used only for large deployment automation.

With Ansible, you can define your infrastructure as code using simple, human-readable YAML files called "playbooks." Playbooks describe the desired state of your systems, specifying which tasks should be performed and in what order. These tasks can range from simple tasks like copying files or installing packages to more complex tasks like configuring services or managing cloud resources.

Here's how Ansible works in a nutshell:

1. Inventory: In Ansible, you organize your hosts (servers, virtual machines, or network devices) into an inventory file. This file lists the IP addresses or hostnames of the managed machines, and you can group them based on their roles or attributes.

1. Playbooks: Playbooks are written in YAML format and describe the tasks you want to perform on your hosts. Each playbook consists of one or more "plays," and each play includes a list of tasks.

1. Tasks: Tasks are individual units of work in Ansible. They represent actions that Ansible will take on the managed hosts, such as installing packages, creating files, or starting services.

1. Modules: Ansible uses "modules" to perform tasks on the managed hosts. Modules are small pieces of code that execute specific actions. Ansible has a vast library of built-in modules, covering a wide range of tasks.

1. Execution: Once you have defined your playbook and inventory, you can run Ansible to execute the tasks on the targeted hosts. Ansible connects to the hosts through SSH (by default) and executes the tasks in the order specified.

1. Idempotence: One of the key principles of Ansible is idempotence. This means that you can run an Ansible playbook multiple times, and the result will be the same as running it just once. If a task has already been performed and the system is in the desired state, Ansible will not repeat it.

1. Reporting: Ansible provides detailed output during playbook execution, showing which tasks were successful and which ones failed. This helps you easily identify any issues that need to be addressed.

Ansible is widely used for automating various IT tasks, including server provisioning, application deployment, configuration management, and continuous delivery. Its simplicity, ease of use, and versatility make it an excellent choice for both beginners and experienced IT professionals to manage and automate their infrastructure efficiently.

Hyperledger Bevel extensively uses Ansible playbooks along with roles to spin up a DLT/Blockchain network. Ansible is mainly used as a templating engine to create the Helm Values files for [GitOps](./gitops.md).
