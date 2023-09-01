Developer Guide
===============

Developing in Hyperledger Bevel involves the following:

- Updating the Helm Charts to customize the deployments/jobs.
- Updating the Ansible Roles to add new features to Bevel.
- Testing the updated Ansible Roles and Charts.

Following guides provide a quickstart development environment, although for improved developer experience, developers should use a Linux based system which has all the tools installed as per the Ansible controller Dockerfile.

.. admonition:: Important
   
   Bevel with minikube is not encouraged because it takes a lot more time than cloud deployments thereby resulting in poor developer experience.


Quickstart Guides 
---------------------------

.. toctree::
   :maxdepth: 1
   
   developer/dev_prereq
   developer/bevel_minikube_setup
   developer/docker-build
   developer/bevel_fabric_minikube_setup

Additional Developer prerequisites
----------------------------------
* :ref:`sphinx`

.. _sphinx:

Sphinx tool
~~~~~~~~~~~

Sphinx is a tool that makes it easy to create intelligent and beautiful documentation. 
This tool is needed to build Hyperledger Bevel documentation from ``docs`` folder.

* Sphinx version used 2.1.1

**Sphinx installation:**
Follow the `link <http://www.sphinx-doc.org/>`_ to install sphinx documentation tool.

All Hyperledger Bevel documentation and Sphinx Configuration files (``conf.py``) are located in `docs/source <https://github.com/hyperledger/bevel/tree/main/docs/source>`_ folder.
To build the documentation, execute the following command from `docs` directory:

.. code:: bash

    make html
    # or for Windows
    .\Make.bat html


Ansible Roles and Playbooks 
---------------------------

.. toctree::
   :maxdepth: 1

   developer/shared
   developer/corda-ansible
   developer/corda-ent-ansible
   developer/fabric-ansible
   developer/indy-ansible
   developer/quorum-ansible
   developer/besu-ansible
   developer/substrate-ansible

Helm Charts 
---------------------------

.. toctree::
   :maxdepth: 1

   developer/shared-helmcharts
   developer/corda-helmcharts
   developer/corda-ent-helmcharts
   developer/fabric-helmcharts
   developer/indy-helmcharts
   developer/quorum-helmcharts
   developer/besu-helmcharts
   developer/substrate-helmcharts

Jenkins Automation
---------------------------

.. toctree::
   :maxdepth: 1

   developer/jenkins
