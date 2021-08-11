# Docs
## About
This directory contains the files required to create open source documentation.
Tools used: [Sphinx](http://www.sphinx-doc.org/en/master/usage/installation.html)
### Configuration files
* **Index.rst** - This is the main document. Main function of this document is to serve as a welcome page, and to contain the root of the “table of contents tree” (or toctree).This is one of the main things that Sphinx adds to reStructuredText, a way to connect multiple files to a single hierarchy of documents
* **conf.py** -  The configuration directory must contain a file named conf.py. This file (containing Python code) is called the “build configuration file” and contains (almost) all configuration needed to customize Sphinx input and output behavior.
* **.md files** - Create all the markdown file which are referenced in the document tree with the appropriate content.

```
./
├── docs
│   ├── source
│   │     ├── index.rst
│   │     ├── conf.py
│   │     ├── *.md
│   ├── Makefile
|   ├── pip-requirements.txt
│   └── README.md
├── CONTRIBUTING.md
```

### Building the docs
1. Install latest sphinx
```
pip install -U Sphinx
```
2. Install the pre-requisites
```
pip install -r pip-requirements.txt
```
3. Build the documents
```
make html
or
make.bat html
```
4. Access the documents from **build/html/** folder.



