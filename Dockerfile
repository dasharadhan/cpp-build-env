FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# --- Library Version Tags ---
# These arguments define the specific tags to check out.
ARG EIGEN_TAG=5.0.0
ARG TINYXML_TAG=11.0.0
ARG SPDLOG_TAG=v1.16.0

# Install System Tools
RUN apt-get update && apt-get install -y \
    wget \
    git \
    build-essential \
    software-properties-common \
    lsb-release \
    gcc \
    g++ \
    cmake \
    python3 \
    python3-pip \
    python3-venv \
    colordiff \
    && rm -rf /var/lib/apt/lists/*

# Install LLVM 19
RUN wget https://apt.llvm.org/llvm.sh && \
    chmod +x llvm.sh && \
    ./llvm.sh 19 && \
    apt-get install -y clang-format-19 clang-tidy-19 libclang-rt-19-dev && \
    rm llvm.sh && rm -rf /var/lib/apt/lists/*

# Build & Install Libraries
WORKDIR /tmp

# --- Eigen ---
RUN git clone --branch ${EIGEN_TAG} --depth 1 https://gitlab.com/libeigen/eigen.git && \
    cd eigen && \
    mkdir build && cd build && \
    cmake .. \
      -DCMAKE_INSTALL_PREFIX=/usr/local \
      -DCMAKE_BUILD_TYPE=Release && \
    make install && \
    cd /tmp && rm -rf eigen

# --- TinyXML-2 ---
RUN git clone --branch ${TINYXML_TAG} --depth 1 https://github.com/leethomason/tinyxml2.git && \
    cd tinyxml2 && \
    mkdir build && cd build && \
    cmake .. \
      -DCMAKE_INSTALL_PREFIX=/usr/local \
      -DBUILD_SHARED_LIBS=ON \
      -DCMAKE_BUILD_TYPE=Release && \
    make -j$(nproc) && \
    make install && \
    cd /tmp && rm -rf tinyxml2

# --- spdlog ---
RUN git clone --branch ${SPDLOG_TAG} --depth 1 https://github.com/gabime/spdlog.git && \
    cd spdlog && \
    mkdir build && cd build && \
    cmake .. \
      -DCMAKE_INSTALL_PREFIX=/usr/local \
      -DSPDLOG_BUILD_SHARED=ON \
      -DCMAKE_BUILD_TYPE=Release && \
    make -j$(nproc) && \
    make install && \
    cd /tmp && rm -rf spdlog

# Reset working directory
WORKDIR /
