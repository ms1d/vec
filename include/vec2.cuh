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




    __host__ __device__ constexpr vec() {}

    __host__ __device__ constexpr vec(float x, float y) : x(x), y(y) {}

	__host__ __device__ constexpr vec(const vec& other) : x(other.x), y(other.y) {}

    __host__ __device__ constexpr vec& operator=(const vec& other) {
		x = other.x; y = other.y;
		return *this;
	}



};
