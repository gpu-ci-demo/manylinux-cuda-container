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
