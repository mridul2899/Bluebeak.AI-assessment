# Bluebeak.ai-assessment

## Table of Contents
1. Project Description
2. Installation Guide
3. Description of Files
4. To-Do

## Project Description
This project demonstrates the basic implementation of an API created with [plumber](https://www.rplumber.io/) in [R](https://www.r-project.org/) based backend. The API, when called, takes a CSV file and does the following operations:
- Copies the file into the backend
- Creates a preview of the file, containing only some information from it
- Creates a basic description of the columns contained in the file and their type of contents
- Creates a file containing the missing profile for the data
- Creates a list of all files stored in the root directory to which the backend writes

## Installation Guide
The project can be installed on a [Docker](https://www.docker.com/) container by building the project. As of now, the project has been built and tested on Ubuntu 18.04.
The steps for building and running the project are as follows:
1. Install Docker if not already installed
```console
foo@bar:~$ curl -fsSL https://get.docker.com -o get-docker.sh
foo@bar:~$ chmod +x get-docker.sh
foo@bar:~$ ./get-docker.sh
```
2. Clone the Git Repository
```console
foo@bar:~$ git clone https://github.com/mridul2899/Bluebeak.AI-assessment.git
```
3. Enter into the repository and give permissions to bash script for building the project. Then run the script.
```console
foo@bar:~$ cd Bluebeak.AI-assessment
foo@bar:~/Bluebeak.AI-assessment$ chmod +x build_run.sh
foo@bar:~/Bluebeak.AI-assessment$ ./build_run.sh
```
4. Once the build, the bash script will also run the docker container. Now, we will need to run the testing script which will be run from the host. Now open another terminal to run the testing script.
```console
foo@bar:~/Bluebeak.AI-assessment$ cd test
foo@bar:~/Bluebeak.AI-assessment/test$ chmod +x bench_from_host.sh
foo@bar:~/Bluebeak.AI-assessment/test$ ./bench_from_host.sh
```

Post running these, after some time, the time taken for 100 instances of execution will be displayed on the terminal used for running the test script.

## Description of Files
The project contains the following files:
- `src`
  1. `setup.R` - This file contains the R libraries that are needed to be installed. This file is run when the docker container is built.
  2. `main.R` - This is the file that is run by the docker and only contains the code to start plumber.
  3. `plumber.R` - This contains the plumber code for defining the end point and the parameters. It calls the function responsible to handle the API request.
  4. `function_r6.R` - This file contains the function that is being called by the API. The function has been implemented with the help of [R6](https://r6.r-lib.org/articles/Introduction.html) class.
  5. `function.R` - This file contains the originally given function, without refactoring.

- `test`
  1. `bench_from_host.sh` - This script automatically calls the API exposed by the docker container from the host, a hundred times and benchmarks the time taken.
  2. `bench.sh` - This script can be used to perform the above task locally.
  3. `newt.csv` - This is the data file that is used by the API function for analysis.

- `dockerfile` - This file is used by docker to build the project and install dependencies.
- `build_run.sh` - This is the bash script to automate the build process and to run the project on docker container.

## To-Do
The following things are still being done the repository owner and are expected to be completed shortly:
- Using load balancer
- Exploring avenues for better use of parallelization
- Using `pkgr` for installation of R libraries
- Using a Linux based Docker container for building and testing the project, without dependency on the OS.
