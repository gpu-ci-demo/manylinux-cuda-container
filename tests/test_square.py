import numpy as np
from cuda.bindings import runtime

import example


def test_cuda_device_available():
    status, _ = runtime.cudaGetDeviceCount()
    assert status == runtime.cudaError_t.cudaSuccess


def test_square():
    preds = np.asarray(example.square([1.0, 2.0]))
    np.testing.assert_almost_equal(preds, [1.0, 4.0], decimal=6)
