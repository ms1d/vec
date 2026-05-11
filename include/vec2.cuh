#pragma once



#include "vec.cuh"




// 2D vector specialisation of vec. Implements:
//		- clean x,y,z aliases
template<>
struct vec<2> : vec_base<2, vec<2>> {



    union {
        float data[2];
        struct { float x, y; };
    };




    __host__ __device__ constexpr vec() noexcept {}

    __host__ __device__ constexpr vec(float x, float y) noexcept : x(x), y(y) {}

	__host__ __device__ constexpr vec(const vec& other) noexcept : x(other.x), y(other.y) {}

    __host__ __device__ constexpr vec& operator=(const vec& other) noexcept {
		x = other.x; y = other.y;
		return *this;
	}



};
