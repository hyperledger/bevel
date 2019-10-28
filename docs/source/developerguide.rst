Developer Guide
===============
Refer :doc:`prerequisites` to install all the pre-requisites if this is the first time.

Additional Developer prerequisites
----------------------------------
* :ref:`sphinx`

.. _sphinx:

Sphinx tool
~~~~~~~~~~~

Sphinx is a tool that makes it easy to create intelligent and beautiful documentation. 
This tool is needed to build the Blockchain Automation Framework documentation from ``docs`` folder.

* Sphinx version used 2.1.1

**Sphinx installation:**
Follow the `link <http://www.sphinx-doc.org/en/master/usage/installation.html>`_ to install sphinx documentation tool.

All Blockchain Automation Framework documentation and Sphinx Configuration files (``conf.py``) are located in `docs/source <https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/docs/source>`_ folder.
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
   developer/fabric-ansible

Helm Charts 
---------------------------

.. toctree::
   :maxdepth: 1

   developer/shared-helmcharts
   developer/corda-helmcharts
   developer/fabric-helmcharts

Jenkins 
---------------------------

.. toctree::
   :maxdepth: 1

   developer/corda-jenkins
   developer/fabric-jenkins
