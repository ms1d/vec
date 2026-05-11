#pragma once



#include "vec.cuh"




// 3D vector specialisation of vec. Implements:
//		- Cross product + assignment operator
//		- clean x,y,z aliases
template<>
struct vec<3> : vec_base<3, vec<3>> {



    union {
        float data[3];
        struct { float x, y, z; };
    };




    __host__ __device__ constexpr vec() noexcept {}

    __host__ __device__ constexpr vec(float x, float y, float z) noexcept : x(x), y(y), z(z) {}

	__host__ __device__ constexpr vec(const vec& other) noexcept : x(other.x), y(other.y), z(other.z) {}

    __host__ __device__ constexpr vec& operator=(const vec& other) noexcept {
		x = other.x; y = other.y; z = other.z;
		return *this;
	}




    // Cross product
    __host__ __device__ constexpr vec operator^(const vec& other) const noexcept {
        vec res = *this;
        res ^= other;
        return res;
    }
    __host__ __device__ constexpr vec& operator^=(const vec& other) noexcept {
        float _x = x, _y = y, _z = z;
        x = _y * other.z - _z * other.y;
        y = _z * other.x - _x * other.z;
        z = _x * other.y - _y * other.x;
        return *this;
    }



};
