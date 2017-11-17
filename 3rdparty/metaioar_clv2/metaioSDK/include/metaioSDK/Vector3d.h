// Copyright 2007-2014 metaio GmbH. All rights reserved.

#ifndef __VECTOR_3D_H__
#define __VECTOR_3D_H__

#include <metaioSDK/Dll.h>

namespace metaio 
{
	
/**
 * Structure that defines a 3D float vector
 */
struct METAIO_DLL_API Vector3d
{
	float x;	///< x component of the vector
	float y;	///< y component of the vector
	float z;	///< z component of the vector
	
	/**
	 * Create Vector3d and initializes all components to 0
	 */
	Vector3d();
	
	/**
	 * Create Vector3d and initializes all components to the given scalar value
	 * \param _n x, y and z components of the vector
	 */
	Vector3d(float _n);
	
	/**
	 * Create Vector3d and initializes all components to the given values
	 * \param _x x component of the vector
	 * \param _y y component of the vector
	 * \param _z z component of the vector
	 */
	Vector3d(float _x, float _y, float _z);
		
	/**
	 * Sets all coefficients to 0
	 *
	 * \post norm() == 0
	 */
	void setZero();
	
	/**
	 * Negative of this vector
	 *
	 * \return Resultant vector
	 */
	Vector3d operator -() const;
	
	/**
	 * Add two vectors coefficient-wise
	 *
	 * \param[in] rhs Vector to add
	 * \return Resultant vector after addition
	 */
	Vector3d operator +(const Vector3d& rhs) const;
	
	/**
	 * Subtracts two vectors coefficient-wise
	 *
	 * \param[in] rhs Vector to subtract
	 * \return Resultant vector after subtraction
	 */
	Vector3d operator -(const Vector3d& rhs) const;
	
	/**
	 * Multiply the given scalar with the vector
	 *
	 * \param[in] rhs Scalar to multiply
	 * \return Resultant vector after multiplication
	 */
	Vector3d operator *(float rhs) const;
	
	/**
	 * Divide the vector by a scalar
	 *
	 * \param[in] rhs Denominator scalar value
	 * \return Resultant vector after division
	 * \pre rhs != 0
	 */
	Vector3d operator /(float rhs) const;
	
	/**
	 * Add coefficient-wise two vector in place
	 *
	 * \param[in] rhs Vector to add
	 * \return Resultant vector (reference to *this)
	 */
	Vector3d& operator +=(const Vector3d& rhs);
	
	/**
	 * Subtract coefficient-wise two vector in place
	 *
	 * \param[in] rhs Vector to subtract
	 * \return Resultant vector (reference to *this)
	 */
	Vector3d& operator -=(const Vector3d& rhs);
	
	/**
	 * Multiply the vector with a scalar in place
	 *
	 * \param[in] rhs Vector to multiply
	 * \return Resultant vector (reference to *this)
	 */
	Vector3d& operator *=(float rhs);
	
	/**
	 * Divide this vector by a scalar
	 *
	 * \param[in] rhs Denominator scalar value
	 * \return Resultant vector (reference to *this)
	 * \pre rhs != 0
	 */
	Vector3d& operator /=(float rhs);
	
	/**
	 * Compute the dot product (or scalar product, inner product) of this and the
	 * given vector
	 *
	 * \param[in] rhs Second vector
	 * \return Dot product of two vectors
	 */
	float dot(const Vector3d& rhs) const;
	
	/**
	 * Computes the cross-product of this and the given vector
	 *
	 * \param[in] rhs Second vector
	 * \return Cross product of two vectors
	 */
	Vector3d cross(const Vector3d& rhs) const;
	
	/**
	 * Squared norm of this vector
	 *
	 * \return Squared norm of this vector
	 */
	float squaredNorm() const;
	
	/**
	 * Euclidean norm of this vector
	 *
	 * \return Euclidean norm of this vector
	 */
	float norm() const;
	
	/**
	 * Get normalized vector
	 * \return normalized vector of norm (length) 1
	 */
	Vector3d normalize() const;
	
	/**
	 * Determine if the vector is null
	 * \return true if null vector, else false
	 */
	bool isNull() const;
	
	/**
	 * Lexicographical compare of two vectors
	 *
	 * \param other Vector3d to compare with
	 * \return True if this vector is less than the other, otherwise false
	 */
	bool operator <(const Vector3d& other) const;
	
	/**
	 * Equality operator
	 *
	 * \param other Vector3d to compare with
	 * \return True if vectors are coefficient-wise equal, otherwise false
	 */
	bool operator ==(const Vector3d& other) const;
		
};
	
} //namespace metaio

#endif //__VECTOR_3D_H__
