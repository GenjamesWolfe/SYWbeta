#include "file_io.h"
#include <Windows.h>




	static void* OpenFile(const char* filename, IOFlags mode)
	{
		int desiredAccess;
		int creationDisposition; // OPEN_EXISTING, OPEN_ALWAYS, CREATE_ALWAYS
		int openFlags;
		switch (mode)
		{
			default:
			case READONLY:
				desiredAccess       = FILE_GENERIC_READ;
				creationDisposition = OPEN_EXISTING;
				openFlags           = FILE_FLAG_NO_BUFFERING;
				break;
			case READONLYEXECUTE:
				desiredAccess       = FILE_GENERIC_READ|FILE_GENERIC_EXECUTE;
				creationDisposition = OPEN_EXISTING;
				openFlags           = FILE_FLAG_NO_BUFFERING;
				break;
			case READWRITE:
				desiredAccess       = FILE_GENERIC_READ|FILE_GENERIC_WRITE;
				creationDisposition = OPEN_EXISTING; // if not exists, fail
				openFlags           = FILE_ATTRIBUTE_NORMAL;
				break;
			case READWRITECREATE:
				desiredAccess       = FILE_GENERIC_READ|FILE_GENERIC_WRITE;
				creationDisposition = OPEN_ALWAYS; // if exists, success, else create file, success
				openFlags           = FILE_ATTRIBUTE_NORMAL;
				break;
			case CREATENEW:
				desiredAccess       = FILE_GENERIC_READ|FILE_GENERIC_WRITE|DELETE;
				creationDisposition = CREATE_ALWAYS;
				openFlags           = FILE_ATTRIBUTE_NORMAL;
				break;
		}
		void* handle = CreateFileA(filename, desiredAccess, FILE_SHARE_READ, 0, creationDisposition, openFlags, 0);
		return handle != INVALID_HANDLE_VALUE ? handle : 0;
	}

	unbuffered_file::unbuffered_file(const char* filename, IOFlags mode) 
		: Handle(OpenFile(filename, mode)), Mode(mode)
	{
	}
	unbuffered_file::unbuffered_file(const std::string& filename, IOFlags mode)
		: Handle(OpenFile(filename.c_str(), mode)), Mode(mode)
	{
	}
	unbuffered_file::~unbuffered_file()
	{
		if (Handle)
			CloseHandle(Handle);
	}


	bool unbuffered_file::good() const
	{
		return Handle != NULL;
	}

	bool unbuffered_file::bad() const
	{
		return Handle == NULL;
	}

	int unbuffered_file::size() const
	{
		return GetFileSize(Handle, NULL);
	}

	int unbuffered_file::size_aligned() const
	{
		int size = GetFileSize(Handle, NULL);
		if (int rem = size % ALIGNMENT)
			return (size - rem) + ALIGNMENT;
		return size; // already aligned
	}

	int unbuffered_file::read(void* buffer, int bytesToRead)
	{
		if (bytesToRead % ALIGNMENT)
			throw "unbuffered_file::read() 'bytesToRead' must always be aligned to 4KB!";
		DWORD bytesRead;
		ReadFile(Handle, buffer, bytesToRead, &bytesRead, NULL);
		return (int)bytesRead;
	}

	load_buffer unbuffered_file::readAll()
	{
		int alignedSize = GetFileSize(Handle, NULL);
		if (int rem = alignedSize % ALIGNMENT)
			alignedSize = (alignedSize - rem) + ALIGNMENT;

		char* buffer = (char*)malloc(alignedSize);

		DWORD bytesRead;
		ReadFile(Handle, buffer, alignedSize, &bytesRead, NULL);
		return load_buffer(buffer, bytesRead);
	}


	int unbuffered_file::write(void* buffer, int bytesToWrite)
	{
		DWORD bytesWritten;
		WriteFile(Handle, buffer, bytesToWrite, &bytesWritten, NULL);
		return (int)bytesWritten;
	}

	int unbuffered_file::writenew(const char* filename, void* buffer, int bytesToWrite)
	{
		return unbuffered_file(filename, IOFlags::CREATENEW).write(buffer, bytesToWrite);
	}

	int unbuffered_file::seek(int filepos, int seekmode)
	{
		return SetFilePointer(Handle, filepos, NULL, seekmode);
	}

	int unbuffered_file::tell() const
	{
		return SetFilePointer(Handle, 0, NULL, FILE_CURRENT);
	}




	bool file_exists(const char* file)
	{
		DWORD attr = GetFileAttributesA(file);
		return attr != -1 && (attr & FILE_ATTRIBUTE_DIRECTORY) == 0;
	}
	bool file_exists(const std::string& file)
	{
		DWORD attr = GetFileAttributesA(file.c_str());
		return attr != -1 && (attr & FILE_ATTRIBUTE_DIRECTORY) == 0;
	}
	bool file_exists(const TokenStr& tokStr)
	{
		char buffer[MAX_PATH];
		int len = tokStr.length();
		memcpy(buffer, tokStr.str, len);
		buffer[len] = 0;
		DWORD attr = GetFileAttributesA(buffer);
		return attr != -1 && (attr & FILE_ATTRIBUTE_DIRECTORY) == 0;
	}

	bool folder_exists(const char* folder)
	{
		DWORD attr = GetFileAttributesA(folder);
		return attr != -1 && (attr & FILE_ATTRIBUTE_DIRECTORY) != 0;
	}
	bool folder_exists(const std::string& folder)
	{
		DWORD attr = GetFileAttributesA(folder.c_str());
		return attr != -1 && (attr & FILE_ATTRIBUTE_DIRECTORY) != 0;
	}
	bool folder_exists(const TokenStr& folder)
	{
		char buffer[MAX_PATH];
		int len = int(folder.end - folder.str);
		memcpy(buffer, folder.str, len);
		buffer[len] = 0;
		DWORD attr = GetFileAttributesA(buffer);
		return attr != -1 && (attr & FILE_ATTRIBUTE_DIRECTORY) != 0;
	}