/*
 * D3 - DDS loading
 * 09-04-09: Created!
 * 16-04-09: Now vertically flips DDS files. Wasn't that easy, since you need to flip each 4x4 pixel block.
 * FUTURE:
 * - Add max mipmap level (if DDS file doesn't contain all mipmap levels)
 * (C) 2009 Cruden BV
 */

//#include <d3/d3.h>
//#include <qlib/debug.h>
#include "dds.h"
#include <stdlib.h>
#include "console.h"
#include <string.h>

// Loading images
//#define LTRACE_LOAD

// Magic
#define MAGIC_DDS 0x20534444			// DDS<space>

// DXT<n> id's
#define ID_DXT1	 0x31545844
#define ID_DXT3	 0x33545844
#define ID_DXT5	 0x35545844

#define GL_COMPRESSED_RGBA_S3TC_DXT1_EXT	0x83F1
#define GL_COMPRESSED_RGBA_S3TC_DXT3_EXT	0x83F2
#define GL_COMPRESSED_RGBA_S3TC_DXT5_EXT	0x83F3

//
// c/dtor
//
DDS::DDS()
{
	for(int i = 0; i < MAX_MIPMAP_LEVEL; ++i)
	{
		pixels[i] = nullptr;
		bytes[i] = 0;
	}
	mipmapLevels = 0;
	width        = 0;
	height       = 0;
	format       = 0;
	compressionType = 0;
	internalFormat  = 0;
	blockSize       = 0;
}
DDS::~DDS()
{
	for(int i = 0; i < MAX_MIPMAP_LEVEL; ++i)
		free(pixels[i]);
}

static void ConvertARGB2RGBA(unsigned char* a,int n)
{
	// In hex dump: BGRA -> RGBA
	n >>= 2; // n /= 4;
	for (int i = 0; i < n; ++i)
	{
		unsigned char t = a[2];
		a[2] = a[0];
		a[0] = t;
		a += 4;
	}
}

static void FlipDXT1BlockFull(unsigned char* data)
// A DXT1 block layout is:
// [0-1] color0.
// [2-3] color1.
// [4-7] color bitmap, 2 bits per pixel.
// So each of the 4-7 bytes represents one line, flipping a block is just
// flipping those bytes.
// Note that http://src.chromium.org/viewvc/chrome/trunk/src/o3d/core/cross/bitmap_dds.cc?view=markup&pathrev=21227
// contains an error in the last line: data[6]=data[5] is a bug!
{
//return;
	unsigned char tmp;

	tmp = data[4];
	data[4] = data[7];
	data[7] = tmp;

	tmp = data[5];
	data[5] = data[6];
	data[6] = tmp;

//data[4]=data[5]=data[6]=data[7]=0;
}

static void FlipDXT3BlockFull(unsigned char* block)
// Flips a full DXT3 block in the y direction.
{
	// A DXT3 block layout is:
	// [0-7]	alpha bitmap, 4 bits per pixel.
	// [8-15] a DXT1 block.

	// We can flip the alpha bits at the byte level (2 bytes per line).
	unsigned char tmp = block[0];
	block[0] = block[6];
	block[6] = tmp;
	tmp = block[1];
	block[1] = block[7];
	block[7] = tmp;
	tmp = block[2];
	block[2] = block[4];
	block[4] = tmp;
	tmp = block[3];
	block[3] = block[5];
	block[5] = tmp;

	// And flip the DXT1 block using the above function.
	FlipDXT1BlockFull(block + 8);
}

static void QByteDump(unsigned char* a, int n)
{
	int i,j,bits;
	char buf[1024],*d;

	consolef("Bitdump at %p", a);
	bits=0;
	d=buf;
	for(i=0;i<n;i++)
	{
		for(j=0;j<8;j++)
		{
			if(a[i]&(1<<j))*d++='1';
			else					 *d++='0';
			if((bits%12)==11)*d++='.';
			bits++;
		}
	}
	*d=0;
	consolef("%s\n", buf);
}
static void FlipDXT5BlockFull(unsigned char* block)
// From http://src.chromium.org/viewvc/chrome/trunk/src/o3d/core/cross/bitmap_dds.cc?view=markup&pathrev=21227
// Original source contained bugs; fixed here.
{
	// A DXT5 block layout is:
	// [0]		alpha0.
	// [1]		alpha1.
	// [2-7]	alpha bitmap, 3 bits per pixel.
	// [8-15] a DXT1 block.

	// The alpha bitmap doesn't easily map lines to bytes, so we have to
	// interpret it correctly.	Extracted from
	// http://www.opengl.org/registry/specs/EXT/texture_compression_s3tc.txt :
	//
	//	 The 6 "bits" bytes of the block are decoded into one 48-bit integer:
	//
	//		 bits = bits_0 + 256 * (bits_1 + 256 * (bits_2 + 256 * (bits_3 +
	//									 256 * (bits_4 + 256 * bits_5))))
	//
	//	 bits is a 48-bit unsigned integer, from which a three-bit control code
	//	 is extracted for a texel at location (x,y) in the block using:
	//
	//			 code(x,y) = bits[3*(4*y+x)+1..3*(4*y+x)+0]
	//
	//	 where bit 47 is the most significant and bit 0 is the least
	//	 significant bit.
	//QByteDump(block+2,6);

	// From Chromium (source was buggy)
	unsigned int line_0_1 = block[2] + 256 * (block[3] + 256 * block[4]);
	unsigned int line_2_3 = block[5] + 256 * (block[6] + 256 * block[7]);
	// swap lines 0 and 1 in line_0_1.
	unsigned int line_1_0 = ((line_0_1 & 0x000fff) << 12) |
		((line_0_1 & 0xfff000) >> 12);
	// swap lines 2 and 3 in line_2_3.
	unsigned int line_3_2 = ((line_2_3 & 0x000fff) << 12) |
		((line_2_3 & 0xfff000) >> 12);
	block[2] = line_3_2 & 0xff;
	block[3] = (line_3_2 & 0xff00) >> 8;
	block[4] = (line_3_2 & 0xff0000) >> 16;
	block[5] = line_1_0 & 0xff;
	block[6] = (line_1_0 & 0xff00) >> 8;
	block[7] = (line_1_0 & 0xff0000) >> 16;

	//QByteDump(block+2,6);

	// And flip the DXT1 block using the above function.
	FlipDXT1BlockFull(block+8);
}



bool DDS::Load(const char* fname)
{
	unsigned char* temp = 0;

	FILE* f = fopen(fname, "rb");

	int magic;
	fread(&magic, sizeof(magic), 1, f);
	if (magic != MAGIC_DDS) goto fail;
	else
	{
		// Direct3D 9 format
		D3D_SurfaceDesc2 header;
		fread(&header, sizeof(header), 1, f);

		// Remember info for users of this object
		width        = header.dwWidth;
		height       = header.dwHeight;
		mipmapLevels = header.dwMipMapCount;
		int nBytes   = header.dwHeight * header.dwWidth; // Number of pixels
		blockSize    = 16; // Block size default

		// DXT5?
		if (header.ddpfPixelFormat.dwFlags & DDPF_FOURCC)
		{
			// Compressed
			format = DDS_FORMAT_YCOCG; // ???????? Not right
			unsigned int fourCC = header.ddpfPixelFormat.dwFourCC;
			if (fourCC == ID_DXT1)
			{
				blockSize      = 8;
				internalFormat = GL_COMPRESSED_RGBA_S3TC_DXT1_EXT;
			} 
			else if (fourCC == ID_DXT3)
			{
				internalFormat = GL_COMPRESSED_RGBA_S3TC_DXT3_EXT;
			} 
			else if (fourCC == ID_DXT5)
			{
				// DXT5
				internalFormat = GL_COMPRESSED_RGBA_S3TC_DXT5_EXT;
			} 
			else
			{
				consolef("DDS:Load(%s); unknown compressed format (%.*s)", 4, &fourCC);
				goto fail;
			}
			// DXT5 compression
			//bytes/=4;
		} 
		else if (header.ddpfPixelFormat.dwRGBBitCount == 32)
		{
			format = DDS_FORMAT_RGBA8;
			// Calculate bytes for highest mipmap level
			//bytes=header.dwHeight*header.dwWidth*header.ddpfPixelFormat.dwRGBBitCount/8;
			nBytes = nBytes * header.ddpfPixelFormat.dwRGBBitCount/8;
		} 
		else // if(header.ddpfPixelFormat.dwRGBBitCount!=32)
		{
			consolef("DDS:Load(%s); unknown DDS format (rgb bitcount not 32, not DXT5)", fname);
			goto fail;
		}

		// Read all mipmap levels
		int w = width;
		int h = height;
		for (int i = 0; i < header.dwMipMapCount && i < MAX_MIPMAP_LEVEL; ++i)
		{
			// Deduce # of bytes
			// Close to the higher mipmap levels, wid or hgt may become 0; keep things at 1
			if (!w) ++w;
			if (!h) ++h;

			if (format == DDS_FORMAT_RGBA8)
			{
				// RGBA8
				nBytes = w * h * 4;
			} 
			else
			{
				// DXTx
				nBytes = ((w+3)/4)*((h+3)/4)*blockSize;
				if (i==0)
				{
					// Create temp buffer to flip DDS
					temp = (unsigned char*)malloc(nBytes);
				}
			}

			bytes[i]  = nBytes;
			pixels[i] = (unsigned char*)malloc(nBytes);
			if (!pixels[i])
			{
				printf("DDS:Load(%s); out of memory for mipmap level %d",fname,i);
				goto fail;
			}

			if (format != DDS_FORMAT_RGBA8)
			{
				// First read in temp buffer
				fread(temp, nBytes, 1, f);
				// Flip & copy to actual pixel buffer
				int widBytes,k;
				widBytes=((w+3)/4)*blockSize;
				unsigned char* s = temp;
				unsigned char* d = pixels[i] + ((h+3)/4-1)*widBytes;
				for (int j = 0; j < (h+3)/4; ++j)
				{
					memcpy(d,s,widBytes);
					if(blockSize==8)
					{
						for(k=0;k<widBytes/blockSize;k++)
							FlipDXT1BlockFull(d+k*blockSize);
					} else
					{
						// DXT3, DXT5
						if(compressionType==DDS_COMPRESS_BC2)
						{
							// DXT3
							for(k=0;k<widBytes/blockSize;k++)
								FlipDXT3BlockFull((unsigned char*)d+k*blockSize);
						} else
						{
							// DXT5
							for(k=0;k<widBytes/blockSize;k++)
								FlipDXT5BlockFull((unsigned char*)d+k*blockSize);
						}
					}
					s+=widBytes;
					d-=widBytes;
				}
			} 
			else
			{
				// RGBA8
				if(format==DDS_FORMAT_RGBA8)
				{
					ConvertARGB2RGBA(pixels[i],nBytes);
				}
			}
			// Next level is smaller
			w /= 2;
			h /= 2;
		}
		// Release temp buffer
		free(temp);
	}

	fclose(f);
	return true;
fail:
	fclose(f);
	return false;
}

