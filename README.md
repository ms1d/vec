# vec(tor)lib

A header-only, multi-dimensional vector library for CUDA and C++.
It uses the Curiously Recurring Template Pattern (CRTP) to provide a
base class for specialized vector types (e.g. 3D).

## Dependencies

- [ms1d/commonlib](https://github.com/ms1d/commonlib) as a sibling

## Features

- **CUDA Compatible**: All methods are marked `__host__ __device__`.

- **Compile-time Sizing**: Dimensions are template parameters.

- **Specializations**: `vec<3>` includes `x, y, z` aliases via a union.

- **Precision**: Equality tests use consistent accuracy definitions (see `ms1d/common`)

- **Tests**: see `test` for the ctest suite

## Method Signatures

### Constructors and Basic Ops

- `vec()`: Default constructor.

- `vec(const float (&data)[dim])`: Initialize from an array reference.

- `vec(float x, float y, float z)`: 3D-specific constructor.

- `operator[]`: Index access to components.

- `operator==`: Equality test with tolerance.

### Vector Arithmetic

- `operator+`, `operator+=`: Vector addition.

- `operator-`, `operator-=`: Vector subtraction.

- `mag()`: Returns the magnitude (length) of the vector.

### Multiplication & Products

- `operator*(vec)`: Dot product.

- `operator*(float)`: Scalar multiplication (commutative).

- `operator*=(float)`: Scalar multiplication assignment.

## Implementation Details

The library uses a `vec_base` template to share method logic across dimensions.
See `include/vec2.cuh` and `include/vec3.cuh` to see how you can specialise
the base class for specific dimension sizes.
