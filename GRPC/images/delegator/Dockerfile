# Build a new Delegator image so the python version is free to change
ARG PYTHON_IMAGE=python:3.7.5-buster

FROM $PYTHON_IMAGE

# Copy requirements.txt to root directory to install the listed Python packages in requirements.txt.
COPY requirements.txt /

# Update the Docker Image OS, install any Python Packages from requirements.txt, and set the timezone
# in the Docker Image.
RUN apt-get update \
	&& apt-get upgrade --yes \
	&& apt-get autoremove --yes; \
	pip install \
	   -r requirements.txt \
	   --upgrade; \
	rm -rf /var/lib/apt/lists/*; \
	ln -s -f \
		/usr/share/zoneinfo/America/New_York \
		/etc/localtime \
	&& dpkg-reconfigure -f \
		noninteractive tzdata;

ARG GRPC_EXPOSED_PORT_ONE=50100
ARG GRPC_EXPOSED_PORT_TWO=50102

ENV GEMSHOME=/programs/gems \
	PYTHON_HOME=/usr/local/include/python3.7m \
	PYTHONPATH=/programs/gems \
	LD_LIBRARY_PATH=/programs/gems/gmml/lib \
	GEMSMAKEPROCS=4 \
	PYTHONUNBUFFERED=1 \
        GEMS_GRPC_SLURM_HOST=gw-slurm-head \
        GEMS_GRPC_SLURM_PORT=$GRPC_EXPOSED_PORT_TWO

RUN apt-get update\
	&& apt-get install --yes --no-install-recommends --no-install-suggests \
		swig \
		qt4-dev-tools \
		qt4-qmake \
		gdb \
		libboost-all-dev \
		graphviz \
		graphviz-dev \
	&& rm -rf /var/lib/apt/lists/*;


# Creating a USER and GROUP to be used.  Prefer to fail rather than give wrong IDs.
ARG USER_ID
ARG GROUP_ID

RUN groupadd \
		--gid $GROUP_ID \
		webster ;

RUN useradd \
		--home-dir /home/webdev \
		--shell /bin/bash \
		--create-home \
		--uid $USER_ID \
		--gid $GROUP_ID \
		webdev ;

EXPOSE $GRPC_EXPOSED_PORT_ONE $GRPC_EXPOSED_PORT_TWO
