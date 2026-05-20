#pragma once



#include <type_traits>
#ifndef __host__
#define __host__
#endif
#ifndef __device__
#define __device__
#endif



#include <cassert>
#include <initializer_list>
#include <iostream> 
#include "precision.cuh"



// Generic vector. Implements:
//
//		- Addition + Addition Assignment
//		- Subtraction + Subtraction Assignment
//
//		- Scalar multiplication + assignment operators
//		- Vector multiplication (Dot product)
//
//		- Equality test (with strict tolerance)
//
//		vec_base is a base class that allows for more readable aliases (via union)
//		for specialised vectors (e.g. 2D x and y, 3D x, y and z, 4D x, y, z and w...)
//		see vec<3> below

template<size_t dim, class Derived, typename num_T = float>
requires (std::is_arithmetic_v<num_T>)
struct vec_base {



    static_assert(dim > 1, "Vector dimensions must be > 1");



    __host__ __device__ constexpr num_T* derived_data() noexcept { return static_cast<Derived*>(this)->data; }
    __host__ __device__ constexpr const num_T* derived_data() const noexcept { return static_cast<const Derived*>(this)->data; }



	__host__ __device__ constexpr vec_base() noexcept {}
    __host__ __device__ constexpr vec_base(const num_T (&new_data)[dim]) noexcept {
        num_T* d = derived_data();
        for (size_t i = 0; i < dim; i++) d[i] = new_data[i];
    }
	__host__ __device__ constexpr vec_base(std::initializer_list<num_T> new_data) noexcept {
		assert(new_data.size() == dim);
		num_T* d = derived_data();
		auto it = new_data.begin();
		for (size_t i = 0; i < dim; i++) d[i] = it[i];
	}



	__host__ __device__ constexpr num_T operator[](size_t i) const noexcept {
		return derived_data()[i];
	}



    __host__ __device__ constexpr num_T mag() const noexcept {
        const num_T* d = derived_data();
        num_T sum = 0;
        for (size_t i = 0; i < dim; i++) sum += d[i] * d[i];
        return __builtin_sqrtf(sum);
    }



	__host__ __device__ constexpr Derived norm() const noexcept {
		Derived res = static_cast<const Derived&>(*this);
		res.norm_inplace();
		return res;
	}



	__host__ __device__ constexpr Derived& norm_inplace() noexcept {
		num_T magnitude = mag();
		auto data = derived_data();
		for (size_t i = 0; i < dim; i++) {
			data[i] /= magnitude;
		}
		return static_cast<Derived&>(*this);
	}


    __host__ __device__ constexpr Derived operator+(const Derived& other) const noexcept {
        Derived res = static_cast<const Derived&>(*this);
        res += other;
        return res;
    }
    
	__host__ __device__ constexpr Derived& operator+=(const Derived& other) noexcept {
        num_T* d = derived_data();
        for (size_t i = 0; i < dim; i++) d[i] += other.data[i];
        return static_cast<Derived&>(*this);
    }



    __host__ __device__ constexpr Derived operator-(const Derived& other) const noexcept {
        Derived v = static_cast<const Derived&>(*this);
        v -= other;
        return v;
    }
    
	__host__ __device__ constexpr Derived& operator-=(const Derived& other) noexcept {
        num_T* d = derived_data();
        for (size_t i = 0; i < dim; i++) d[i] -= other.data[i];
        return static_cast<Derived&>(*this);
    }



    __host__ __device__ constexpr num_T operator*(const Derived& other) const noexcept { // dot product
        const num_T* d = derived_data();
        num_T sum = 0;
        for (size_t i = 0; i < dim; i++) sum += d[i] * other.data[i];
        return sum;
    }



    __host__ __device__ constexpr Derived& operator*=(num_T scalar) noexcept {
        num_T* d = derived_data();
        for (size_t i = 0; i < dim; i++) d[i] *= scalar;
        return static_cast<Derived&>(*this);
    }



	__host__ __device__ constexpr bool operator==(const vec_base<dim, Derived>& rhs) const noexcept {
		const num_T* ld = derived_data();
		const num_T* rd = rhs.derived_data();

		for (size_t i = 0; i < dim; i++) if (!math_precision::nearly_equal(ld[i], rd[i])) return false;
		return true;
	}



	__host__ __device__ constexpr Derived operator*(num_T scalar) const noexcept {
		Derived result = static_cast<const Derived&>(*this);
		result *= scalar;
		return result;
	}



};




template<size_t dim, typename num_T = float>
requires (std::is_arithmetic_v<num_T>)
struct vec : vec_base<dim, vec<dim, num_T>, num_T> {


	using vec_base<dim, vec<dim>>::vec_base;
	num_T data[dim];



};




// num_T * scalar must be a non-member function to allow float on lhs
template<size_t dim, typename num_T = float>
requires (std::is_arithmetic_v<num_T>)
__host__ __device__ constexpr vec<dim> operator*(num_T scalar, const vec<dim>& v) noexcept { return v * scalar; }



template<size_t dim, typename num_T = float>
requires (std::is_arithmetic_v<num_T>)
constexpr std::ostream& operator<<(std::ostream& os, const vec<dim>& v) noexcept {
	const num_T* d = v.data;
	os << "(";
	const char* sep = "";
	for (size_t i = 0; i < dim; i++) {
		os << sep << d[i];
		sep = ", ";
	}
	return os << ")";
}
