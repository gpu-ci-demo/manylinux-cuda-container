# Minimal example for building and testing Python wheels with CUDA code

This repository presents an end-to-end example for building and testing Python wheels with CUDA code.

## Locally build and test
To build the Python wheel, run:
```
python -m build -v --wheel
```

To run tests, run:
```
pip install dist/example-0.0.1-cp312-abi3-linux_x86_64.whl
pytest -v tests
```

## Workflow overviews
* **containers.yaml**: Build two Docker containers, to be used for building and testing the Python wheel.
  The Dockerfile definitions are found in the ``ci/`` subdirectory. Once the containers are built,
  they are pushed to the GitHub Packages registry.
  - ``cuda_build``: Rockylinux 8 based container, to be used for building the wheel
  - ``cuda_test``: Ubuntu 24.04 based container, to be used for testing the wheel
* **main.yaml**: Performs the following steps in order.
  1. Build the Python wheel, inside the ``cuda_build`` container.
  2. Patch the Python wheel, inside the container ``quay.io/pypa/manylinux_2_28_x86_64``.
     The patching ensures that the wheel is compatible with a wide range of Linux environments.
     See [the manylinux standard](https://github.com/pypa/manylinux) for more details.
  3. Test the Python wheel, inside the ``cuda_test`` container.

## Next step: Configure GitHub organization settings
To enable GPU runners on GitHub Actions, you should consult the article
[GitHub Action workflows with GPUs](https://betatim.github.io/posts/github-action-with-gpu/)
by Tim Head.
