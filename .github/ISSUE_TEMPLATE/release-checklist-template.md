---
name: Release checklist template
about: Create a Release checklist issue item for Hyperledger Bevel releases
title: ''
---
# Relase Checklist

## Pre-release Test Checklist
- [ ] The release checklist issue is created for the release ?
- [ ] Sprints in the release are closed ?
- [ ] The release changelog and READMEs are updated ?
* Documentation
    - [ ] The documents have been updated with release dates ?
    - [ ] The rollback process is documented ?
    - [ ] The version numbers are incremented ?
* Testing
    - [ ] Smoke test scenario are create and tested ?
    - [ ] All new functionality are manually tested on a release build ?
    - [ ] CI/CD verified and working ?
- [ ] All stakeholders signed off for the release
- [ ] The code is mergered into main


## Post-release Test Checklist
- [ ] CI/CD pipeline passed
- [ ] The new release instructions work using the released artifact?
- [ ] Read the docs reflect with updated release changes and tags
- [ ] Release communitations are sent
- [ ] Close the release checklist issue
