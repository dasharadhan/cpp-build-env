# C++ Build Environment

This repository hosts a **standardized build environment** for C++ projects. It produces a Docker image containing all necessary compilers, build systems, and static analysis tools required to build and test downstream libraries.

**Docker Image:** `ghcr.io/dasharadhan/cpp-build-env:latest`

## 🛠 What's Inside?

This image is based on **Ubuntu 24.04 LTS** and includes the following tools:

| Tool         | Version         | Purpose                                          |
| :----------- | :-------------- | :----------------------------------------------- |
| GCC / g++    | Latest (System) | GNU Compiler Collection                          |
| LLVM / Clang | 19.x            | Alternate Compiler, `clang-format`, `clang-tidy` |
| CMake        | Latest (apt)    | Build system generator                           |
| git          | Latest (apt)    | Version control                                  |
| Python       | 3.10+           | Scripting and `run-clang-tidy` support           |
| Colordiff    | Latest          | Used for colored diff output                     |
| Eigen        | 5.0.0           | Linear Algebra Library                           |
| spdlog       | 1.16.0          | C++ Logging Library                              |
| tinyxml2     | 11.0.0          | C++ XML Parsing Library                          |

## 🚀 How to Use

### 1. As a Base Image (Dockerfile)

When creating a new library (e.g., `lib-a`), start your Dockerfile with this image. You do **not** need to install any compilers or build tools.

```dockerfile
FROM ghcr.io/dasharadhan/cpp-build-env:latest

WORKDIR /src

# Clone your library
RUN git clone https://github.com/your-username/lib-a.git

# Do other stuff

# Build your library using the pre-installed tools
RUN cmake -S lib-a -B build \
    -DCMAKE_BUILD_TYPE=Release

RUN cmake --build build --target install

```

### 2. In GitHub Actions (CI)

Use this image to run your builds/linters/tests. This ensures that your CI matches your local development environment exactly.

```yaml
jobs:
  build:
    runs-on: ubuntu-latest

    container:
      image: ghcr.io/dasharadhan/cpp-build-env:latest
      options: --user root # Fix permissions
      credentials:
        username: ${{ github.actor }}
        password: ${{ secrets.GITHUB_TOKEN }}

    steps:
      - name: Checkout code
        uses: actions/checkout@v6

      - name: Build
        run: cmake -S . -B build && cmake --build build
```

### 3. Local Development

You can run this container locally to debug build issues without polluting your host machine

```bash
docker run -it --rm \
  -v $(pwd):/workspace \
  -w /workspace \
  ghcr.io/dasharadhan/cpp-build-env:latest \
  bash
```

## 📦 Maintenance & Updates

### Adding New Tools

Edit the Dockerfile in this repository.

Open a Pull Request.

Once merged to main, the [publish.yml](.github/workflows/publish.yml) workflow will automatically build and push the new image tag.

### Versioning

`latest`: Tracks the main branch.
