FROM ubuntu:24.04 AS base
LABEL maintainer="Atsushi Oya <atsushi@icepp.s.u-tokyo.ac.jp>"

ENV CERN=/cern
RUN apt-get update
RUN DEBIAN_FRONTEND="noninteractive" \
    apt-get install -y vim dpkg-dev cmake binutils \
        libx11-dev libxpm-dev libxft-dev libxext-dev libssl-dev \
        libc6 git openssl cmake g++ gcc wget libxmu-dev \
        libglu1-mesa-dev mesa-common-dev libffi-dev \
        libfftw3-dev \
        libhdf5-dev \
        libbz2-dev \
        liblzma-dev \
        cmake-curses-gui \
        libboost-all-dev \
        curl libcurl4-openssl-dev libmotif-dev libboost-all-dev \
        libtbb-dev librange-v3-dev libfmt-dev nlohmann-json3-dev \
        python-is-python3 \
        libxerces-c-dev \
        qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools libqt5x11extras5 qtdeclarative5-dev \
        nlohmann-json3-dev \
        patchelf \
        libpcre3 libpcre3-dev \
        xxhash \
    && \
    mkdir ${CERN}

FROM base AS python
# Originally, I was working on a package that is not compatible with > 3.10 python, though this Dockerfile only aims to reproduce the libc error
ENV PYTHON_VERSION="3.9.18"
RUN \
    cd ${CERN} && \
    mkdir python && cd python  && \
    wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz && \
    tar -zxvf Python-${PYTHON_VERSION}.tgz && \
    rm -f Python-${PYTHON_VERSION}.tgz && \
    cd Python-${PYTHON_VERSION}/ && \
    ./configure --enable-shared && \
    make -j6  && \
    make install  && \
    rm -rf ${CERN}/python/

ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/lib/x86_64-linux-gnu/:/usr/local/lib"
ENV PATH="${PATH}:/usr/local/bin"
ENV PYTHON3=/usr/local/bin/python3
ENV Python3_EXECUTABLE=/usr/local/bin/python3
ENV PYTHON_EXECUTABLE=/usr/local/bin/python3

FROM python AS pip
RUN python3 -m pip install numpy pandas "hist[plot]" scipy matplotlib uproot awkward prompt-toolkit


FROM pip AS rootdownload
ENV ROOT_VERSION="6.32.08"
RUN \
    cd ${CERN} && \
    echo "********* Installing ROOT $ROOT_VERSION *********" && \
    mkdir root && cd root  && \
    wget https://root.cern/download/root_v${ROOT_VERSION}.source.tar.gz && \
    tar -zxvf root_v${ROOT_VERSION}.source.tar.gz  && \
    rm -f root_v${ROOT_VERSION}.source.tar.gz  && \
    mkdir build  && \
    mkdir install 

FROM rootdownload AS root
RUN \
    cd ${CERN}/root/build  && \
    cmake -DCMAKE_INSTALL_PREFIX=../install \
          -DCMAKE_BUILD_TYPE="Release " \
          -Dfail-on-missing=OFF \
          -Dmathmore=ON \
          -Droofit=ON \
          -Dgdml=ON \
          -DPython3_EXECUTABLE=/usr/local/bin/python3 \
          -DPYTHON_EXECUTABLE=/usr/local/bin/python3 \
          -Dbuiltin_fftw3=ON \
          -DCMAKE_C_COMPILER=/usr/bin/gcc \
          -DCMAKE_CXX_COMPILER=/usr/bin/g++ \
          -DCMAKE_CXX_STANDARD=20 \
          ../root-${ROOT_VERSION}/  && \
    make -j6 && \
    make install


FROM root AS test
COPY setup_container_env.sh ${CERN}

FROM test AS finalsetup
RUN  rm -r ${CERN}/root/build/ && \
     rm -r ${CERN}/root/root-6.32.08/

FROM pip AS release
COPY --from=finalsetup ${CERN} ${CERN}
ENV PATH=/usr/local/bin:$PATH
RUN ln -s /usr/local/bin/python3 /usr/local/bin/python 

ENV TERM=xterm-256color
COPY setup_container_env.sh ${CERN}
SHELL ["/bin/bash", "-c"]
CMD source ${CERN}/setup_container_env.sh && \
    /bin/bash
