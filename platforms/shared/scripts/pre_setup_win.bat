@echo off
@setlocal enableextensions
@cd /d "%~dp0"


echo "		 ____          ______ 		"
echo "		|  _ \   /\   |  ____|		"
echo "		| |_) | /  \  | |__   		"
echo "		|  _ < / /\ \ |  __|  		"
echo "		| |_) / ____ \| |     		"
echo "		|____/_/    \_\_|     		"



REM Check for admin privilages
REM If not present, then exit
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Success: Administrative permissions confirmed.
) else (
    echo Failure: Current permissions inadequate. Press any key to exit the setup..
	pause
	exit
)
REM ############################################################################################################################################################
REM ############################################################################################################################################################

REM Check for virtualization
REM If not present, then exit
systeminfo|findstr /C:"Virtualization Enabled In Firmware:">Virtualization.txt
set /P CHECK_VIRTUALIZATION=<Virtualization.txt
del Virtualization.txt
set CHECK_VIRTUALIZATION=%CHECK_VIRTUALIZATION:*: =%
if %CHECK_VIRTUALIZATION%==No (
echo Virtualization is not enabled. Please enable virtualization and re-run the script. Exiting..
PAUSE
EXIT
)

REM ############################################################################################################################################################
REM ############################################################################################################################################################

REM Check for software versions, if present
REM If version mismatch, prompt to delete software and exit
echo "Creating %cd%\project directory."
mkdir project
mkdir project\bin
SET PATH=%cd%\project\bin;%PATH%
echo "Checking versions of git, vault cli, docker toolbox and minikube"
git --version>GIT_VERSION.txt
docker --version>DOCKER_VERSION.txt
vault --version>VAULT_VERSION.txt
minikube version>MINIKUBE_VERSION.txt
set /P GIT_VERSION=<GIT_VERSION.txt
set /P DOCKER_VERSION=<DOCKER_VERSION.txt
set /P VAULT_VERSION=<VAULT_VERSION.txt
set /P MINIKUBE_VERSION=<MINIKUBE_VERSION.txt
for /f "delims=" %%a in (MINIKUBE_VERSION.txt) do set "MINIKUBE_VERSION=%%a"&goto :stop
:stop
del GIT_VERSION.txt DOCKER_VERSION.txt VAULT_VERSION.txt MINIKUBE_VERSION.txt

if "%GIT_VERSION%" NEQ "git version 2.26.0.windows.1" (
	goto GIT_CHECK
) else (
	echo "Git is already installed with git version 2.26.0.windows.1"
)
:CHECK_DOCKER
if "%DOCKER_VERSION%" NEQ "Docker version 19.03.1, build 74b1e89e8a" (
	goto DOCKER_CHECK
) else (
	echo "Docker is already installed with Docker version 19.03.1, build 74b1e89e8a"
)
:CHECK_VAULT
if "%VAULT_VERSION%" NEQ "Vault v1.3.4" (
	goto VAULT_CHECK
) else (
	echo "Vault cli already installed with version 1.3.4"
)
:CHECK_MINIKUBE
if "%MINIKUBE_VERSION%" NEQ "minikube version: v1.8.2" (
	goto MINIKUBE_CHECK
) else (
	echo "Minikube already installed with minikube version: v1.8.2"
)
:CONTINUE_WITH_SCRIPT


REM ############################################################################################################################################################
REM ############################################################################################################################################################

REM Installing GIT binary
REM Check if the git is already present or not, if already present, then this step will be skipped
git --version
set GITVAR=%errorlevel%
if %GITVAR%==9009 (
echo Starting git download v2.26.0 64 bit
powershell -Command "Invoke-WebRequest https://github.com/git-for-windows/git/releases/download/v2.26.0.windows.1/Git-2.26.0-64-bit.exe -OutFile gitsetup.exe"
if %ERRORLEVEL%==1 (
echo Bad internet/url. Exiting...
PAUSE
EXIT
)
echo Git download successful
echo Installing git. Press 'Next' at each prompt so that it gets installed with default settings
START /WAIT gitsetup.exe
echo git successfully installed. Please restart machine and then execute this script again.
) else (
echo git already installed.
)
REM ############################################################################################################################################################
REM ############################################################################################################################################################

REM Configuring git username and useremail
echo Please create a github account and continue
PAUSE

set /p GIT_USERNAME=Enter git username: 
"C:\Program Files\Git\bin\sh.exe" --login -i -c "git config user.name" > CHECK_USERNAME.txt
set /P CHECK_USERNAME=<CHECK_USERNAME.txt
if %CHECK_USERNAME% NEQ %GIT_USERNAME% ( 
echo Updating username
"C:\Program Files\Git\bin\sh.exe" --login -i -c "git config --global user.name %GIT_USERNAME%"
)
del CHECK_USERNAME.txt

set /p GIT_USEREMAIL=Enter user email: 
"C:\Program Files\Git\bin\sh.exe" --login -i -c "git config user.email" > CHECK_USEREMAIL.txt
set /P CHECK_USEREMAIL=<CHECK_USEREMAIL.txt
if %CHECK_USEREMAIL% NEQ %GIT_USEREMAIL% (
echo Updating useremail
"C:\Program Files\Git\bin\sh.exe" --login -i -c "git config --global user.email %GIT_USEREMAIL%"
)
del CHECK_USEREMAIL.txt

echo Git configured successfully

echo Configuring git so that EOLs are not updated to Windows CRLF
"C:\Program Files\Git\bin\sh.exe" --login -i -c "git config --global core.autocrlf false"

REM ############################################################################################################################################################
REM ############################################################################################################################################################

REM Setting up of forked repo on local machine and checkout to a given branch ( defaulted to local)
echo Please fork the blockchain-automation-framework repository from browser and then continue ...
PAUSE
echo Generating key file for Git
"C:\Program Files\Git\bin\sh.exe" --login -i -c 'ssh-keygen -q -N "" -f ~/.ssh/gitops'
"C:\Program Files\Git\bin\sh.exe" --login -i -c "eval $(ssh-agent)"

echo Add the following public key to your Git Account with "gist,repo" access then continue ...
"C:\Program Files\Git\bin\sh.exe" --login -i -c "cat ~/.ssh/gitops.pub"
PAUSE

chdir project
set /p REPO_URL=Enter your forked repo clone url (HTTPS url): 
git clone %REPO_URL%
set /p REPO_BRANCH=Enter branch(default is local): 
chdir blockchain-automation-framework
if NOT DEFINED REPO_BRANCH set "REPO_BRANCH=local"
echo Ignore errors here, if any.
"C:\Program Files\Git\bin\sh.exe" --login -i -c "git checkout %REPO_BRANCH%"
if %ERRORLEVEL% == 1 (
"C:\Program Files\Git\bin\sh.exe" --login -i -c "git checkout -b develop"
"C:\Program Files\Git\bin\sh.exe" --login -i -c "git checkout -b %REPO_BRANCH% develop"
"C:\Program Files\Git\bin\sh.exe" --login -i -c "git checkout %REPO_BRANCH%"
"C:\Program Files\Git\bin\sh.exe" --login -i -c "git push -u origin %REPO_BRANCH%"
)
chdir ../..

REM ############################################################################################################################################################
REM ############################################################################################################################################################

REM Setting up docker toolbox
REM Check if the docker toolbox is already present or not, if already present, then this step will be skipped
docker --version
set DOCKERVAR=%errorlevel%
if %DOCKERVAR%==9009 (
echo Downloading dockertoolbox
powershell -Command "Invoke-WebRequest https://github.com/docker/toolbox/releases/download/v19.03.1/DockerToolbox-19.03.1.exe -OutFile dockertoolbox.exe"
if %ERRORLEVEL%==1 (
echo Bad internet/url. Exiting...
PAUSE
EXIT
)
echo Installing docker toolbox
echo Installing docker toolbox. Press 'Next' at each prompt so that it gets installed with default settings
echo Do not uncheck the virtualbox installation option in the installer. This step ensures, virtualbox gets installed with docker toolbox
START /WAIT dockertoolbox.exe
echo Docker toolbox successfully installed
) else (
echo Docker Toolbox already installed
)
REM Uncomment the below line if you want to run the docker shell and intialize docker for the first time here itself.
REM "C:\Program Files\Git\bin\bash.exe" --login -i "C:\Program Files\Docker Toolbox\start.sh"

REM ############################################################################################################################################################
REM ############################################################################################################################################################

REM Setting up of Hashicorp Vault Server
REM Check if the Hashicorp Vault is already installed or not, if already present, then this step will be skipped
vault --version
set VAULTVAR=%errorlevel%
if %VAULTVAR%==9009 (
powershell -Command "Invoke-WebRequest https://releases.hashicorp.com/vault/1.3.4/vault_1.3.4_windows_amd64.zip -OutFile vault.zip"
if %ERRORLEVEL%==1 (
echo Bad internet/url. Exiting...
PAUSE
EXIT
)
powershell -Command "Expand-Archive -Force vault.zip .\project\bin"
)

REM Killing explorer.exe to set the environment variables
REM taskkill /f /im explorer.exe && explorer.exe
(
echo ui = true
echo storage "file" {
echo  path    = "./project/data"
echo }
echo listener "tcp" {
echo   address     = "0.0.0.0:8200"
echo   tls_disable = 1
echo }
) > config.hcl

start /min vault server -config=config.hcl
echo Vault is running in other cmd (minimized, do not close it, or the vault will stop)
echo Open browser at http://localhost:8200, provide 1 and 1 in both fields to initialize Vault
echo Click Download keys or copy the keys. Then come back here (no need to unseal from browser).

set /p VAULT_TOKEN=Enter vault token: 
set /p VAULT_KEY=Enter vault key: 
set VAULT_ADDR=http://127.0.0.1:8200
set VAULT_TOKEN=%VAULT_TOKEN%
vault operator unseal %VAULT_KEY%
vault secrets enable -version=1 -path=secret kv

REM ############################################################################################################################################################
REM ############################################################################################################################################################

REM Setting up of minikube
REM Check if Minikube is already installed or not, if already present, then this step will be skipped
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" --version
set VIRTUALBOXVAR=%errorlevel%
minikube status
set MINIKUBEVAR=%errorlevel%
if %VIRTUALBOXVAR% NEQ 9009 if %VIRTUALBOXVAR% NEQ 3 (
  if %MINIKUBEVAR%==9009 (
  powershell -Command "Invoke-WebRequest https://github.com/kubernetes/minikube/releases/download/v1.8.2/minikube-windows-amd64.exe -OutFile minikube.exe"
	if %ERRORLEVEL%==1 (
	echo Bad internet/url. Exiting...
	PAUSE
	EXIT
	)
	move minikube.exe .\project\bin\
  )else (
   echo Minikube is already installed
  )
)else (
  echo Virtualbox is not installed. Press any key to exit the setup...
  pause
  exit
)

set /p RAMSIZE=Enter ram to be used by minikube(MB):  
set /p CPUCOUNT=Enter cpu cores to be used by minikube: 
set /p DISKSIZE=Enter Disk Storage Size to be used by minikube(MB): 
minikube config set memory %RAMSIZE%
minikube config set cpus %CPUCOUNT%
minikube config set disk-size %DISKSIZE%
minikube config set kubernetes-version v1.15.4
minikube delete
minikube start --vm-driver=virtualbox
minikube status

echo "		 ____          ______ 		"
echo "		|  _ \   /\   |  ____|		"
echo "		| |_) | /  \  | |__   		"
echo "		|  _ < / /\ \ |  __|  		"
echo "		| |_) / ____ \| |     		"
echo "		|____/_/    \_\_|     		"




PAUSE
EXIT 

:GIT_CHECK
if ["%GIT_VERSION%"]==[""] (
	echo "Git not present. Git will be installed via this script"
	goto CHECK_DOCKER
) else (
	goto GIT_FAILED
)
:GIT_FAILED
echo "Git version mismatched. Remove git and then run the script again."
PAUSE
EXIT

:DOCKER_CHECK
if ["%DOCKER_VERSION%"]==[""] (
	echo "Docker toolbox not present. Docker toolbox will be installed via this script"
	goto CHECK_VAULT
) else (
	goto DOCKER_FAILED
)
:DOCKER_FAILED
echo "Docker toolbox version mismatched. Remove docker toolbox and then run the script again."
PAUSE
EXIT

:VAULT_CHECK
if ["%VAULT_VERSION%"]==[""] (
	echo "Vault cli not present. Vault cli will be installed via this script"
	goto CHECK_MINIKUBE
) else (
	goto VAULT_FAILED
)
:VAULT_FAILED
echo "Vault cli version mismatched. Remove vault cli and then run the script again."
PAUSE
EXIT

:MINIKUBE_CHECK
if ["%MINIKUBE_VERSION%"]==[""] (
	echo "Minikube not present. Minikube will be installed via this script"
	goto CONTINUE_WITH_SCRIPT
) else (
	goto MINIKUBE_FAILED
)
:MINIKUBE_FAILED
echo "Minikube version mismatched. Remove minikube and then run the script again."
PAUSE
EXIT