FROM rocker/r-base:latest

# System libraries
RUN apt-get update \
        && apt-get install -y \
            libopenmpi-dev \
            libzmq3-dev \
            ca-certificates \
            curl \
            git \
            libcurl4-openssl-dev \
            libhiredis-dev \
            libssl-dev/unstable \
            libxml2-dev \
            pandoc \
            ssh \
            libsodium-dev

# Copy the setup script, run it, then delete it
COPY src/setup.R /
RUN Rscript setup.R && rm setup.R

# Copy all the other R files
COPY src /bluebeakai-assessment/src

# Copy the bash file and the CSV file
COPY test /bluebeakai-assessment/test

# Expose port
EXPOSE 8080

WORKDIR /bluebeakai-assessment/src
ENTRYPOINT ["Rscript","main.R"]