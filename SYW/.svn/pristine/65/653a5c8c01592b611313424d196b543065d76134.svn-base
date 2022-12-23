/**
 * Copyright (c) 2014 - Jorma Rebane
 */
#pragma once
#include "TokenStr.h"

/**
 * binary_reader - A basic binary reader
 */
struct binary_reader
{
	char*		Buffer;
	unsigned	SeekPos;
	unsigned	Size;

	inline binary_reader() : Buffer(NULL), Size(0), SeekPos(0) 
	{
	}
	/**
	 * Initializes the binary_reader from the specified buffer
	 * @note The buffer is owned by the caller
	 */
	inline binary_reader(void* buffer, unsigned bufferSize) 
		: Buffer((char*)buffer), Size(bufferSize), SeekPos(0)
	{
	}


	inline bool good() const { return Buffer != NULL; }
	inline bool bad() const { return Buffer == NULL; }
	inline unsigned tell() const { return SeekPos; }
	inline unsigned size() const { return Size; }
	// look at current seek position through a pointer (very useful function)
	template<class T> inline T* tell_ptr() { return (T*)&Buffer[SeekPos]; }

	/**
	 * Gets the pointer to data block of size (sizeof(T) * count)
	 */
	template<class T> inline T* get_block_ptr(unsigned count)
	{
		T* data = (T*)&Buffer[SeekPos];
		SeekPos += sizeof(T) * count;
		return data;
	}


	inline unsigned seek_set(unsigned pos) { return SeekPos = pos; }
	inline unsigned seek_cur(int offset) { return SeekPos += offset; }
	inline unsigned seek_end(int offset) { return SeekPos = Size + offset; }


	// read from current file pos
	template<class T> inline void read(T& out)
	{
		out = *(T*)&Buffer[SeekPos];
		SeekPos += sizeof(T);
	}
	template<class T, int SIZE> inline void read(T (&out)[SIZE])
	{
		memcpy(out, &Buffer[SeekPos], sizeof(out));
		SeekPos += sizeof(out);
	}
	template<class T> inline T read()
	{
		T* value = (T*)&Buffer[SeekPos];
		SeekPos += sizeof(T);
		return *value;
	}
	inline void read(void* dst, unsigned numBytes)
	{
		memcpy(dst, &Buffer[SeekPos], numBytes);
		SeekPos += numBytes;
	}
	template<class T> inline void read(T* dst, unsigned count)
	{
		int numBytes = sizeof(T) * count;
		memcpy(dst, &Buffer[SeekPos], numBytes);
		SeekPos += numBytes;
	}
	template<class T> inline void readVector(std::vector<T>& out, unsigned count)
	{
		out.resize(count);
		size_t size = sizeof(T) * count;
		memcpy(out, &Buffer[SeekPos], size);
		SeekPos += size;
	}


	// I know we can repeat these with read<int>() etc.., 
	// but we want to avoid an extra fn call and
	// thus have the fn properly inline itself

	inline int readInt() 
	{
		int value = *(int*)&Buffer[SeekPos];
		SeekPos += sizeof(int);
		return value; 
	}

	inline unsigned char readByte()
	{
		unsigned char value = *(unsigned char*)&Buffer[SeekPos];
		SeekPos += sizeof(unsigned char);
		return value;
	}
	inline short readShort()
	{
		short value = *(short*)&Buffer[SeekPos];
		SeekPos += sizeof(short);
		return value;
	}
	inline float readFloat() 
	{
		float value = *(float*)&Buffer[SeekPos];
		SeekPos += sizeof(float);
		return value;
	}

	/**
	 * Reads a null-terminated C-string [data][0]. No size data is given.
	 */
	void readCString(std::string& out)
	{
		char* start = &Buffer[SeekPos];
		char* end = strchr(start, '\0');

		if (end > &Buffer[Size])
			end = &Buffer[Size];

		out.assign(start, end);
		SeekPos = int(end - start) + 1;
	}

	/**
	 * Reads a C string [data][0] as a TokenStr [size][data]
	 */
	void readCString(TokenStr& out)
	{
		char* start = &Buffer[SeekPos];
		char* end = strchr(start, '\0');

		if (end > &Buffer[Size])
			end = &Buffer[Size];

		out.str = start;
		out.end = end;
		SeekPos += int(end - start) + 1;
	}

	/**
	 * Uses length for string start/end and optionally skips a null-terminator
	 */
	void readString(TokenStr& out, int length, bool nullterm = false)
	{
		char* start = &Buffer[SeekPos];
		char* end = start + length;

		if (end > &Buffer[Size]) // some failure tolerance
			end = &Buffer[Size];

		out.str = start;
		out.end = end;
		SeekPos += length;
		if (nullterm) ++SeekPos;
	}
};


/**
 * Extension to the binary_reader - manages the buffer and auto-loads the file
 * @note The entire file is loaded, so avoid this for large files!
 */
struct binary_filereader : public binary_reader
{
	inline binary_filereader()
	{
	}
	inline binary_filereader(const char* filename)
	{
		open(filename);
	}
	inline ~binary_filereader()
	{
		destroy();
	}
	
	//// Opens file and reads all the data from it
	bool open(const char* filename);

	//// Destroys the allocated buffer and clears reader state
	void destroy();
};


/**
 * @todo Implement this - a streaming binaryreader
 */
struct binary_streamreader
{

};

