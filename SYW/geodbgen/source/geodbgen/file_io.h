#pragma once

#include "TokenStr.h"
#include <future> // std::future

	enum IOFlags {
		READONLY,			// opens an existing file for reading
		READONLYEXECUTE,	// open an existing file for read & execute
		READWRITE,			// opens an existing file for read/write
		READWRITECREATE,	// creates or opens an existing file for read/write
		CREATENEW,			// creates new file for writing
	};


	#ifndef SEEK_SET
		#define SEEK_SET 0
		#define SEEK_CUR 1
		#define SEEK_END 2
	#endif

	/**
	 * Automatic whole file loading buffer
	 */
	struct load_buffer
	{
	private:
		load_buffer& operator=(load_buffer& rhs); // NOCOPY
	public:
		friend struct unbuffered_file;


		char*	Buffer;	// dynamic or internal buffer
		int		Size;	// buffer size in bytes


		inline load_buffer() : Buffer(0), Size(0) 
		{
		}
		// takes ownership of a VirtualAlloc pointer and frees it when out of scope
		inline load_buffer(char* buffer, int size) : Buffer(buffer), Size(size)
		{
		}
		inline load_buffer(load_buffer&& mv) : Buffer(mv.Buffer), Size(mv.Size)
		{
			mv.Buffer = 0; // no buffer means no destroy
		}
		inline ~load_buffer()
		{
			if (Buffer) free(Buffer); // MEM_RELEASE
		}
		inline load_buffer& operator=(load_buffer&& mv)
		{
			if (Buffer) free(Buffer);
			Buffer = mv.Buffer;
			Size = mv.Size;
			mv.Buffer = 0;
			return *this;
		}

		template<class T> inline operator T*() { return (T*)Buffer; }
		inline operator TokenStr() const { return TokenStr(Buffer, Buffer + Size); }
		inline TokenStr GetBuffer() const { return TokenStr(Buffer, Buffer + Size); }
	};


	/**
	 * Unbuffered FILE structure for performing unbuffered IO sequential READS,
	 * while WRITE uses normal buffering
	 * This is great for small files that don't actually require any
	 * additional buffering.
	 * This class actually expects files to be read in one go.
	 *
	 *
	 *  Example usage:
	 *         unbuffered_file file("test.obj");
	 *         char* buffer = malloc(file.size());
	 *         file.read(buffer, file.size());
	 *
	 * @warning When writing large amount of data, keep it aligned to 4KB
	 *
	 * @note This file cannot be seeked, due to sequential read/write
	 *
	 */
	struct unbuffered_file
	{
		static const int ALIGNMENT = 4096; // 4KB alignment
		void*	Handle;	// File handle
		IOFlags	Mode;	// File openmode READWRITE or READONLY


		inline unbuffered_file() : Handle(0), Mode(READONLY)
		{
		}

		/**
		 * Opens an existing file for reading with mode = READONLY
		 * Creates a new file for reading/writing with mode = READWRITE
		 * @param filename File name to open or create
		 * @param mode File open mode
		 */
		unbuffered_file(const char* filename, IOFlags mode = READONLY);
		unbuffered_file(const std::string& filename, IOFlags mode = READONLY);
		~unbuffered_file();

		unbuffered_file& operator=(const unbuffered_file& f);
		unbuffered_file& operator=(unbuffered_file&& f);

		/**
		 * @return TRUE if file handle is valid (file exists or has been created)
		 */
		bool good() const;

		/**
		 * @return TRUE if the file handle is INVALID
		 */
		bool bad() const;

		/**
		 * @return Size of the file in bytes
		 */
		int size() const;

		/**
		 * @return Aligned size of the file in bytes 
		 *         (UNBUFFRED read/write operations must be aligned)
		 */
		int size_aligned() const;

		/**
		 * Reads a block of bytes from the file. NO BUFFERING is performed,
		 * so you better only do this in one go, or in large blocks.
		 * 
		 * @param buffer Buffer to read bytes to
		 * @param bytesToRead Number of bytes to read from the file
		 * @return Number of bytes actually read from the file
		 */
		int read(void* buffer, int bytesToRead);

		/**
		 * Reads the entire contents of the file into a load_buffer
		 */
		load_buffer readAll();

		/**
		 * Reads the entire contents of a file into a load_buffer asynchronously
		 */
		inline std::future<load_buffer> readAllAsync()
		{
			return std::async([this]{ return readAll(); });
		}

		/**
		 * Writes a block of bytes to the file. Regular Windows IO
		 * buffering is ENABLED for WRITE.
		 *
		 * @param buffer Buffer to write bytes from
		 * @param bytesToWrite Number of bytes to write to the file
		 * @return Number of bytes actually written to the file
		 */
		int write(void* buffer, int bytesToWrite);

		/**
		 * Creates a new file and fills it with the provided data.
		 * Regular Windows IO buffering is ENABLED for WRITE.
		 *
		 * Openmode is IOFlags::CREATENEW
		 *
		 * @param filename Name of the file to create and write to
		 * @param buffer Buffer to write bytes from
		 * @param bytesToWrite Number of bytes to write to the file
		 * @return Number of bytes actually written to the file
		 */
		static int writenew(const char* filename, void* buffer, int bytesToWrite);

		inline static int writenew(const std::string& filename, void* buffer, int bytesToWrite)
		{
			return writenew(filename.c_str(), buffer, bytesToWrite);
		}

		/**
		 * Seeks to the specified position in a file. Seekmode is 
		 * determined like in fseek: SEEK_SET, SEEK_CUR and SEEK_END
		 *
		 * @note Because there is no read buffering, seek with caution!
		 *
		 * @param filepos Position in file where to seek to
		 * @param seekmode Seekmode to use: SEEK_SET, SEEK_CUR or SEEK_END
		 * @return Current position in the file
		 */
		int seek(int filepos, int seekmode = SEEK_SET);

		/**
		 * @return Current position in the file
		 */
		int tell() const;
	};



	bool file_exists(const char* file);
	bool file_exists(const std::string& file);
	bool file_exists(const TokenStr& file);

	bool folder_exists(const char* folder);
	bool folder_exists(const std::string& folder);
	bool folder_exists(const TokenStr& folder);