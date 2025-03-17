# cellframe-wallet
CellFrame Wallet

## Build:

* The project uses Qt environment to build. To build the project, it's enough to exec the following in the project directory:
  ```
  git submodule update --init --recursive --remote
  qmake && make && make install 
  ```
* Or if you haven't cloned the project yet:
  ```
  git clone --recursive <repo>
  ```
  before building the project.

## How to install:

### Debian and Ubuntu:

* You need to obtain the package first. Either get it somewhere or create one from scratch by: 
  ```
  dpkg-buildpackage -J -uc -us --changes-option=--build=any
  ```
* Install it via dpkg
  ```
  sudo dpkg -i cellframe-node<version>.deb
  ```
  
### Prerequsites:

To successfully build, you must have following prerequisites preinstalled:

* qt5-qmake
* cdbs
* debhelper
* qtdeclarative5-dev
