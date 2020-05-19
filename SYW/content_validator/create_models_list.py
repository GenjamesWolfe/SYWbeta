#!/usr/bin/env python3
import re, os		

with open("..\Data\descr_model_battle.txt") as input_file:
	with open("descr_model_battle_dictionary_temp.txt", "w") as log_file:
		for lines in input_file:
			m = re.search("^type\s+([A-Za-z\_0-9\-]+)", lines)
			if m is not None:
				log_file.writelines(m.group(1)+'\n')
lines_seen = set() # holds lines already seen
outfile = open("used_models.txt", "w")
for line in sorted(open("descr_model_battle_dictionary_temp.txt","r").readlines()):
    if line not in lines_seen: # not a duplicate
        outfile.write(line)
        lines_seen.add(line)
outfile.close()
os.remove("descr_model_battle_dictionary_temp.txt")
