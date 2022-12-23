#include <cstdio>
#include <cstdlib>
#include "console.h"
#include "file_io.h"
#include "binary_reader.h"
#include "binary_writer.h"
#include "dds.h"
#include <unordered_map>
#include <cassert>

using namespace std;
typedef unsigned char byte;

struct DMBParser
{
	TokenStr Buffer;
	DMBParser(const TokenStr& buffer) : Buffer(buffer) {}
	bool readline(TokenStr& line, TokenStr& id, int& depth)
	{
		while (Buffer.next(line, "\r\n", 2))
		{
			char ch = line.trim_start()[0];
			if (ch == ';' || line.empty()) 
				continue; // next line plz
			if (ch == '{') 
			{ 
				++depth; 
				continue; 
			}
			if (ch == '}') 
			{ 
				if (--depth <= 0) 
					return false; // } and depth dropped to <= 0, we're done with parsing this section
				continue; 
			}
			line.next(id, " \t;", 3);
			return true; // OK read a line
		}
		return false; // no more lines in Buffer
	}

};

struct Geography
{
	int Version; // RTW is version 5

	//// Height
	struct
	{
		float smooth_ratio_min;		// 0.01	nominal ratio of noise vs step size for complete smoothness
		float smooth_ratio_max;		// 0.25	nominal ratio of noise vs step size for no smoothness (max sharpness)
		float slope_flat;			// 0.2	maximum slope of flat regions (1 - cos(angle))
		float slope_steep;			// 0.5	nominal slope of steep regions
		float slope_steepest;		// 2.5	maximum slope for the terrain
		float step_min;				// 0.33	maximum number of std deviations bias to flat regions
		float step_max;				// 2.0	maximum number of std deviations bias to steep regions
	} height;

	//// Ground
	struct
	{
		float slope_flat;			// 0.075	maximum slope of flat regions (1 - cos(angle)) (0.2 is approx 36 degrees)
		float slope_factor_flat;	// 0.04		maximum influence over flat ground ;>> THIS MODIFIES THE AMOUNT OF TREES ON THE BATTLEFIELD. HIGHER VALUE = MORE TREES.
		float slope_factor_steep;	// 2.0		amplify the effect of steep slopes
		float curvature_factor;		// 1.0		amplify the effect of curvature
	} ground;

	//// River
	struct
	{
		float valley_factor;	// 0.9		reduce the river height to a percentage of the sampled height
		float valley_bias;		// -10.0	adjust the river height by the amount (in metres)
		float std_height;		// 150.0	std height at which the river is the std width
		float std_width;		// 64.0		std width of the river junctions
		float tidal_width;		// 192.0	width at sea level
		float ford_width;		// 60.0		width of the ford (metres)

		float noise_sea_level;	// 0.25		proportion of segement length deviation during subdivision (at sea level)
		float noise_trans;		// 0.1		proportion of segement length deviation during subdivision
		float noise_rot;		// 0.1		standard deviation of rotation applied to direction during subdivision (radians)
		float noise_rot_max;	// 0.25		max rotation (radians)
		float noise_width;		// 0.05		standard deviation of width proportion to apply during subdivision
		float noise_width_max;	// 0.25		max width variation
	} river;

	void read(binary_reader& reader)
	{
		reader.read(this, sizeof(Geography));
	}

	void readtxt(DMBParser& parser) // a bit harder to parse text...
	{
		Version    = 5; // always 5
		int target = 0; // 0:height, 1:ground, else:river
		int depth  = 0;
		TokenStr line, id;
		while (parser.readline(line, id, depth)) // for each line
		{
			if (target == 0) // height, all values here start with S
			{
				if (id == "ground") { target = 1; continue; }
				if (id[0] == 's')
				{
					if (id == "smooth_ratio_min")	{ height.smooth_ratio_min = line.nextFloat(); continue; }
					if (id == "smooth_ratio_max")	{ height.smooth_ratio_max = line.nextFloat(); continue; }
					if (id == "slope_flat")			{ height.slope_flat       = line.nextFloat(); continue; }
					if (id == "slope_steep")		{ height.slope_steep      = line.nextFloat(); continue; }
					if (id == "slope_steepest")		{ height.slope_steepest   = line.nextFloat(); continue; }
					if (id == "step_min")			{ height.step_min		  = line.nextFloat(); continue; }
					if (id == "step_max")			{ height.step_max		  = line.nextFloat(); continue; }
				}
			}
			else if (target == 1) // ground
			{
				if (id == "river") { target = 2; continue; }
				if (id[0] == 's') {
					if (id == "slope_flat")			{ ground.slope_flat		    = line.nextFloat(); continue; }
					if (id == "slope_factor_flat")	{ ground.slope_factor_flat	= line.nextFloat(); continue; }
					if (id == "slope_factor_steep")	{ ground.slope_factor_steep = line.nextFloat(); continue; }
				} else 
					if (id == "curvature_factor")	{ ground.curvature_factor   = line.nextFloat(); continue; }
			}
			else switch (id[0]) // river
			{
				case 'v':
					if (id == "valley_factor")	{ river.valley_factor = line.nextFloat(); continue; }
					if (id == "valley_bias")	{ river.valley_bias   = line.nextFloat(); continue; }
					continue;
				case 's':
					if (id == "std_height")		{ river.std_height = line.nextFloat(); continue; }
					if (id == "std_width")		{ river.std_width  = line.nextFloat(); continue; }
					continue;
				case 't':
					if (id == "tidal_width")	{ river.tidal_width = line.nextFloat(); continue; }
					continue;
				case 'f':
					if (id == "ford_width")		{ river.ford_width  = line.nextFloat(); continue; }
					continue;
				case 'n':
					if (id == "noise_sea_level"){ river.noise_sea_level = line.nextFloat(); continue; }
					if (id == "noise_trans")	{ river.noise_trans     = line.nextFloat(); continue; }
					if (id == "noise_rot")		{ river.noise_rot		= line.nextFloat(); continue; }
					if (id == "noise_rot_max")	{ river.noise_rot_max   = line.nextFloat(); continue; }
					if (id == "noise_width")	{ river.noise_width		= line.nextFloat(); continue; }
					if (id == "noise_width_max"){ river.noise_width_max = line.nextFloat(); continue; }
			}
		}
	}
	
	void write(binary_writer& out) // binary write
	{
		out.write<Geography>(*this); // easy enough
	}
	void writetxt(binary_writer& out) const
	{
		out.write("generation\n{\n");
		out.write("	height\n	{\n");
		out.writef("\t\tsmooth_ratio_min\t%-8g; nominal ratio of noise vs step size for complete smoothness\n", height.smooth_ratio_min);
		out.writef("\t\tsmooth_ratio_max\t%-8g; nominal ratio of noise vs step size for no smoothness (max sharpness)\n", height.smooth_ratio_max);
		out.writef("\t\tslope_flat		\t%-8g; maximum slope of flat regions (1 - cos(angle))\n", height.slope_flat);
		out.writef("\t\tslope_steep		\t%-8g; nominal slope of steep regions\n", height.slope_steep);
		out.writef("\t\tslope_steepest	\t%-8g; maximum slope for the terrain\n", height.slope_steepest);
		out.writef("\t\tstep_min		\t%-8g; maximum number of std deviations bias to flat regions\n", height.step_min);
		out.writef("\t\tstep_max		\t%-8g; maximum number of std deviations bias to steep regions\n", height.step_max);
		out.write("	}\n\n");
		out.write("	ground\n	{\n");
		out.writef("\t\tslope_flat		\t%-8g; maximum slope of flat regions (1 - cos(angle)) (0.2 is approx 36 degrees)\n", ground.slope_flat);
		out.writef("\t\tslope_factor_flat\t%-8g; maximum influence over flat ground && higher value => more trees on battlefield\n", ground.slope_factor_flat);
		out.writef("\t\tslope_factor_steep\t%-8g; amplify the effect of steep slopes\n", ground.slope_factor_steep);
		out.writef("\t\tcurvature_factor\t%-8g; amplify the effect of curvature\n", ground.curvature_factor);
		out.write("	}\n\n");
		out.write("	river\n	{\n");
		out.writef("\t\tvalley_factor	\t%-8g; reduce the river height to a percentage of the sampled height\n", river.valley_factor);
		out.writef("\t\tvalley_bias		\t%-8g; adjust the river height by the amount (in metres)\n", river.valley_bias);
		out.writef("\t\tstd_height		\t%-8g; std height at which the river is the std width\n", river.std_height);
		out.writef("\t\tstd_width		\t%-8g; std width of the river junctions\n", river.std_width);
		out.writef("\t\ttidal_width		\t%-8g; width at sea level\n", river.tidal_width);
		out.writef("\t\tford_width		\t%-8g; width of the ford (metres)\n", river.ford_width);
		out.writef("\t\tnoise_sea_level	\t%-8g; proportion of segement length deviation during subdivision (at sea level)\n", river.noise_sea_level);
		out.writef("\t\tnoise_trans		\t%-8g; proportion of segement length deviation during subdivision\n", river.noise_trans);
		out.writef("\t\tnoise_rot		\t%-8g; standard deviation of rotation applied to direction during subdivision (radians)\n", river.noise_rot);
		out.writef("\t\tnoise_rot_max	\t%-8g; max rotation (radians)\n", river.noise_rot_max);
		out.writef("\t\tnoise_width		\t%-8g; standard deviation of width proportion to apply during subdivision\n", river.noise_width);
		out.writef("\t\tnoise_width_max	\t%-8g; max width variation\n", river.noise_width_max);
		out.write("	}\n\n");
		out.write("}\n\n");
	}
};


enum Ground			: int	{ GTUnknown = -1, GTRock, GTGravel, GTSandCaked, GTSand, GTSandBlown, GTDirt, GTMud, GTSwamp, GTGrassDry, GTGrassShort, GTGrassLong, GTShrubSparse, GTShrubDense, GTForestSparse, GTForestDense, };
enum Quality		: char	{ QUnknown	= -1, QNone, QVeryLow, QLow, QNormal, QHigh, QVeryHigh };
enum Hardness		: char	{ GHUnknown = -1, GHSwamp, GHSand = 16, GHSoil = 32, GHClay = 48, GHShale = 64, GHRock = 80 };
enum GenerationType			{ UNKNOWN	= -1, FERTILE_LOW, FERTILE_MEDIUM, FERTILE_HIGH, WILDERNESS, MOUNTAINS_HIGH, MOUNTAINS_LOW, HILLS, FOREST_DENSE, FOREST_SPARSE, SWAMP, OCEAN, SEA_DEEP, SEA_SHALLOW, BEACH };
enum ClimateType			{ CTUnknown = -1, CTDefault, CTSandyDesert, CTRockyDesert, CTTemperateGrasslandFertile, CTTemperateGrasslandInfertile, CTTemperateForestOpen, CTTemperateForestDeep, CTSwamp, CTHighland, CTAlpine, CTSubArctic, CTSemiArid, };

const char* GroundStr(int type)
{
	static const char* types[] = { "rock", "gravel", "sand_caked", "sand", "sand_blown", "dirt", "mud", "swamp", "grass_dry", "grass_short", "grass_long", "shrub_sparse", "shrub_dense", "forest_sparse", "forest_dense" };
	return (GTRock <= type && type <= GTForestDense) ? types[type] : "unknown";
}
Ground GroundParse(const TokenStr& token)
{
	if (token == "rock")			return GTRock;
	if (token == "gravel")			return GTGravel;
	if (token == "sand_caked")		return GTSandCaked;
	if (token == "sand")			return GTSand;
	if (token == "sand_blown")		return GTSandBlown;
	if (token == "dirt")			return GTDirt;
	if (token == "mud")				return GTMud;
	if (token == "swamp")			return GTSwamp;
	if (token == "grass_dry")		return GTGrassDry;
	if (token == "grass_short")		return GTGrassShort;
	if (token == "grass_long")		return GTGrassLong;
	if (token == "shrub_sparse")	return GTShrubSparse;
	if (token == "shrub_dense")		return GTShrubDense;
	if (token == "forest_sparse")	return GTForestSparse;
	if (token == "forest_dense")	return GTForestDense;
	return GTUnknown;
}
const char* QualityStr(int type)
{
	static const char* types[] = { "NONE", "VERY_LOW", "LOW", "NORMAL", "HIGH", "VERY_HIGH" };
	return (QNone <= type && type <= QVeryHigh) ? types[type] : types[0];
}
Quality QualityParse(const TokenStr& token)
{
	if (token == "NONE")		return QNone;
	if (token == "VERY_LOW")	return QVeryLow;
	if (token == "LOW")			return QLow;
	if (token == "NORMAL")		return QNormal;
	if (token == "HIGH")		return QHigh;
	if (token == "VERY_HIGH")	return QVeryHigh;
	return QUnknown;
}
const char* HardnessStr(int type) //// @note GroundHardness index is a multiple of 16
{
	static const char* types[] = { "SWAMP", "SAND", "SOIL", "CLAY", "SHALE", "ROCK" };
	return (GHSwamp <= type && type <= GHRock) ? types[type>>4] : types[0];
}
Hardness HardnessParse(const TokenStr& token)
{
	if (token == "SWAMP")	return GHSwamp;
	if (token == "SAND")	return GHSand;
	if (token == "SOIL")	return GHSoil;
	if (token == "CLAY")	return GHClay;
	if (token == "SHALE")	return GHShale;
	if (token == "ROCK")	return GHRock;
	return GHUnknown;
}
const char* GenerationStr(int type)
{
	static const char* types[] = { "FERTILE_LOW", "FERTILE_MEDIUM", "FERTILE_HIGH", "WILDERNESS", "MOUNTAINS_HIGH", "MOUNTAINS_LOW", "HILLS", "FOREST_DENSE", "FOREST_SPARSE", "SWAMP", "OCEAN", "SEA_DEEP", "SEA_SHALLOW", "BEACH" };
	return (FERTILE_LOW <= type && type <= BEACH) ? types[type] : "UNKNOWN";
}
GenerationType GenerationParse(const TokenStr& token)
{
	if (token == "FERTILE_LOW")		return FERTILE_LOW;
	if (token == "FERTILE_MEDIUM")	return FERTILE_MEDIUM;
	if (token == "FERTILE_HIGH")	return FERTILE_HIGH;
	if (token == "WILDERNESS")		return WILDERNESS;
	if (token == "MOUNTAINS_HIGH")	return MOUNTAINS_HIGH;
	if (token == "MOUNTAINS_LOW")	return MOUNTAINS_LOW;
	if (token == "HILLS")			return HILLS;
	if (token == "FOREST_DENSE")	return FOREST_DENSE;
	if (token == "FOREST_SPARSE")	return FOREST_SPARSE;
	if (token == "SWAMP")			return SWAMP;
	if (token == "OCEAN")			return OCEAN;
	if (token == "SEA_DEEP")		return SEA_DEEP;
	if (token == "SEA_SHALLOW")		return SEA_SHALLOW;
	if (token == "BEACH")			return BEACH;
	return UNKNOWN;
}
const char* ClimateStr(int type)
{
	static const char* types[] = { "default", "sandy_desert", "rocky_desert", "temperate_grassland_fertile", "temperate_grassland_infertile",  "temperate_forest_open", "temperate_forest_deep", "swamp", "highland", "alpine", "sub_arctic", "semi_arid" };
	return (CTDefault <= type && type <= CTSemiArid) ? types[type] : types[0];
}
ClimateType ClimateParse(const TokenStr& token)
{
	if (token == "default")							return CTDefault;
	if (token == "sandy_desert")					return CTSandyDesert;
	if (token == "rocky_desert")					return CTRockyDesert;
	if (token == "temperate_grassland_fertile")		return CTTemperateGrasslandFertile;
	if (token == "temperate_grassland_infertile")	return CTTemperateGrasslandInfertile;
	if (token == "temperate_forest_open")			return CTTemperateForestOpen;
	if (token == "temperate_forest_deep")			return CTTemperateForestDeep;
	if (token == "swamp")							return CTSwamp;
	if (token == "highland")						return CTHighland;
	if (token == "alpine")							return CTAlpine;
	if (token == "sub_arctic")						return CTSubArctic;
	if (token == "semi_arid")						return CTSemiArid;
	return CTUnknown;
}




struct RGBA
{
	byte r, g, b, a;
};

static byte _DefaultSummer[][3] = {
	236, 0,   140,	// rock
	102, 45,  145,	// gravel
	146, 39,  143,	// sand_caked
	237, 20,  91,	// sand
	237, 28,  36,	// sand_blown
	242, 101, 34,	// dirt
	247, 148, 29,	// mud
	255, 242, 0,	// swamp
	141, 198, 63,	// grass_dry
	57,  181, 74,	// grass_short
	0,   166, 81,	// grass_long
	0,   114, 188,	// shrub_sparse
	0,   114, 188,	// shrub_dense
	0,   114, 188,	// forest_sparse
	0,   114, 188,	// forest_dense
	0,   0,   0,
};

static unordered_map<string, RGBA> DefaultSummer; // default rgb values: ground_type => color
static unordered_map<string, RGBA> GroundColours; // parsed rgb values:  path => color

void init_ground_colours()
{
	DefaultSummer.clear();
	GroundColours.clear();
	DefaultSummer["rock"]			= { 133, 119, 97, };
	DefaultSummer["gravel"]			= { 139, 120, 88, };
	DefaultSummer["sand_caked"]		= { 136, 104, 65, };
	DefaultSummer["sand"]			= { 142, 113, 74, };
	DefaultSummer["sand_blown"]		= { 136, 104, 65, };
	DefaultSummer["dirt"]			= { 155, 125, 87, };
	DefaultSummer["mud"]			= { 155, 125, 87, };
	DefaultSummer["swamp"]			= { 155, 125, 87, };
	DefaultSummer["grass_dry"]		= { 97,  93,  58, };
	DefaultSummer["grass_short"]	= { 130, 108, 73, };
	DefaultSummer["grass_long"]		= { 115, 91, 62, };
	DefaultSummer["shrub_sparse"]	= { 105, 79, 48, };
	DefaultSummer["shrub_dense"]	= { 100, 88, 59, };
	DefaultSummer["forest_sparse"]	= { 65,  68, 44, };
	DefaultSummer["forest_dense"]	= { 116, 99, 61, };
}

RGBA get_ground_rgba(const TokenStr& filepath, const TokenStr& defaultGroundType = "rock")
{
	string path = tolower(filepath.toString());
	auto it = GroundColours.find(path);
	if (it != GroundColours.end())
		return it->second; // we've already parsed this

	if (!file_exists(path)) 
	{
		consolef("WARNING! Texture %s missing, reverting to default colour\n", path.c_str());
		return DefaultSummer[defaultGroundType.toString()];
	}

	DDS dds;
	dds.Load(path.c_str());
	int width  = dds.GetWidth() >> 7;
	int height = dds.GetHeight() >> 7;
	RGBA* data = (RGBA*)dds.GetMipData(7);
	int count  = width * height;

	RGBA avg = data[0];
	for (int i = 1; i < count; ++i) {
		avg.r = byte((int)avg.r + (int)data[i].r);
		avg.g = byte((int)avg.g + (int)data[i].g);
		avg.b = byte((int)avg.b + (int)data[i].b);
		avg.a = byte((int)avg.a + (int)data[i].a);
	}
	GroundColours.insert(make_pair(path, avg));
	return avg;
}



struct TextureEntry
{
	TokenStr tex;
	byte b, g, r;	// BGR color
	byte _align;
};

struct Season
{
	int numTextures;
	std::vector<TextureEntry> textures;
	TokenStr envmap;

	bool read(binary_reader& reader)
	{
		reader.read(numTextures);
		if (numTextures > 16) {
			consolef("Invalid Climate Entry: (%d texture entries)\n", numTextures);
			return true; // error
		}
		textures.resize(numTextures);
		for (auto& t : textures) {
			if (reader.readByte() == 1) {
				int len = (int)reader.read<short>() - 1;	// string length
				reader.readString(t.tex, len, true);		// true: skip a nullterm
				reader.read(&t.b, 3); // read BGR
			}
		}
		// read envmap
		int len = (int)reader.read<short>() - 1; // string length
		reader.readString(envmap, len, true);
		return false; // ok
	}
	void write(binary_writer& writer) const
	{
		writer.write(numTextures);
		for (auto& t : textures) {
			if (t.tex) {
				writer.write_byte(1);		// entry is used
				writer.write_short(t.tex.length() + 1);
				writer.write_cstr(t.tex);
				writer.write(&t.b, 3);		// write BGR
			}
			else
				writer.write_byte(0);		// entry is "none"
		}
		writer.write_short(envmap.length() + 1);
		writer.write_cstr(envmap);
	}

	void readtxt(DMBParser& parser)
	{
		int depth = 0;
		TokenStr line, id;
		while (parser.readline(line, id, depth))
		{
			if (id == "texture")
			{
				TokenStr type = line.next(" \t"); // ground type 
				TokenStr path = line.next(" \t;");
				if (type == "env_map") {
					envmap = path;
					continue;
				}

				textures.emplace_back();
				TextureEntry& te = textures.back();
				if (path == "none")
					continue; // empty texture entry

				TokenStr r = line.next(" \t;");
				TokenStr g = line.next(" \t;");
				TokenStr b = line.next(" \t;");
				if (r & g & b) // we have all 3 entries?
				{
					te.b = (byte)b.toInt();
					te.g = (byte)g.toInt();
					te.r = (byte)r.toInt();
				}
				else
				{
					RGBA color = get_ground_rgba(path, type);
					te.b = color.b;
					te.g = color.g;
					te.r = color.r;
				}
				te.tex = path;
			}
		}
		numTextures = (int)textures.size();
	}
};


struct Conversion
{
	short		climate_id;	// climate id == ClimateType
	Quality		quality;	// ground quality
	Hardness	hardness;	// ground hardness
};


struct Generation
{
	int hard;				// hardness
	int quality;			// quality

	float	hs_fade_in;		// H Spectrum
	float	hs_median;		// ---
	float	hs_fade_out;	// ---
	float	hs_bias;		// H noise
	float	hs_std_dev;		// ---

	float	gs_fade_in;		// G Spectrum
	float	gs_median;		// ---
	float	gs_fade_out;	// ---
	float	gs_bias;		// G noise
	float	gs_std_dev;		// ---
};



struct Climate
{
	ClimateType type;
	int			numSeasons;			// number of seasons - always 2
	Season		seasons[2];			// 0:summer, 1:winter
	Ground		qual_swamp	[6];	// quality table?, 6x6
	Ground		qual_sand	[6];
	Ground		qual_soil	[6];
	Ground		qual_clay	[6];
	Ground		qual_shale	[6];
	Ground		qual_rock	[6];
	Conversion	conversion  [15];	// conversion table
	Generation	generation  [14];	// generation SGT entries

	bool read(int climateType, binary_reader& reader)
	{
		type = ClimateType(climateType);
		reader.read(numSeasons);
		if (numSeasons != 2) {
			consolef("Invalid season entry: numSeasons(%d) != 2\n", numSeasons);
			return true;
		}

		if (seasons[0].read(reader) || seasons[1].read(reader))
			return true; // error
		reader.read(qual_swamp, 36);	// quality table 6x6 ints
		reader.read(conversion, 15);	// conversion table...
		reader.read(generation, 14);	// terrain generation table
		return false; // no error
	}
	void write(binary_writer& writer) const
	{
		writer.write(numSeasons);
		seasons[0].write(writer);
		seasons[1].write(writer);
		writer.write(qual_swamp, sizeof(Ground) * 36);
		writer.write(conversion, sizeof(Conversion) * 15);
		writer.write(generation, sizeof(Generation) * 14);
	}

	void readtxt(Ground* qual, TokenStr& line)
	{
		for (int i = 0; i < 6; ++i)
			qual[i] = GroundParse(line.next(" \t;"));
	}
	void readtxt(Conversion& conv, TokenStr& line)
	{
		conv.climate_id = (short)type;
		conv.hardness   = HardnessParse(line.next(" \t"));
		conv.quality    = QualityParse(line.next(" \t;"));
	}
	void readtxt(Generation& gen, TokenStr& line)
	{
		gen.hard		= HardnessParse(line.next(" \t"))>>4;
		gen.quality		= QualityParse(line.next(" \t"));
		float* fptr = &gen.hs_fade_in; // long live the hacks
		for (int i = 0; i < 10; ++i, ++fptr)
			*fptr = line.nextFloat(); // read hs_fade_in to gs_std_dev (10 floats)
	}

	void readtxt(int climateType, DMBParser& parser)
	{
		type = ClimateType(climateType);
		numSeasons = 2; // always 2 seasons
		int mode = 0;
		int depth = 0;
		TokenStr line, id;
		while (parser.readline(line, id, depth))
		{
			if (id == "season")
			{
				if (line.next(" \t;") == "summer")	seasons[0].readtxt(parser);
				else								seasons[1].readtxt(parser);
			}
			else if (id == "table")
			{
				int tableDepth = 0;
				while (parser.readline(line, id, tableDepth)) // until }
				{
					switch (HardnessParse(id))
					{
					case GHUnknown:	consolef("ERROR! Unrecognized table subtype %.*s!", id.length(), id.c_str());
					case GHSwamp:	readtxt(qual_swamp, line);	break;
					case GHSand:	readtxt(qual_sand, line);	break;
					case GHSoil:	readtxt(qual_soil, line);	break;
					case GHClay:	readtxt(qual_clay, line);	break;
					case GHShale:	readtxt(qual_shale, line);	break;
					case GHRock:	readtxt(qual_rock, line);	break;
					}
				}
			}
			else if (id == "conversion")
			{
				int conversionDepth = 0;
				while (parser.readline(line, id, conversionDepth))
				{
					switch (GroundParse(id))
					{
					case GTUnknown:		consolef("ERROR! Unrecognized ground type %.*s!\n", id.length(), id.c_str());	break;
					case GTRock:		readtxt(conversion[0], line);	break;
					case GTGravel:		readtxt(conversion[1], line);	break;
					case GTSandCaked:	readtxt(conversion[2], line);	break;
					case GTSand:		readtxt(conversion[3], line);	break;
					case GTSandBlown:	readtxt(conversion[4], line);	break;
					case GTDirt:		readtxt(conversion[5], line);	break;
					case GTMud:			readtxt(conversion[6], line);	break;
					case GTSwamp:		readtxt(conversion[7], line);	break;
					case GTGrassDry:	readtxt(conversion[8], line);	break;
					case GTGrassShort:	readtxt(conversion[9], line);	break;
					case GTGrassLong:	readtxt(conversion[10], line);	break;
					case GTShrubSparse:	readtxt(conversion[11], line);	break;
					case GTShrubDense:	readtxt(conversion[12], line);	break;
					case GTForestSparse:readtxt(conversion[13], line);	break;
					case GTForestDense:	readtxt(conversion[14], line);	break;
					}
				}
			}
			else if (id == "generation")
			{
				int generationDepth = 0;
				while (parser.readline(line, id, generationDepth))
				{
					switch (GenerationParse(id))
					{
					case UNKNOWN:			consolef("ERROR! Unrecognized generation type %.*s!\n", id.length(), id.c_str()); break;
					case FERTILE_LOW:		readtxt(generation[0], line);	break;
					case FERTILE_MEDIUM:	readtxt(generation[1], line);	break;
					case FERTILE_HIGH:		readtxt(generation[2], line);	break;
					case WILDERNESS:		readtxt(generation[3], line);	break;
					case MOUNTAINS_HIGH:	readtxt(generation[4], line);	break;
					case MOUNTAINS_LOW:		readtxt(generation[5], line);	break;
					case HILLS:				readtxt(generation[6], line);	break;
					case FOREST_DENSE:		readtxt(generation[7], line);	break;
					case FOREST_SPARSE:		readtxt(generation[8], line);	break;
					case SWAMP:				readtxt(generation[9], line);	break;
					case OCEAN:				readtxt(generation[10], line);	break;
					case SEA_DEEP:			readtxt(generation[11], line);	break;
					case SEA_SHALLOW:		readtxt(generation[12], line);	break;
					case BEACH:				readtxt(generation[13], line);	break;
					}
				}
			}
		}
	}

	void writetxt(binary_writer& out) const
	{
		if (type != CTDefault)	out.writef("%s modifies default\n{\n", ClimateStr(type));
		else					out.writef("%s\n{\n", ClimateStr(type));

		for (int j = 0; j < 2; ++j) 
		{
			out.writef("	season %s\n	{\n", j == 0 ? "summer" : "winter");
			auto& s = seasons[j];
			for (int i = 0; i < s.numTextures; ++i)
			{
				out.writef("		texture		%-12s	", GroundStr(i));
				auto& e = s.textures[i];
				if (e.tex)	out.writef("%.*s\t%d\t%d\t%d\n", e.tex.length(), e.tex.c_str(), e.r, e.g, e.b);
				else		out.writef("none\n");
			}
			out.write("		texture		env_map     \t").writeln(s.envmap);
			out.write("	}\n\n");
		}

		out.write("	table\n");
		out.write("	{   ;       QUAL_NONE    QUAL_VERY_LOW  QUAL_LOW     QUAL_NORMAL  QUAL_HIGH     QUAL_VERY_HIGH\n");
		out.write("	    ;       ---------    -------------  --------     -----------  ---------     --------------\n\n");
		for (int i = 0; i < 6; ++i) 
		{
			const Ground* q = qual_swamp + (i * 6);
			out.writef("		%-8s%-13s%-15s%-13s%-13s%-14s%s\n", HardnessStr(i<<4), 
					   GroundStr(q[0]), GroundStr(q[1]), GroundStr(q[2]), GroundStr(q[3]), GroundStr(q[4]), GroundStr(q[5]));
		}
		out.write("	}\n\n");

		out.write("	conversion\n	{\n");
		for (int i = 0; i < 15; ++i) 
		{
			const Conversion& c = conversion[i];
			out.writef("		%-16s%-8s%s\n", GroundStr(i), HardnessStr(c.hardness), QualityStr(c.quality));
		}
		out.write("	}\n\n");

		out.write("	generation\n");
		out.write("	{   ;               +--Ground--+      +------H Spectrum------+  +--H Noise--+  +------G Spectrum------+  +--G Noise--+\n");
		out.write("	    ; SGT           Hard    Qual      fade-in median  fade-out  bias  std dev  fade-in median  fade-out  bias  std dev\n");
		out.write("	    ; ---           ----    ----      ------- ------  --------  ----  -------  ------- ------  --------  ----  -------\n\n");
		for (int i = 0; i < 14; ++i) 
		{
			const Generation& g = generation[i];
			//                SGT    hard qual fadein median fadout  bias stddev  fadein median fadeout  bias stddev
			out.writef("\t    %-14s  %-7s %-9s %-7g %-7g %-8g  %-5g %-7g  %-7g %-7g %-8g  %-5g %g\n",
					 GenerationStr(i), HardnessStr(g.hard<<4), QualityStr(g.quality), 
					 g.hs_fade_in, g.hs_median, g.hs_fade_out, g.hs_bias, g.hs_std_dev,
					 g.gs_fade_in, g.gs_median, g.gs_fade_out, g.gs_bias, g.gs_std_dev);
		}
		out.write("	}\n}\n\n");
	}
};


// for manual override
#if _DEBUG
static const bool ENABLE_DEBUGGING = true;
#else
static const bool ENABLE_DEBUGGING = false;
#endif

int create_geographyDB(const char* inTXT, const char* outDB)
{
	unbuffered_file file(inTXT);
	if (file.bad()) {
		printf("ERROR! Failed to open TXT file '%s'\n", inTXT);
		return 1; // FILE_ERROR
	}

	load_buffer lb = file.readAll();
	DMBParser parser(lb);

	Geography header; 
	header.readtxt(parser); // parse header from tokenstr
	vector<Climate> climates;

	int depth = 0;
	TokenStr line, id;
	while (parser.readline(line, id, depth))
	{
		int         expectedId   = climates.size();
		const char* expectedName = ClimateStr(expectedId);
		if (!id.equals(expectedName, strlen(expectedName)))
		{
			consolef("WARNING! Expected climate %s, but found %.*s instead!\n",
					expectedName, id.length(), id.c_str());
		}
		climates.emplace_back();
		climates.back().readtxt(expectedId, parser);
	}


	if (ENABLE_DEBUGGING) // DEBUGGING
	{
		binary_filewriter out(string(inTXT) + ".parse_dbg.txt");
		out.writef(";; This file generated from %s by geodbgen\n", inTXT);
		out.write(";;  == RTW Geography DB Generator written by RedFox ==\n\n");
		header.writetxt(out);
		out.writeln();
		for (auto& climate : climates) climate.writetxt(out);
	}

	binary_filewriter out(outDB);
	header.write(out);
	out.write((int)climates.size());
	for (Climate& climate : climates)
	{
		climate.write(out);
	}

	if (!out.flush()) {
		consolef("ERROR! Writing result to '%s' failed!\n", outDB);
		return 1; // FILE_ERROR
	}
	consolef("Successfully generated '%s'.\n", outDB);
	return 0;
}

int read_geographyDB(const char* inDB, const char* outTXT)
{
	binary_filereader reader(inDB);
	if (reader.bad()) {
		consolef("ERROR! Failed to open DB file '%s'\n", inDB);
		return 1; // FILE_ERROR
	}

	Geography* header = reader.get_block_ptr<Geography>(1);
	int numClimates   = reader.readInt();
	std::vector<Climate> climates(numClimates);
	for (int i = 0; i < (int)climates.size(); ++i) {
		if (climates[i].read(i, reader)) {
			consolef("ERROR! Failed to ready '%s'. The DB might be corrupted.\n", inDB);
			return 2; // PARSE_ERROR
		}
	}

	binary_filewriter out(outTXT);
	out.writef(";; This file generated from %s by geodbgen\n", inDB);
	out.write(";;  == RTW Geography DB Generator written by RedFox ==\n\n");
	header->writetxt(out);
	out.writeln();
	for (auto& climate : climates) climate.writetxt(out);

	if (!out.flush()) {
		consolef("ERROR! Writing result to '%s' failed!\n", outTXT);
		return 1; // FILE_ERROR
	}
	consolef("Successfully generated '%s'.\n", outTXT);
	return 0;
}


int print_usage()
{
	printf("== RTW Geography DB Generator ==\n"
		   "==         by RedFox          ==\n"
		   "Usage:\n"
		   "    geodbgen -[c/r] [inputFile] [outputFile]\n"
		   "\n"
		   "        -c    Create a new descr_geography.db from a descr_geography.txt\n"
		   "                ex: inputFile    mydescr_geography.txt \n"
		   "                    outputFile   mydescr_geography.DB  \n"
		   "        -r    Reads descr_geography.db and generates a descr_geography.txt\n"
		   "                ex: inputFile    mydescr_geography.DB  \n"
		   "                    outputFile   mydescr_geography.txt \n"
		   "\n"
		   "        ex:\n"
		   "            geodbgen -c descr_geography_RTR.txt descr_geography.db\n"
		   "            geodbgen -r descr_geography.db descr_geography_RESTORED.txt\n"
		   "    note:\n"
		   "        With option [-c] (TXT) geodbgen automatically opens texture path\n"
		   "        in order to generate correct texture colours. If the textures don't\n"
		   "        exist a warning is issued and default climate colours are used.\n"
		   );
	return 0; // not really an error
}

#include "enumerator.h"


Enum(MyEnum, 
	Value1, Value2, Value3
);

int main(int argc, char** argv)
{
	MyEnum value = MyEnum::Value1;

	MyEnum value1		= enum_parse<MyEnum>("Value1");
	TokenStr strValue1	= enum_str(value1);



	init_ground_colours();

	// DEBUGGING:
	if (ENABLE_DEBUGGING)
	{
		read_geographyDB("descr_geography_RTR.db", "descr_geography_RTR.txt");
		create_geographyDB("descr_geography_RTR.txt", "descr_geography_RTR_new.db");

		
		// ensure these files match!
		unbuffered_file origDb("descr_geography_RTR.db");
		unbuffered_file newDb("descr_geography_RTR_new.db");

		int sizeA = origDb.size();
		int sizeB = newDb.size();
		assert(sizeA == sizeB);
		load_buffer buffA = origDb.readAll();
		load_buffer buffB = newDb.readAll();
		assert(memcmp(buffA.Buffer, buffB.Buffer, buffA.Size) == 0);

		return 0;
	}

	if (argc == 4 && argv[1][0] == '-') { // valid args?
		if (argv[1][1] == 'c') return create_geographyDB(argv[2], argv[3]);
		if (argv[1][1] == 'r') return read_geographyDB(argv[2], argv[3]);
	}
	return print_usage();
}


