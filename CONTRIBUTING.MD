# Developing

## Prerequisites
* Git
* Visual Studio Code
  * The [VSCode ObjectScript plugin](https://marketplace.visualstudio.com/items?itemName=daimor.vscode-objectscript))
  * (Optional) The Docker Plugin
* Docker and Docker Compose

## Getting Started

First, you need to start your IRIS development instance
1. Clone this repository ``git clone https://github.com/HBTGmbH/assert-objectscript.git``
2. ``cd assert-objectscript``
3. ``docker-compose up -d``

Once IRIS has started, you can start developing. Since this is a library, and it's tested via unit tests, you won't need to constantly export your code to IRIS, but you will need the IRIS connection to peek into the class documentation.

Developing flow will be roughly like this:
1. Write a test (if possible)
2. Implement your change
3. Run unit tests and make sure everything is still running

If VSCode prompts you to, overwrite changes on the server.

## Running tests
With an active InterSystems IRIS instance (via docker-compose up -d), execute ``run-tests-in-iris.bat`` or
``run-tests-in-iris.sh``, depending on your OS (windows/linux).

This will open a shell inside your running iris container, open an iris session and prompt the test manager to run all unit tests. You do not need
to restart your container every time, since the project directoy will be mounted to ``irisdev/app``. That was, any code changes will be picked up
the next time you let the test manager run

## .vscode/settings.json

This repository is preconfigured to connect your VSCode to the docker based IRIS instance. For more information, visit the awesome [VSCode ObjectScript plugin](https://marketplace.visualstudio.com/items?itemName=daimor.vscode-objectscript)) page