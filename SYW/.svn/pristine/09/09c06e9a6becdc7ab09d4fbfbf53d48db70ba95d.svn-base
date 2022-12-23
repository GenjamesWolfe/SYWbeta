#include "console.h"
#include <stdio.h>
#define WIN32_LEAN_AND_MEAN 1
#include <Windows.h>

static HANDLE STDOUT = GetStdHandle(STD_OUTPUT_HANDLE);

int console(const char* buffer, int len)
{
	if (len <= 0) 
		return 0;
	DWORD written; 
	WriteConsoleA(STDOUT, buffer, len, &written, 0);
	return (int)written;
}

int consolef(const char* fmt, ...)
{
	char buffer[8192];
	va_list ap; 
	va_start(ap, fmt);
	return console(buffer, vsnprintf(buffer, 8192, fmt, ap));
}