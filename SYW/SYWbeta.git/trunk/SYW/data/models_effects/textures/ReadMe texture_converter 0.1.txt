alpaca's MTW2 .texture converter, version 0.1

Content:
------------------------------------------------------------------

1. Installation

2. Usage

3. Note

4. Changelog

5. License

------------------------------------------------------------------

1. Installation

In order to use this tool, you need to download and install Python 2.5 from http://www.python.org/downloads first
What you are searching for is probably the "Python 2.5 Windows installer", so if you're unsure, just download and install this.

After the installation of Python, extract this archive to your data directory (inside the folder where
you unpacked the MTW2 files with CA's unpacker) or the directory in which you want to convter the files.


------------------------------------------------------------------

2. Usage

To convert .texture files to .dds files, run convert_all_textures.bat. This will convert all files in the folder the script resides in 
as well as in all subfolders (useful for converting all files.
Alternatively, run convert_all_textures_nosub.bat which will only convert the files inside the folder the script is in, not in the subfolders.

To convert .dds files to .texture files, run convert_all_dds.bat. As above, this will also convert files in subfolders.
Again, there's a convert_all_dds_nosub.bat for no subfolder conversion.


Command-line options:
-all: Converts all files, if this option is supplied, filenames can be omitted
-d,--dds: Convert .dds to .texture
-h,--help: Display the help page
-sub: Also convert all files in all subfolders, can only be used with -all
-t,--texture: Convert .texture to .dds (default, can be omitted)
-v: Verbose option, extra output


------------------------------------------------------------------

3. Note

Some dds files can't be reconverted to texture files. The converter will print out messages about this.
Support for them may be added in the future.


------------------------------------------------------------------

4. Changelog

Nothing yet


------------------------------------------------------------------

5. License

You may freely redistribute altered or unaltered versions of this script, although for altered versions you have
to mention this release in the read-me.
You may use this script in your own programs, if you do so, please mention this release in the read-me.