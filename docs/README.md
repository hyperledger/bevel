# Bevel Documentation
## About
This directory contains the files required to create Hyperledger Bevel open-source documentation.
The template used is from the Hyperledger Labs project [documentation-template](https://github.com/hyperledger-labs/documentation-template).

[Material for MkDocs]: https://squidfunk.github.io/mkdocs-material/
[Mike]: https://github.com/jimporter/mike

## Pre-requisites

To test the documents and update the published site, the following tools are needed:

- A Bash shell
- git
- Python 3
- The [Material for MkDocs] theme.
- The [Mike] MkDocs plugin for publishing versions to gh-pages.
  - Not used locally, but referenced in the `mkdocs.yml` file and needed for
    deploying the site to gh-pages.

### git
`git` can be installed locally, as described in the [Install Git Guide from GitHub](https://github.com/git-guides/install-git).

### Python 3
`Python 3` can be installed locally, as described in the [Python Getting Started guide](https://www.python.org/about/gettingstarted/).

### MkDocs

The MkDocs-related items can be installed locally, as described in the [Material for MkDocs] installation instructions. The short, case-specific version of those instructions follow:

```bash
pip3 install -r pip-requirements.txt
```

### Verify Setup

To verify your setup, check that you can run `mkdocs` by running the command `mkdocs --help` to see the help text.

## Useful MkDocs Commands

The commands you will usually use with `mkdocs` are:

* `mkdocs serve` - Start the live-reloading docs server.
* `mkdocs build` - Build the documentation site.
* `mkdocs -h` - Print help message and exit.

## Adding Content

The basic process for adding content to the site is:

- Create a new markdown file under the `source` folder
- Add the new file to the table of contents (`nav` section in the `mkdocs.yml` file)

## Folder layout

    mkdocs.yml    # The configuration file.
    source/
        _static   # Contains all png/jpeg files and images
        index.md  # The documentation homepage.
        ...       # Other markdown pages, images and other files.
