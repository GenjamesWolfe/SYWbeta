/**
 * Copyright (c) 2014 - Jorma Rebane
 */
#pragma once

int console(const char* buffer, int len);
int consolef(const char* fmt, ...);
template<int SIZE> inline int console(const char (&str)[SIZE])
{
	return console(str, SIZE - 1);
}