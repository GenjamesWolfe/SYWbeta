#pragma once
/**
 * Legacy 3D Engine, Copyright (c) 2014 - Agema
 */
#include <string>
#include <vector>
#include <iostream>

//// @note Some functions get inlined too aggressively, leading to actual code bloat
#define NOINLINE __declspec(noinline) 

/**
* This is a simplified string tokenizer class.
*
* Those who are not familiar with string tokens - these are strings that don't actually
* hold nor control the string data. These strings are read-only and the only operations
* we can do are shifting the start/end pointers.
*
* That is how the TokenStr class is built and subsequently operations like trim()
* just shift the start/end pointers towards the middle.
* This appears to be extremely efficient when parsing large file buffers - instead of
* creating thousands of string objects, we tokenize substrings of the file buffer.
*
* The structures below contain methods for efficiently manipulating the TokenStr class.
*/




/**
 * C-locale specific, simplified atof that also outputs the end of parsed string
 * @param str Input string, eg "-0.25" / ".25", etc.. '+' is not accepted as part of the number
 * @param end[NULL] (optional) Destination pointer for end of parsed string. Can be NULL.
 * @return Parsed float
 */
float _tofloat(const char* str, const char** end = NULL);


/**
 * Fast locale agnostic atoi
 * @param str Input string, eg "-25" or "25", etc.. '+' is not accepted as part of the number
 * @param end[NULL] (optional) Destination pointer for end of parsed string. Can be NULL.
 * @return Parsed int
 */
int _toint(const char* str, const char** end = NULL);

/**
 * C-locale specific, simplified ftoa that prints pretty human-readable floats
 * @param buffer Destination buffer assumed to be big enough. 32 bytes is more than enough.
 * @param value Float value to convert to string
 * @return Length of the string
 */
int _tostring(char* buffer, float value);

/**
 * Fast locale agnostic itoa
 * @param buffer Destination buffer assumed to be big enough. 16 bytes is more than enough.
 * @param value Integer value to convert to string
 * @return Length of the string
 */
int _tostring(char* buffer, int value);


struct TokenStrVisHelper // VC++ visualization helper
{
	const char* str;
	const char* end;
};


/**
* String token for efficient parsing.
* Represents a 'weak' reference string with Start/End pointers.
* The string can be parsed, manipulated and tokenized through methods like:
*  - trim(), trim_start(), trim_end(), toInt(), toFloat(), next(), skip_until(), skip_after(), ...
*/
struct TokenStr
{
	union {
		struct {
			const char* str; // start of string
			const char* end; // end of string
		};
		TokenStrVisHelper v; // VC++ visualization helper
	};


	inline TokenStr() : str(""), end(str) {}
	template<int SIZE>
	inline TokenStr(const char(&str)[SIZE]) : str(str), end(str + SIZE - 1) {}
	inline TokenStr(const char* str, const char* end) : str(str), end(end) {}
	inline TokenStr(const char* str, size_t len) : str(str), end(str + len) {}
	
	// explicitly state you want the std::string overload - this is overload is not very desirable
	inline explicit TokenStr(const std::string& s) : str(s.c_str()), end(str + s.length()) {}
	inline char operator[](int index) const { return str[index]; }

	/** Creates a new string from this string-token */
	inline std::string& toString(std::string& out) const { out.assign(str, end - str); return out; }
	inline std::string toString() const { return std::string(str, end - str); }
	/** Parses this string token as an integer */
	inline int toInt() const { return _toint(str); }
	/** Parses this string token as a long */
	inline long toLong() const { return (long)_toint(str); }
	/** Parses this string token as a float */
	inline float toFloat() const { return _tofloat(str); }
	/** Parses this string token as a double */
	inline double toDouble() const { return (double) _tofloat(str); }
	/** Parses this string token as a bool */
	bool toBool() const;

	/** Clears the string token */
	inline void clear() { str = "", end = str; }
	/** @return Length of the string */
	inline int length() const  { return int(end - str); }
	/** @return TRUE if length of the string is 0 - thus the string is empty */
	inline bool empty() const { return str == end; }
	/** @return TRUE if string is non-empty */
	inline operator bool() const { return str != end; }
	/** @return Pointer to the start of the string */
	inline const char* c_str() const { return str; }
	/** @return Pointer to the start of the string */
	/** @return TRUE if the string token is only whitespace: " \t\r\n"  */
	NOINLINE bool is_whitespace();

	/** Trims the start of the string from any whitespace */
	NOINLINE TokenStr& trim_start();
	/** Trims the end of the string from any whitespace */
	NOINLINE TokenStr& trim_end();
	/** Trims start from this char */
	NOINLINE TokenStr& trim_start(char ch);
	/** Trims end from this char */
	NOINLINE TokenStr& trim_end(char ch);

	NOINLINE TokenStr& trim_start(const char* chars, int nchars);
	NOINLINE TokenStr& trim_end(const char* chars, int nchars);
	template<int SIZE> inline TokenStr& trim_start(const char(&chars)[SIZE])
	{
		return trim_start(chars, (SIZE - 1));
	}
	template<int SIZE> inline TokenStr& trim_end(const char(&chars)[SIZE])
	{
		return trim_end(chars, (SIZE - 1));
	}

	/** Trims both start and end with whitespace */
	inline TokenStr& trim() { return trim_start().trim_end(); }
	/** Trims both start and end width this char*/
	inline TokenStr& trim(char ch) { return trim_start(ch).trim_end(ch); }
	/** Trims both start and end with any of the given chars */
	template<int SIZE> inline TokenStr& trim(const char(&chars)[SIZE])
	{
		return trim_start(chars, (SIZE - 1)).trim_end(chars, (SIZE - 1));
	}
	inline TokenStr& trim(const char* chars, int len)
	{
		return trim_start(chars, len).trim_end(chars, len);
	}

	/** Consumes the first character in the Token String if possible. */
	inline TokenStr& chomp_first() { if (str != end) ++str; return *this; }
	/** Consumes the last character in the Token String if possible. */
	inline TokenStr& chomp_last() { if (str != end) --end; return *this; }

	/** Consumes the first COUNT characters in the Token String if possible. */
	inline TokenStr& chomp_first(int count) { for (int n = count; n && str != end; --n, ++str); return *this; }
	/** Consumes the last COUNT characters in the Token String if possible. */
	inline TokenStr& chomp_last(int count) { for (int n = count; n && str != end; --n, --str); return *this; }

	/** @return TRUE if the string token contains this char */
	inline bool contains(char c) const { return memchr(str, c, end - str) ? true : false; }
	/** @return TRUE if the string token contains any of the chars */
	bool contains(const char* chars, int nchars) const;
	template<int SIZE> inline bool contains(const char(&chars)[SIZE]) const { return contains(chars, (SIZE - 1)); }



	/** @return TRUE if the string token starts with this string */
	template<int SIZE> inline bool starts_with(const char(&s)[SIZE]) const
	{
		return int(end - str) >= (SIZE - 1) && memcmp(str, s, SIZE - 1) == 0;
	}
	/** @return TRUE if the string token starts with IGNORECASE this string */
	template<int SIZE> inline bool starts_withi(const char(&s)[SIZE]) const
	{
		return int(end - str) >= (SIZE - 1) && strncasecmp(str, s, SIZE - 1) == 0;
	}
	/** @return TRUE if the string token starts with this string */
	inline bool starts_with(const char* s, int length) const
	{
		return int(end - str) >= length && memcmp(str, s, length) == 0;
	}
	/** @return TRUE if the string token starts with IGNORECASE this string */
	inline bool starts_withi(const char* s, int length) const
	{
		return int(end - str) >= length && memicmp(str, s, length) == 0;
	}
	/** @return TRUE if the string token starts with this string */
	inline bool starts_with(const std::string& s) const
	{
		int length = s.length();
		return int(end - str) >= length && memcmp(str, s.c_str(), length) == 0;
	}
	/** @return TRUE if the string token starts with IGNORECASE this string */
	inline bool starts_withi(const std::string& s) const
	{
		int length = s.length();
		return int(end - str) >= length && memicmp(str, s.c_str(), length) == 0;
	}



	/** @return TRUE if the string token equals this string */
	template<int SIZE> inline bool equals(const char(&s)[SIZE]) const
	{
		return int(end - str) == (SIZE - 1) && strncmp(str, s, SIZE - 1) == 0;
	}
	/** @return TRUE if the string token equals IGNORECASE this string */
	template<int SIZE> inline bool equalsi(const char(&s)[SIZE]) const
	{
		return int(end - str) == (SIZE - 1) && memicmp(str, s, SIZE - 1) == 0;
	}
	/** @return TRUE if the string token equals this string */
	inline bool equals(const char* s, int length) const
	{
		return int(end - str) == length && strncmp(str, s, length) == 0;
	}
	/** @return TRUE if the string token equals IGNORECASE this string */
	inline bool equalsi(const char* s, int length) const
	{
		return int(end - str) == length && memicmp(str, s, length) == 0;
	}
	/** @return TRUE if the string token equals this string */
	inline bool equals(const std::string& s) const
	{
		int length = s.length();
		return int(end - str) == length && strncmp(str, s.c_str(), length) == 0;
	}
	/** @return TRUE if the string token equals IGNORECASE this string */
	inline bool equalsi(const std::string& s) const
	{
		int length = s.length();
		return int(end - str) == length && memicmp(str, s.c_str(), length) == 0;
	}
	/** @return TRUE if the string token equals this string */
	inline bool equals(const TokenStr& s) const
	{
		int length = s.length();
		return int(end - str) == length && strncmp(str, s.c_str(), length) == 0;
	}
	/** @return TRUE if the string token equals IGNORECASE this string */
	inline bool equalsi(const TokenStr& s) const
	{
		int length = s.length();
		return int(end - str) == length && memicmp(str, s.c_str(), length) == 0;
	}



	/** @return TRUE if the string token equals this string */
	template<int SIZE> inline bool operator==(const char(&s)[SIZE]) const
	{
		return int(end - str) == (SIZE - 1) && memcmp(str, s, SIZE - 1) == 0;
	}
	/** @return TRUE if the string token does NOT equal this string */
	template<int SIZE> inline bool operator!=(const char(&s)[SIZE]) const
	{
		return int(end - str) != (SIZE - 1) || memcmp(str, s, SIZE - 1) != 0;
	}
	/** @return TRUE if the string token equals this string */
	template<int SIZE> inline bool operator==(const std::string& s) const
	{
		int length = s.length();
		return int(end - str) == length && memcmp(str, s.c_str(), length) == 0;
	}
	/** @return TRUE if the string token does NOT equal this string */
	template<int SIZE> inline bool operator!=(const std::string& s) const
	{
		int length = s.length();
		return int(end - str) == length && memcmp(str, s.c_str(), length) != 0;
	}
	/** @return TRUE if the string token equals this string */
	template<int SIZE> inline bool operator==(const TokenStr& s) const
	{
		int length = s.length();
		return int(end - str) == length && memcmp(str, s.c_str(), length) == 0;
	}
	/** @return TRUE if the string token does NOT equal this string */
	template<int SIZE> inline bool operator!=(const TokenStr& s) const
	{
		int length = s.length();
		return int(end - str) == length && memcmp(str, s.c_str(), length) != 0;
	}



	/**
	* Splits the string into TWO and returns token to the first one
	* @param delim Delimiter char to split on
	*/
	NOINLINE TokenStr split_first(char delim);
	/**
	* Splits the string into TWO and returns token to the second one
	* @param delim Delimiter char to split on
	*/
	NOINLINE TokenStr split_second(char delim);
	/**
	* Splits the string at given delimiter values and trims each split with the specified trim chars.
	* @param out Output split and trimmed strings
	* @param delim Delimiter char to split on [default ' ']
	* @param trimChars Chars to trim on the split strings (optional)
	* @return Number of split strings (at least 1)
	*/
	NOINLINE int split(std::vector<TokenStr>& out, char delim = ' ', const char* trimChars = 0);
	/**
	* Splits the string at given delimiter values and trims each split with the specified trim chars.
	* @param out Output split and trimmed strings
	* @param delims Delimiter chars to split on. ex: " \r\t" splits on 3 chars
	* @param trimChars Chars to trim on the split strings (optional)
	* @return Number of split strings (at least 1)
	*/
	NOINLINE int split(std::vector<TokenStr>& out, const char* delims, const char* trimChars = 0);

	/**
	* Gets the next string token; also advances the ptr to next token.
	* @param out Resulting string token. Only valid if result is TRUE.
	* @param delim Delimiter char between string tokens
	* @return TRUE if a token was returned, FALSE if no more tokens (no token [out]).
	*/
	NOINLINE bool next(TokenStr& out, char delim);
	/**
	* Gets the next string token; also advances the ptr to next token.
	* @param out Resulting string token. Only valid if result is TRUE.
	* @param delims Delimiter characters between string tokens
	* @param ndelims Number of delimiters in the delims string to consider
	* @return TRUE if a token was returned, FALSE if no more tokens (no token [out]).
	*/
	NOINLINE bool next(TokenStr& out, const char* delims, int ndelims);
	/**
	* Gets the next string token; also advances the ptr to next token.
	* @param out Resulting string token. Only valid if result is TRUE.
	* @param delims Delimiter characters between string tokens
	* @return TRUE if a token was returned, FALSE if no more tokens (no token [out]).
	*/
	template<int SIZE> inline bool next(TokenStr& out, const char(&delims)[SIZE])
	{
		return next(out, delims, (SIZE - 1));
	}
	/**
	 * Same as bool next(TokenStr& out, char delim), but returns a TokenStr instead
	 */
	inline TokenStr next(char delim)
	{
		TokenStr out; next(out, delim); return out;
	}
	inline TokenStr next(const char* delim, int ndelims)
	{
		TokenStr out; next(out, delim, ndelims); return out;
	}
	template<int SIZE> inline TokenStr next(const char (&delims)[SIZE])
	{
		TokenStr out; next(out, delims, SIZE-1); return out;
	}

	/**
	* Gets the next string token; stops buffer on the identified delimiter.
	* @param out Resulting string token. Only valid if result is TRUE.
	* @param delim Delimiter char between string tokens
	* @return TRUE if a token was returned, FALSE if no more tokens (no token [out]).
	*/
	NOINLINE bool next_notrim(TokenStr& out, char delim);
	/**
	* Gets the next string token; stops buffer on the identified delimiter.
	* @param out Resulting string token. Only valid if result is TRUE.
	* @param delims Delimiter characters between string tokens
	* @param ndelims Number of delimiters in the delims string to consider
	* @return TRUE if a token was returned, FALSE if no more tokens (no token [out]).
	*/
	NOINLINE bool next_notrim(TokenStr& out, const char* delims, int ndelims);
	/**
	* Gets the next string token; stops buffer on the identified delimiter.
	* @param out Resulting string token. Only valid if result is TRUE.
	* @param delims Delimiter characters between string tokens
	* @return TRUE if a token was returned, FALSE if no more tokens (no token [out]).
	*/
	template<int SIZE> inline bool next_notrim(TokenStr& out, const char(&delims)[SIZE])
	{
		return next_notrim(out, delims, (SIZE - 1));
	}
	/**
	 * Same as bool next(TokenStr& out, char delim), but returns a TokenStr instead
	 */
	inline TokenStr next_notrim(char delim)
	{
		TokenStr out; next_notrim(out, delim); return out;
	}

	/**
	 * Parses next float from current Token, example: "1.0;sad0.0,'as;2.0" will parse [1.0] [0.0] [2.0]
	 * @return 0.0f if there's nothing to parse or a parsed float
	 */
	NOINLINE float nextFloat();

	/** 
	 * Parses next int from current Token, example: "1,asvc2,x*3" will parse [1] [2] [3]
	 * @return 0 if there's nothing to parse or a parsed int
	 */
	NOINLINE int nextInt();


	/**
	 * Skips start of the string until the specified character is found or end of string is reached.
	 * @param ch Character to skip until
	 */
	NOINLINE void skip_until(char ch);

	/**
	 * Skips start of the string until the specified substring is found or end of string is reached.
	 * @param substr Substring to skip until
	 * @param len Length of the substring
	 */
	NOINLINE void skip_until(const char* substr, int len);

	/**
	 * Skips start of the string until the specified substring is found or end of string is reached.
	 * @param substr Substring to skip until
	 * @param len Length of the substring
	 */
	template<int SIZE> inline void skip_until(const char(&substr)[SIZE])
	{
		skip_until(substr, SIZE - 1);
	}


	/**
	 * Skips start of the string until the specified character is found or end of string is reached.
	 * The specified chracter itself is consumed.
	 * @param ch Character to skip after
	 */
	NOINLINE void skip_after(char ch);

	/**
	 * Skips start of the string until the specified substring is found or end of string is reached.
	 * The specified substring itself is consumed.
	 * @param substr Substring to skip after
	 * @param len Length of the substring
	 */
	NOINLINE void skip_after(const char* substr, int len);

	/**
	 * Skips start of the string until the specified substring is found or end of string is reached.
	 * The specified substring itself is consumed.
	 * @param substr Substring to skip after
	 * @param len Length of the substring
	 */
	template<int SIZE> inline void skip_after(const char(&substr)[SIZE])
	{
		skip_after(substr, SIZE - 1);
	}

	/**
	 * Modifies the target string to lowercase
	 * @warning The const char* will be recasted and modified!
	 */
	NOINLINE TokenStr& tolower();

	/**
	 * Creates a copy of this TokenStr that is in lowercase
	 */
	NOINLINE std::string aslower() const;

	/**
	 * Creates a copy of this TokenStr that is in lowercase
	 */
	NOINLINE char* aslower(char* dst) const;

	/**
	 * Modifies the target string to be UPPERCASE
	 * @warning The const char* will be recasted and modified!
	 */
	NOINLINE TokenStr& toupper();

	/**
	 * Creates a copy of this TokenStr that is in UPPERCASE
	 */
	NOINLINE std::string asupper() const;

	/**
	 * Creates a copy of this TokenStr that is in UPPERCASE
	 */
	NOINLINE char* asupper(char* dst) const;

	/**
	 * Modifies the target string by replacing all chOld
	 * occurrences with chNew
	 * @warning The const char* will be recasted and modified!
	 * @param chOld The old character to replace
	 * @param chNew The new character
	 */
	NOINLINE TokenStr& replace(char chOld, char chNew);
};


inline TokenStr& operator>>(TokenStr& token, float& out)
{
	out = token.nextFloat();
	return token;
}
inline TokenStr& operator>>(TokenStr& token, int& out)
{
	out = token.nextInt();
	return token;
}
inline TokenStr& operator>>(TokenStr& token, unsigned& out)
{
	out = token.nextInt();
	return token;
}

inline std::ostream& operator<<(std::ostream& stream, const TokenStr& token)
{
	return stream.write(token.c_str(), token.length());
}




/**
 * A POD version of TokenStr for use in unions
 */
struct TokenStr_
{
	union {
		struct {
			const char* str;
			const char* end;
		};
		TokenStrVisHelper v; // VC++ visualization helper
	};
	inline operator TokenStr()				{ return TokenStr(str, end); }
	inline operator TokenStr&()				{ return *(TokenStr*)this; }
	inline operator const TokenStr&() const { return *(TokenStr*)this; }
	inline TokenStr* operator->() const		{ return  (TokenStr*)this; }
};






/**
* Parses an input string buffer for individual lines
* The line is returned trimmed of any \r or \n
*
*  This is also an example on how to implement your own custom parsers using the TokenStr structure
*/
class LineParser
{
	TokenStr Buffer;
public:
	inline LineParser(const TokenStr& buffer) : Buffer(buffer) {}
	inline LineParser(const char* data, size_t size) : Buffer(data, data + size) {}

	/**
	* Reads next line from the base buffer and advances its pointers.
	* The line is returned trimmed of any \r or \n. Empty lines are not skipped.
	*
	* @param out The output line that is read. Only valid if TRUE is returned.
	* @return Reads the next line. If no more lines, FALSE is returned.
	**/
	NOINLINE bool ReadLine(TokenStr& out);

	// same as Readline(TokenStr&), but returns a TokenStr object instead of a bool
	NOINLINE TokenStr ReadLine();
};


/**
* Parses an input string buffer for 'Key=Value' pairs.
* The pairs are returned one by one with 'ReadNext'.
*
* This is also an example on how to implement your own custom parsers using the TokenStr structure
*/
class KeyValueParser
{
	TokenStr Buffer;
public:
	inline KeyValueParser(const TokenStr& buffer) : Buffer(buffer) {}
	inline KeyValueParser(const char* data, size_t size) : Buffer(data, data + size) {}

	/**
	* Reads next line from the base buffer and advances its pointers.
	* The line is returned trimmed of any \r or \n.
	* Empty or whitespace lines are skipped.
	* Comment lines starting with ; are skipped.
	* Comments at the end of a line are trimmed off.
	*
	* @param out The output line that is read. Only valid if TRUE is returned.
	* @return Reads the next line. If no more lines, FALSE is returned.
	*/
	NOINLINE bool ReadLineCleaned(TokenStr& out);

	/**
	* Reads the next key-value pair from the buffer and advances its position
	* @param key Resulting key (only valid if return value is TRUE)
	* @param value Resulting value (only valid if return value is TRUE)
	* @return TRUE if a Key-Value pair was parsed
	*/
	NOINLINE bool ReadNext(TokenStr& key, TokenStr& value);
};






inline char* tolower(char* str, int len)
{
	char* s = str;
	for (char* e = s + len; s < e; ++s)
		*s = ::tolower(*s);
	return str;
}
inline char* toupper(char* str, int len)
{
	char* s = str;
	for (char* e = s + len; s < e; ++s)
		*s = ::toupper(*s);
	return str;
}
inline std::string& tolower(std::string& str)
{
	char* s = (char*)str.data();
	for (char* e = s + str.length(); s < e; ++s)
		*s = ::tolower(*s);
	return str;
}
inline std::string& toupper(std::string& str)
{
	char* s = (char*)str.data();
	for (char* e = s + str.length(); s < e; ++s)
		*s = ::toupper(*s);
	return str;
}

inline char* replace(char* str, int len, char chOld, char chNew)
{
	char* s = (char*)str;
	for (char* e = s + len; s < e; ++s)
		if (*s == chOld)
			*s = chNew;
	return str;
}