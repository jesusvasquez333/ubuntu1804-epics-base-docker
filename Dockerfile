FROM ubuntu:18.04

# Install system packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    wget \
    iputils-ping \
    iproute2 \
    vim \
    libreadline6-dev \
    && rm -rf /var/lib/apt/lists/*

# Install EPICS
ENV EPICS_BASE_TOP /usr/local/src/epics/base-3.15.5
ENV EPICS_HOST_ARCH linux-x86_64
RUN mkdir -p ${EPICS_BASE_TOP}
WORKDIR ${EPICS_BASE_TOP}
RUN wget --no-check-certificate -c base-3.15.5.tar.gz https://github.com/epics-base/epics-base/archive/R3.15.5.tar.gz -O - | tar zx --strip 1 && \
    make clean && make && make install

# Update env variables
ENV PATH=${EPICS_BASE_TOP}/bin/${EPICS_HOST_ARCH}:${PATH}
ENV LD_LIBRARY_PATH=${EPICS_BASE_TOP}/lib/${EPICS_HOST_ARCH}:${LD_LIBRARY_PATH}

# Set the work directory to root
WORKDIR /

# Run /bin/bash by default
ENTRYPOINT ["/bin/bash"]