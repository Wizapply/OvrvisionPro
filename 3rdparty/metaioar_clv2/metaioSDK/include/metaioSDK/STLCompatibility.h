// Copyright 2007-2013 metaio GmbH. All rights reserved.
#ifndef __AS_STLCOMPATIBILITY_H_INCLUDED__
#define __AS_STLCOMPATIBILITY_H_INCLUDED__

#include <metaioSDK/Dll.h>

#include <metaioSDK/BackwardCompatibility.h>

#include <cassert>
#include <climits>
#include <sstream>
#include <string.h>
#include <vector>

namespace metaio
{
namespace stlcompat
{

const char* const EMPTY_STRING_CONSTANT = "";

/**
 * Minimal string implementation that converts to std::string and is mostly immutable
 */
class METAIO_DLL_API String
{
public:
	/// \sa substr
	static const unsigned long npos = ULONG_MAX;

	/// Constructor for empty string
	String();
	
	/// Constructor for zero-terminated C string
	String(const char* str);

	/**
	 * Constructor from zero-terminated C string with given length
	 *
	 * \param str C string (does not have to be zero-terminated)
	 * \param length Number of characters to copy from str
	 */
	String(const char* str, unsigned long length);

	/// Destructor
	~String();

	/// Copy constructor
	String(const String& other);

	/// Assignment operator
	String& operator=(const String& other);

	/// Assignment operator from zero-terminated C string
	String& operator=(const char* str);

	/// std::string-compatible constructor
	String(const std::string& str);

	/// Assignment operator from std::string
	String& operator=(const std::string& str);

	/**
	 * Get a zero-terminated C string.
	 *
	 * The buffer can be expected to be valid during the lifetime of this String instance but only
	 * until the next non-const method call.
	 *
	 * \return Zero-terminated C string
	 */
	const char* c_str() const;

	/**
	 * Compares with another string
	 *
	 * \param other String to compare with
	 * \return 0 if both strings are equal, <0 if either the value of the first non-matching
	 *         character in the other string is larger or the other string is longer, >0 if either
	 *         the value of the first non-matching character in the other string is smaller or the
	 *         other string is shorter
	 */
	int compare(const stlcompat::String& other) const;

	/**
	 * Compares with another string
	 *
	 * \param other String to compare with
	 * \return 0 if both strings are equal, <0 if either the value of the first non-matching
	 *         character in the other string is larger or the other string is longer, >0 if either
	 *         the value of the first non-matching character in the other string is smaller or the
	 *         other string is shorter
	 */
	int compare(const std::string& other) const;

	/**
	 * Compares with another string
	 *
	 * \param other String to compare with
	 * \return 0 if both strings are equal, <0 if either the value of the first non-matching
	 *         character in the other string is larger or the other string is longer, >0 if either
	 *         the value of the first non-matching character in the other string is smaller or the
	 *         other string is shorter
	 */
	int compare(const char* other) const;

	/**
	 * Check whether string is empty
	 * \sa size
	 * \return True if string is empty, otherwise false
	 */
	bool empty() const;

	/**
	 * Determines the length of the string.
	 *
	 * Alias for size().
	 *
	 * \sa size
	 * \return Length of the string
	 */
	unsigned long length() const;

	/**
	 * Determines the length of the string
	 * \return Length of the string
	 */
	unsigned long size() const;

	/**
	 * Get a substring
	 *
	 * \param startIndex Index from which the substring should begin
	 * \param length Maximum number of characters that the substring should contain
	 * \return The substring
	 */
	String substr(unsigned long startIndex, unsigned long length = npos) const;

	/**
	 * Get the n-th character of the string
	 *
	 * \param pos Zero-based index
	 * \return Character at position pos (0 if pos == string length)
	 */
	const char& operator[](unsigned long pos) const;

	/// Convert to an std::string
	operator std::string() const;

	/// Compares two strings
	friend METAIO_DLL_API bool operator==(const String& lhs, const String& rhs);

	/// Compares string with a C string
	friend METAIO_DLL_API bool operator==(const String& lhs, const char* rhs);

	/// Compares string with a C string
	friend METAIO_DLL_API bool operator==(const char* lhs, const String& rhs);

	/// Checks inequality
	friend METAIO_DLL_API bool operator!=(const String& lhs, const String& rhs);

	/// Checks inequality
	friend METAIO_DLL_API bool operator!=(const String& lhs, const char* rhs);

	/// Checks inequality
	friend METAIO_DLL_API bool operator!=(const char* lhs, const String& rhs);

	/// Appends this string to a string stream
	friend METAIO_DLL_API std::ostream& operator<<(std::ostream& stream, const String& s);

private:

	void deleteAll();

	/**
	 * Compares with another string
	 *
	 * \param other String to compare with
	 * \param otherLength Number of characters in the other string
	 * \return 0 if both strings are equal, <0 if either the value of the first non-matching
	 *         character in the other string is larger or the other string is longer, >0 if either
	 *         the value of the first non-matching character in the other string is smaller or the
	 *         other string is shorter
	 */
	int compare(const char* other, unsigned long otherLength) const;

	/// Data pointer, must always include zero terminator or be NULL
	char*			m_pData;

	/// Number of chars in m_pData, must always be updated when m_pData is modified
	unsigned long	m_length;
};



/**
 * Basic vector implementation that converts to std::vector.
 *
 * Convert the instance to std::vector if you need advanced methods.
 */

template<typename T> class METAIO_DLL_API Vector
{
public:
	//public types

	typedef std::vector<T> std_type;

	typedef unsigned long size_type;	//!!!! ATTENTION the return type Vector<T>::size() implementation is "unsigned long", MSVC2010 refused to compile using the typedef !!!!

public:

	void deleteAll();
	Vector();
	~Vector();
	void push_back(const T& copyMe);


	/// Copy constructor
	Vector(const Vector& other);

	/// Assignment operator
	Vector& operator=(const Vector& other);

	/// Copy constructor from std::vector
	Vector(const std::vector<T>& other);

	/// Assignment operator from std::vector
	Vector& operator=(const std::vector<T>& other);

#if defined(METAIOSDK_COMPAT_HAVE_CPP11) && !defined(METAIOSDK_COMPAT_NO_CPP11_STL_FEATURES)

	/// Move constructor
	Vector(Vector&& other);

	/// Move assignment operator
	Vector& operator=(Vector&& other);

#endif

	/// Removes all elements
	void clear();

	/// Checks if the vector is empty
	bool empty() const;



#if defined(METAIOSDK_COMPAT_HAVE_CPP11) && !defined(METAIOSDK_COMPAT_NO_CPP11_STL_FEATURES)

	/// Adds an element to the vector
	void push_back(T&& stealMe);

#endif

	/// Converts to an std::vector	(implementation needs to reside outside of DLL to avoid heap corruptions)
	operator std::vector<T>() const
	{
		if (!m_size)
			return std::vector<T>();

		return std::vector<T>(reinterpret_cast<T*>(m_pElements), reinterpret_cast<T*>(m_pElements) + m_size);
	}

	/**
	 * Get the n-th element of the vector
	 *
	 * \param index Zero-based index
	 * \return Element at position index (0 if index == number of elements)
	 */
	const T& operator[](size_type index) const;

	/**
	 * Get the n-th element of the vector
	 *
	 * \param index Zero-based index
	 * \return Element at position index (0 if index == number of elements)
	 */
	T& operator[](size_type index);

	/**
	 * Remove the n-th element of the vector
	 *
	 * \param index Zero-based index
	 */
	void remove(size_type index);

	/**
	 * Determines the number of elements in the vector
	 * !!!! ATTENTION the return type of actual implementation is "unsigned long", MSVC2010 refused to compile using the typedef !!!!
	 * \return Number of elements
	 */
	size_type size() const;

private:


	void ensureSize(const size_type newElementsSize);

	unsigned char*	m_pElements; ///< buffer for elements
	size_type		m_elementsSize; ///< number of allocated T elements in m_pElements
	size_type		m_size; ///< actual number of elements
};

} // namespace stlcompat
} // namespace metaio

#endif //__AS_STLCOMPATIBILITY_H_INCLUDED__
