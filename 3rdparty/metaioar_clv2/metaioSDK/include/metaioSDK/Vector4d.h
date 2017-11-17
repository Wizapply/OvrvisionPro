// Copyright 2007-2013 metaio GmbH. All rights reserved.

#ifndef __VECTOR_4D_H__
#define __VECTOR_4D_H__

#include <metaioSDK/Dll.h>

namespace metaio {

/**
 * Structure that defines a 4D float vector
 */
struct METAIO_DLL_API Vector4d
{
	float x;	///< x component of the vector
	float y;	///< y component of the vector
	float z;	///< z component of the vector
	float w;	///< w component of the vector
	
	/**
	 * Create Vector4d and initialize all components 0
	 */
	Vector4d();
	
	/**
	 * Create Vector4d and initialize all components to the given values
	 * \param _x x component of the vector
	 * \param _y y component of the vector
	 * \param _z z component of the vector
	 * \param _w w component of the vector
	 */
	Vector4d(float _x, float _y, float _z, float _w);
	
	/**
	 * Sets all the components to 0
	 *
	 * \post norm() == 0
	 */
	void setZero();
	
	/**
	 * Negative of this vector
	 *
	 * \return Resultant vector
	 */
	Vector4d operator -() const;
	
	/**
	 * Add two vectors coefficient-wise
	 *
	 * \param[in] rhs Vector to add
	 * \return Resultant vector after addition
	 */
	Vector4d operator +(const Vector4d& rhs) const;
	
	/**
	 * Subtract two vectors coefficient-wise
	 *
	 * \param[in] rhs Vector to be subtracted
	 * \return Resultant vector after subtraction
	 */
	Vector4d operator -(const Vector4d& rhs) const;
	
	/**
	 * Multiplies a scalar coefficient-wise with the vector
	 *
	 * \param[in] rhs Scalar value to multiple
	 * \return Resultant vector after multiplication
	 */
	Vector4d operator *(float rhs) const;
	
	/**
	 * Divide coefficient-wise with the vector by a scalar
	 *
	 * \param[in] rhs Denominator scalar value
	 * \return Resultant vector
	 * \pre rhs != 0
	 */
	Vector4d operator /(float rhs) const;
	
	/**
	 * Add coefficient-wise two vector in place
	 *
	 * \param[in] rhs Vector to be added
	 * \return Resultant vector (Reference to *this)
	 */
	Vector4d& operator +=(const Vector4d& rhs);
	
	/**
	 * Subtract coefficient-wise two vector in place
	 *
	 * \param[in] rhs Vector to subtract
	 * \return Resultant vector (Reference to *this)
	 */
	Vector4d& operator -=(const Vector4d& rhs);
	
	/**
	 * Multiply the vector with a scalar in place
	 *
	 * \param[in] rhs Scalar to multiple
	 * \return Resultant vector (Reference to *this)
	 */
	Vector4d& operator *=(float rhs);
	
	/**
	 * Divide the vector by a scalar
	 *
	 * \param[in] rhs Denominator scalar value
	 * \return Resultant vector (Reference to *this)
	 * \pre rhs != 0
	 */
	Vector4d& operator /=(float rhs);
	
	/**
	 * Compute dot product (or scalar product, inner product) of this and the
	 * given vector.
	 *
	 * \param[in] rhs Second vector
	 * \return Dot product of the vectors
	 */
	float dot(const Vector4d& rhs) const;
	
	/**
	 * Squared norm of the vector
	 *
	 * \return Squared norm of the vector
	 */
	float squaredNorm() const;
	
	/**
	 * Euclidean norm of the vector
	 *
	 * \return Euclidean norm of the vector
	 */
	float norm() const;
	
	/**
	 * Determine if the vector is null
	 * \return true if null vector, else false
	 */
	bool isNull() const;
	
};

} //namespace metaio

#endif //__VECTOR_4D_H__
