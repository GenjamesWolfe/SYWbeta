#include "binary_reader.h"
#include <cstdlib>
#include "file_io.h"

	bool binary_filereader::open(const char* filename)
	{
		destroy(); // destroy buffer if it's open

		unbuffered_file file(filename, IOFlags::READONLY);
		if (file.good())
		{
			int alignedSize = file.size_aligned();
			Buffer = (char*)malloc(alignedSize);
			Size = file.read(Buffer, alignedSize);
			return true;
		}
		return false;
	}

	void binary_filereader::destroy()
	{
		if (Buffer)
		{
			free(Buffer);
			Buffer      = 0;
			SeekPos     = 0;
			Size        = 0;
		}
	}