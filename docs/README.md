# Docs
## About
This directory contains the files required to create open-source documentation.
Tools used: [Sphinx] (http://www.sphinx-doc.org/).
## Configuration files
* **index.rst** - This is the main document. This is one of the main things that Sphinx adds to restructured text: a way to connect multiple files to a single hierarchy of documents, including the 'table of contents tree'(or toctree).
* **conf.py**: The configuration directory must contain a file named conf.py. This file (containing Python code) is called the “build configuration file” and contains (almost) all the configuration needed to customize Sphinx input and output behavior.
* **.md files**: Create all the markdown files that are referenced in the document tree with the appropriate content.

```
./
├── docs
│   ├── source
|   |   |── index.rst
│   │   ├── conf.py
│   │   ├── *.md
│   ├── Makefile
|   ├── pip-requirements.txt
│   └── README.md
├── CONTRIBUTING.md
```

### Building the docs
1. Install the latest Sphinx.
```
pip install -U Sphinx
```
2. Install the prerequisites.
```
pip install -r pip-requirements.txt
```
3. Build the documents.
```
make HTML
or
make.bat HTML
```
4. Access the documents from the **build/html** folder.
