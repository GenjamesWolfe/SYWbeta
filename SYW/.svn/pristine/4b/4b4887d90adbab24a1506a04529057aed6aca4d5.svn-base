#include "binary_writer.h"
#include "file_io.h"

	bool binary_filewriter::flush()
	{
		if (int size = Size)
		{
			int written = unbuffered_file::writenew(Filename, Buffer, size);
			clear();
			return size == written;
		}
		return false;
	}