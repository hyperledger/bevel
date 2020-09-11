Developer Guide
===============

Quickstart Guides 
---------------------------

.. toctree::
   :maxdepth: 1
   
   developer/dev_prereq
   developer/baf_minikube_setup
   developer/docker-build

Additional Developer prerequisites
----------------------------------
* :ref:`sphinx`
* :ref:`molecule`

.. _sphinx:

Sphinx tool
~~~~~~~~~~~

Sphinx is a tool that makes it easy to create intelligent and beautiful documentation. 
This tool is needed to build the Blockchain Automation Framework documentation from ``docs`` folder.

* Sphinx version used 2.1.1

**Sphinx installation:**
Follow the `link <http://www.sphinx-doc.org/en/master/usage/installation.html>`_ to install sphinx documentation tool.

All the Blockchain Automation Framework documentation and Sphinx Configuration files (``conf.py``) are located in `docs/source <https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/docs/source>`_ folder.
To build the documentation, execute the following command from `docs` directory:

.. code:: bash

    make html
    # or for Windows
    .\Make.bat html

.. _molecule:

Molecule
~~~~~~~~~~~

`Molecule <https://molecule.readthedocs.io/en/latest/>`__ is designed to aid in the development and testing of `Ansible <https://ansible.com/>`_ roles.
In BAF, Molecule is used to check for common coding standards, yaml errors and unit testing Ansible code/roles.


* Molecule version used 2.22

**Requirements**

* Docker Engine
* Python3 (and pip configured with python3)

**Molecule installation**
Please refer to the `Virtual environment`_ documentation for installation best
practices. If not using a virtual environment, please consider passing the
widely recommended `'--user' flag`_ when invoking ``pip``.

.. _Virtual environment: https://virtualenv.pypa.io/en/latest/
.. _'--user' flag: https://packaging.python.org/tutorials/installing-packages/#installing-to-the-user-site

.. code-block:: bash

    $ pip install --user 'molecule[docker]'

The existing test scenarios are found in the `molecule` folder under configuration of each platform e.g. `platforms/shared/configuration/molecule <https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/shared/configuration/molecule>`__ folder.

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

Jenkins Automation
---------------------------

.. toctree::
   :maxdepth: 1

   developer/jenkins
