## clean/gitops
This role deletes all the gitops release files.

### Tasks:
#### 1. Delete release files
This task deletes all the files from the release directory.
##### Input Variables:
 - release_dir: A directory's path of deployed release, which may be deleted.

#### 2. Git Push
This task push changes into remote branch.
It calls role *{{ playbook_dir }}/../../shared/configuration/roles/git_push*

##### Input Variables:
 - GIT_DIR: A path of git directory. By default "{{ playbook_dir }}/../../../"
 - GIT_REPO: Url for git repository. It uses a variable *{{ gitops.git_repo }}* 
 - GIT_USERNAME: Username of git repository. It uses a variable *{{ gitops.username }}*
 - GIT_EMAIL: User's email of git repository. It uses a variable *{{ gitops.email }}*
 - GIT_PASSWORD: User's password of git repository. It uses a variable *{{ gitops.password }}*
 - GIT_BRANCH: A name of branch, where are pushed Helm releases. It uses a variable *{{ gitops.branch }}*
 - GIT_RESET_PATH: A path of git directory, which is reseted for committing. Default value is *platforms/hyperledger-indy/configuration*
 - msg: A message, which is printed, when the role is running.