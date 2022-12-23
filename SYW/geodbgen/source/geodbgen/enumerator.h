#pragma once
#include "TokenStr.h"

enum Enum
{ 
	Unknown = -1 // global Unknown/Invalid enum value (-1)
};


template<class T> struct _enum
{
	static const TokenStr data[];
	static const TokenStr unknown;
	static const int maxValue;

};



template<class T> T enum_parse(const TokenStr& token)
{
	const TokenStr* start = _enum<T>::data;
	const TokenStr* end = start + sizeof(_enum<T>::data) / sizeof(TokenStr);

	const char* tokenStr = token.c_str();
	const int tokenLen   = token.length();

	//// @todo Perhaps something better than linear search would be nice?
	for (const TokenStr* p = start; p != end; ++p)
		if (p->equals(tokenStr, tokenLen))
			return T(p - start);
	return T(-1); // unknown value (-1)
}

template<class T> void enum_parse(const TokenStr& token, T& out)
{
	out = enum_parse<T>(token);
}



template<class T> const TokenStr& enum_str(T value)
{
	return (0 <= (int)value && (int)value <= _enum<T>::maxValue) 
		? _enum<T>::data[(int)value] 
		: _enum<T>::unknown;
}
template<class T> const char* enum_cstr(T value)
{
	return (0 <= (int)value && (int)value <= _enum<T>::maxValue) 
		? _enum<T>::data[(int)value].c_str() 
		: _enum<T>::unknown.c_str();
}



#define _ENUM_EXPAND(x) x
#define _ENUM_ARG_N( \
          _1,  _2,  _3,  _4,  _5,  _6,  _7,  _8,  _9, _10, \
         _11, _12, _13, _14, _15, _16, _17, _18, _19, _20, \
         _21, _22, _23, _24, _25, _26, _27, _28, _29, _30, \
         _31, _32, _33, _34, _35, _36, _37, _38, _39, _40, \
         _41, _42, _43, _44, _45, _46, _47, _48, _49, _50, \
         _51, _52, _53, _54, _55, _56, _57, _58, _59, _60, \
         _61, _62, _63, N, ...) N
#define _ENUM_NARG(...)	_ENUM_EXPAND(_ENUM_ARG_N(_, ##__VA_ARGS__, 4, 4, 4, \
         4, 4, 4, 4, 4, 4, 4, 4, 4, 4, \
         4, 4, 4, 4, 4, 4, 4, 4, 4, 4, \
         4, 4, 4, 4, 4, 4, 4, 4, 4, 4, \
         4, 4, 4, 4, 4, 4, 4, 4, 4, 4, \
         4, 4, 4, 4, 4, 4, 4, 4, 4, 4, \
         4, 4, 4, 4, 4, 4, 3, 2, 1, 0))

#define _ENUM_OVERLOAD(func, ...)			_ENUM_OVERLOAD_(func, _ENUM_NARG(__VA_ARGS__), __VA_ARGS__)
#define _ENUM_OVERLOAD_(func, argc, ...)	_ENUM_OVERLOAD__(func, argc, __VA_ARGS__)
#define _ENUM_OVERLOAD__(func, argc, ...)	func ## argc(_ENUM_EXPAND(__VA_ARGS__))

#define ENUM_STR0()
#define ENUM_STR1(x)				#x
#define ENUM_STR2(x, y)				#x, #y
#define ENUM_STR3(x, y, z)			#x, #y, #z
#define ENUM_STR4(x, y, z, w, ...)	#x, #y, #z, #w, _ENUM_OVERLOAD(ENUM_STR, __VA_ARGS__)
#define ENUM_STR(...)				_ENUM_OVERLOAD(ENUM_STR, __VA_ARGS__)


#define ENUM_BASE_(Type, ...) \
	template<> const int _enum<Type>::maxValue = (int)Type::__last; \
	template<> const TokenStr _enum<Type>::unknown = "unknown"; \
	template<> const TokenStr _enum<Type>::data[] = {  ENUM_STR(__VA_ARGS__) };

#define ENUM_BASE(Type, DataType, ...) \
	enum Type : DataType { __VA_ARGS__, __last }; ENUM_BASE_(Type, __VA_ARGS__)

#define ENUM_CLASS_BASE(Type, DataType, ...) \
	enum class Type : DataType { unknown=-1, ## __VA_ARGS__, __last }; ENUM_BASE_(Type, __VA_ARGS__)

#define Enum(Type, ...)				ENUM_BASE(Type, int, __VA_ARGS__)
#define EnumByte(Type, ...)			ENUM_BASE(Type, char, __VA_ARGS__)
#define EnumShort(Type, ...)		ENUM_BASE(Type, short, __VA_ARGS__)
#define EnumClass(Type, ...)		ENUM_CLASS_BASE(Type, int, __VA_ARGS__)
#define EnumClassByte(Type, ...)	ENUM_CLASS_BASE(Type, char, __VA_ARGS__)
#define EnumClassShort(Type, ...)	ENUM_CLASS_BASE(Type, short, __VA_ARGS__)


