#pragma once



#include "vec.cuh"




// 2D vector specialisation of vec. Implements:
//		- clean x,y,z aliases
template<typename num_T>
struct vec<2, num_T> : vec_base<2, vec<2, num_T>, num_T> {



    union {
        num_T data[2];
        struct { num_T x, y; };
    };




    __host__ __device__ constexpr vec() noexcept {}

    __host__ __device__ constexpr vec(num_T x, num_T y) noexcept : x(x), y(y) {}

	__host__ __device__ constexpr vec(const vec& other) noexcept : x(other.x), y(other.y) {}

    __host__ __device__ constexpr vec& operator=(const vec& other) noexcept {
		x = other.x; y = other.y;
		return *this;
	}



};
