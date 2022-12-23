/**
 * Copyright (c) 2014 - Jorma Rebane
 */
#pragma once
#include <vector>
#include "TokenStr.h"
#include <stdarg.h>
#include <stdlib.h>

/**
 * binary_reader - A basic binary reader
 */
struct binary_writer
{
	char*		Buffer;
	unsigned	Size;		// current size
	unsigned	Capacity;	// total buffer capacity

	inline binary_writer() : Buffer(0), Size(0), Capacity(0)
	{
	}
	inline binary_writer(unsigned capacity) 
		: Buffer((char*)malloc(capacity)), Size(0), Capacity(capacity)
	{
	}
	inline ~binary_writer()
	{
		if (Buffer) free(Buffer);
	}

	inline void clear()
	{
		Size = 0;
		Buffer[0] = 0;
	}


	binary_writer& writef(const char* fmt, ...)
	{
		char buffer[8192];
		va_list ap;
		va_start(ap, fmt);
		return write(buffer, vsprintf(buffer, fmt, ap));
	}

	inline binary_writer& writeln()
	{
		return write('\n');
	}
	inline binary_writer& writeln(const std::string& str)
	{
		return write(str.c_str(), str.length()).write('\n');
	}
	inline binary_writer& writeln(const TokenStr& str)
	{
		return write(str.c_str(), str.length()).write('\n');
	}
	template<int SIZE> inline binary_writer& writeln(const char (&str)[SIZE])
	{
		return write(str, SIZE - 1).write('\n');
	}
	binary_writer& writeln(const char* str, int len)
	{
		return write(str, len).write('\n');
	}


	inline binary_writer& write(const std::string& str)
	{
		return write(str.c_str(), str.length());
	}
	inline binary_writer& write(const TokenStr& str)
	{
		return write(str.c_str(), str.length());
	}
	template<int SIZE> inline binary_writer& write(const char (&str)[SIZE])
	{
		return write(str, SIZE - 1);
	}
	template<class T> inline binary_writer& write(const T& data)
	{
		return write((const void*)&data, sizeof(T));
	}

	void ensure(unsigned numBytes)
	{
		if (numBytes > (Capacity - Size))
			Buffer = (char*)realloc(Buffer, Capacity += 16384); // 16KB increase
	}
	void ensure()
	{
		if (Size == Capacity)
			Buffer = (char*)realloc(Buffer, Capacity += 16384); // 16KB increase
	}

	binary_writer& write_byte(unsigned char value)
	{
		ensure();
		*(unsigned char*)&Buffer[Size++] = value;
		return *this;
	}
	binary_writer& write_short(short value)
	{
		ensure(2);
		*(short*)&Buffer[Size] = value;
		Size += 2;
		return *this;
	}
	
	binary_writer& write(const void* data, unsigned numBytes)
	{
		ensure(numBytes);
		memcpy(Buffer + Size, data, numBytes);
		Size += numBytes;
		return *this;
	}

	binary_writer& write(char ch)
	{
		ensure();
		Buffer[Size++] = ch;
		return *this;
	}

	// fill the buffer with the specified number of the specified char (memset)
	binary_writer& fill(char ch, unsigned fillCount)
	{
		ensure(fillCount);
		memset(Buffer + Size, ch, fillCount);
		Size += fillCount;
		return *this;
	}

	// padded write
	binary_writer& writepd(const TokenStr& str, int minWidth)
	{
		int strLen = str.length();
		int padding = minWidth - strLen;

		write(str.str, strLen);

		if (padding > 0)
		{
			int numTabs = 0;
			for (; padding >= 4; padding -= 4) ++numTabs;
			if (padding) ++numTabs;
			fill('\t', numTabs);
		}
		return *this;
	}


	/**
	 * Write a null-terminated string to the buffer
	 * in the form of [data][0]
	 */
	binary_writer& write_cstr(const TokenStr& str)
	{
		return write(str.c_str(), str.length()).write('\0');
	}
};


/**
 * Extension to the binary_reader - manages the buffer and auto-loads the file
 */
struct binary_filewriter : public binary_writer
{
	std::string Filename;

	inline binary_filewriter()
	{
	}
	inline binary_filewriter(const std::string& filename) : Filename(filename)
	{
	}
	inline binary_filewriter(std::string&& filename) : Filename((std::string&&)filename)
	{
	}
	inline binary_filewriter(const char* filename) : Filename(filename)
	{
	}
	inline ~binary_filewriter()
	{
		flush();
	}
	
	/**
	 * Flushes all data to file
	 * @note This creates a new file, writes all the data and closes the file
	 *       So only call this once!!!
	 *       Use binary_streamwriter for multiple flushes
	 * @warning This also !clears! the binary_writer Buffer
	 * @return TRUE if all bytes were written to the file, 
	 *         FALSE if some or none of the bytes were written
	 */
	bool flush();
};

/**
 * @todo Implement this - a binary stream writer
 */
struct binary_streamwriter
{

};
