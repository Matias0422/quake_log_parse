# Quake Log Parser

### Running Locally

#### Step 1: Prerequisites

Before you begin, ensure that you have Docker installed on your system. You can download and install Docker from the official Docker website: [https://docs.docker.com/get-docker/](https://docs.docker.com/get-docker/)

#### Step 2: Clone the Repository

Clone the repository containing the Dockerfile, your Ruby script, and the `.env.example` file:

```bash
git clone <repository-url>
cd <repository-directory>
```

#### Step 3: Create .env File

Create a `.env` file in the root directory of your project based on the provided `.env.example` file. Update the values of `LOG_FILE_PATH` and `LINES_BATCH_NUMBER` as needed.

```bash
cp .env.example .env
```

Edit the .env file and set the values according to your requirements:

```env
LOG_FILE_PATH=/path/to/logfile.txt
LINES_BATCH_NUMBER=100
```

#### Step 4: Build the Docker Image

Build the Docker image using the provided Dockerfile:

```bash
docker build -t quake-log-parser .
```

#### Step 5: Run the Docker Container

Run the Docker container:

```bash
docker run quake-log-parser
```

#### Step 6: Verify Execution

Verify that your Ruby script is running inside the Docker container and is using the environment variables specified in the .env file.
