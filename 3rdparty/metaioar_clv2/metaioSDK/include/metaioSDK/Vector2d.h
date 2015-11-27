// Copyright 2007-2014 metaio GmbH. All rights reserved.

#ifndef __VECTOR_2D_H__
#define __VECTOR_2D_H__

#include <metaioSDK/Dll.h>

namespace metaio 
{
	
/**
 * Structure that defines a 2D float vector
 */
struct METAIO_DLL_API Vector2d
{
	float x;	///< x component of the vector
	float y;	///< y component of the vector
	
	/**
	 * Create Vector2d and initializes all components to 0
	 */
	Vector2d();
	
	/**
	 * Create Vector2d and initialize all components to the given scalar value
	 * \param _n x and y components of the vector
	 */
	explicit Vector2d(float _n);
	
	/**
	 * Create Vector2d with given values
	 * \param _x x component of the vector
	 * \param _y y component of the vector
	 */
	Vector2d(float _x, float _y);
	
	/**
	 * Coefficient-wise sum of two vectors
	 *
	 * \param[in] rhs Vector to be added
	 * \return Coefficient-wise sum of the vectors
	 */
	Vector2d operator +(const Vector2d& rhs) const;
	
	/**
	 * Coefficient-wise difference of two vectors
	 *
	 * \param[in] rhs Vector to be subtracted
	 * \return Coefficient-wise difference of the vectors
	 */
	Vector2d operator -(const Vector2d& rhs) const;
	
	/**
	 * Coefficient-wise product of two vectors
	 *
	 * \param[in] rhs Vector to be multiplied
	 * \return Coefficient-wise product of the vectors
	 */
	Vector2d cwiseProduct(const Vector2d& rhs) const;
	
	/**
	 * Coefficient-wise quotient of two vectors
	 *
	 * \param[in] rhs Denominator Vector
	 * \return Coefficient-wise quotient of the vectors
	 */
	Vector2d cwiseQuotient(const Vector2d& rhs) const;
	
	/**
	 * Scale the vector by a scalar
	 *
	 * \param[in] rhs Scalar which scales the vector
	 * \return Scaled vector
	 */
	Vector2d operator *(float rhs) const;
	
	/**
	 * In-place coefficient-wise sum of two vectors
	 *
	 * \param[in] rhs Vector to be added
	 * \return Resultant vector (Reference to *this)
	 */
	Vector2d& operator +=(const Vector2d& rhs);
	
	/**
	 * In-place coefficient-wise difference of two vectors
	 *
	 * \param[in] rhs Vector to be subtracted
	 * \return Resultant vector (Reference to *this)
	 */
	Vector2d& operator -=(const Vector2d& rhs);
	
	/**
	 * Scale the vector in-place by a given scalar
	 *
	 * \param[in] rhs Scalar which scales the vector
	 * \return Resultant vector (Reference to *this)
	 */
	Vector2d& operator *=(float rhs);
	
	/**
	 * In-place coefficient-wise quotient of two vectors
	 *
	 * \param[in] rhs Denominator Vector
	 * \return Resultant vector (Reference to *this)
	 */
	Vector2d& operator /=(float rhs);
	
	/**
	 * Dot-product (or scalar-product or inner-product) of the two vectors
	 *
	 * \param[in] rhs Second vector for the dot product
	 * \return Dot product of the two vectors
	 */
	float dot(const Vector2d& rhs) const;
	
	/**
	 * Euclidean-norm (L2-norm) of this vector
	 *
	 * \return Euclidean norm
	 * \sa squaredNorm
	 */
	float norm() const;
	
	/**
	 * Squared-norm of this vector
	 *
	 * \return Squared norm
	 * \sa norm
	 */
	float squaredNorm() const;
	
	/**
	 * Determine if the vector is null
	 * \return true if null vector, else false
	 */
	bool isNull() const;
	
	/**
	 * Check if two vectors are coefficient-wise equal
	 *
	 * \param other Vector2d to compare with
	 * \return true if vectors are coefficient-wise equal, otherwise false.
	 */
	bool operator ==(const Vector2d& other) const;
	
	/**
	 * Check if two vectors differ in at least one coefficient
	 *
	 * \param other Vector2d to compare with
	 * \return true if vectors are unequal, otherwise false.
	 */
	bool operator !=(const Vector2d& other) const;
	
	/**
	 * Check if a vector is lexicographically smaller than another vector
	 *
	 * \param other Vector2d to compare with
	 * \return true if this vector is smaller than the other, otherwise false.
	 */
	bool operator <(const Vector2d& other) const;
};

/**
 * Structure that defines an integer 2D vector
 */
struct METAIO_DLL_API Vector2di
{
	int x;	///< x component of the vector
	int y;	///< y component of the vector
	
	/**
	 * Create Vector2di and initializes all components to 0
	 */
	Vector2di();
	
	/**
	 * Create Vector2di and initializes all components to the given scalar value
	 * \param _n x and y components of the vector
	 */
	Vector2di(int _n);
	
	/**
	 * Create Vector2di and initializes all components to the given values
	 * \param _x x component of the vector
	 * \param _y y component of the vector
	 */
	Vector2di(int _x, int _y);
	
	/**
	 * Determine if the vector is null
	 * \return true if null vector, else false
	 */
	bool isNull() const;
	
	/**
	 * Check if two vectors are coefficient-wise equal
	 *
	 * \param other Vector2di to compare with
	 * \return true if vectors are coefficient-wise equal, otherwise false.
	 */
	bool operator ==(const Vector2di& other) const;

	/**
	 * Check if two vectors differ in at least one coefficient
	 *
	 * \param other Vector2di to compare with
	 * \return true if vectors are unequal, otherwise false.
	 */
	bool operator !=(const Vector2di& other) const;
};
	
} //namespace metaio

#endif //__VECTOR_2D_H__
