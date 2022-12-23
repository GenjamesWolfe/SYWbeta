#!/usr/bin/env python3

def get_parent_dir(directory):
    import os
    return os.path.dirname(directory)

import re, os		
from pathlib import Path

all_factions =[]
roman=[]
carthaginian=[]
greek=[]
egyptian=[]
barbarian=[]
eastern=[]
nomad=[]
hun=[]

with open("../Data/export_descr_unit.txt") as input_file_edu:
	with open("detailed_EDU_report_temp.txt", "w") as log_file_edu:
		for lines in input_file_edu:
			n = re.search("(^dictionary)\s+([A-Za-z\_\-0-9/]+)", lines)
			if n is not None:
				type = n.group(2)
				#log_file_edu.writelines('-----\n')
				ownership = 'none'
			else:
				m = re.search("^attributes[\s\,\_A-Za-z0-9]+(mercenary_unit)?", lines, flags = re.IGNORECASE)
				mm = re.search("^attributes[\s\,\_A-Za-z0-9]+(mercenary_unit)", lines, flags = re.IGNORECASE)
				if m is not None:
					if mm is not None:
						log_file_edu.writelines(type+' 		merc\n')
						ownership = 'merc'
					else:
						log_file_edu.writelines(type+' 		 ')
				s = re.search("^ownership\s+([A-Za-z\-_\,\s0-9]+\w,?)", lines, flags = re.IGNORECASE)
				if s is not None:
					if ownership != 'merc':
						log_file_edu.writelines(s.group(1)+'\n')
					else:
						pass

lines_seen = set() # holds lines already seen
outfile_edu = open("detailed_EDU_report.txt", "w")
for line in sorted(open("detailed_EDU_report_temp.txt","r").readlines()):
    if line not in lines_seen: # not a duplicate
        outfile_edu.write(line)
        lines_seen.add(line)
outfile_edu.close()
os.remove("detailed_EDU_report_temp.txt")

with open("../Data/descr_sm_factions.txt") as faction_file:
	for lines in faction_file:
			n = re.search("^faction\s+([A-Za-z\_\s\-0-9]+)", lines)
			if n is not None:
				faction = n.group(1)
				all_factions.append(faction)
			else:
				c = re.search("^culture\s+([A-Za-z\_\-0-9/]+)", lines)
				if c is not None:
					culture = c.group(1)
					if culture == 'roman':
						roman.append(faction)
					elif culture == 'nomad':
						nomad.append(faction)
					elif culture == 'eastern':
						eastern.append(faction)
					elif culture == 'greek':
						greek.append(faction)
					elif culture == 'barbarian':
						barbarian.append(faction)
					elif culture == 'carthaginian':
						carthaginian.append(faction)
					elif culture == 'egyptian':
						egyptian.append(faction)
					elif culture == 'hun':
						hun.append(faction)

with open("detailed_EDU_report.txt") as input_file_report:
	with open("UI_check_list_temp.txt", "w") as log_file_report:
		for lines in input_file_report:
			n = re.search("(^[A-Za-z\_\-0-9]+)\s+([A-Za-z0-9\-\_\,\ ]+)", lines)
			if n is not None:
				type = n.group(1)
				ownership = n.group(2)
				factions = ownership.split(',')
				for faction in factions:
					faction = faction.strip()
					if faction == 'all':
						for faction in all_factions:
							faction = re.sub('[\s+]', '', faction)
							log_file_report.writelines('data/ui/units/'+faction+'/#'+type+'.tga\n')
							log_file_report.writelines('data/ui/unit_info/'+faction+'/'+type+'_info.tga\n')
					elif faction == 'merc':
							log_file_report.writelines('data/ui/units/mercs/#'+type+'.tga\n')
							log_file_report.writelines('data/ui/unit_info/merc/'+type+'_info.tga\n')
					elif faction == 'roman':
						for faction in roman:
							faction = re.sub('[\s+]', '', faction)
							log_file_report.writelines('data/ui/units/'+faction+'/#'+type+'.tga\n')
							log_file_report.writelines('data/ui/unit_info/'+faction+'/'+type+'_info.tga\n')
					elif faction == 'greek':
						for faction in greek:
							faction = re.sub('[\s+]', '', faction)
							log_file_report.writelines('data/ui/units/'+faction+'/#'+type+'.tga\n')
							log_file_report.writelines('data/ui/unit_info/'+faction+'/'+type+'_info.tga\n')
					elif faction == 'carthaginian':
						for faction in carthaginian:
							faction = re.sub('[\s+]', '', faction)
							log_file_report.writelines('data/ui/units/'+faction+'/#'+type+'.tga\n')
							log_file_report.writelines('data/ui/unit_info/'+faction+'/'+type+'_info.tga\n')
					elif faction == 'barbarian':
						for faction in barbarian:
							faction = re.sub('[\s+]', '', faction)
							log_file_report.writelines('data/ui/units/'+faction+'/#'+type+'.tga\n')
							log_file_report.writelines('data/ui/unit_info/'+faction+'/'+type+'_info.tga\n')
					elif faction == 'eastern':
						for faction in eastern:
							faction = re.sub('[\s+]', '', faction)
							log_file_report.writelines('data/ui/units/'+faction+'/#'+type+'.tga\n')
							log_file_report.writelines('data/ui/unit_info/'+faction+'/'+type+'_info.tga\n')
					elif faction == 'egyptian':
						for faction in egyptian:
							faction = re.sub('[\s+]', '', faction)
							log_file_report.writelines('data/ui/units/'+faction+'/#'+type+'.tga\n')
							log_file_report.writelines('data/ui/unit_info/'+faction+'/'+type+'_info.tga\n')
					elif faction == 'hun':
						for faction in hun:
							faction = re.sub('[\s+]', '', faction)
							log_file_report.writelines('data/ui/units/'+faction+'/#'+type+'.tga\n')
							log_file_report.writelines('data/ui/unit_info/'+faction+'/'+type+'_info.tga\n')
					elif faction == '':
						pass
					else:
						log_file_report.writelines('data/ui/units/'+faction+'/#'+type+'.tga\n')
						log_file_report.writelines('data/ui/unit_info/'+faction+'/'+type+'_info.tga\n')
#lines_seen = set() # holds lines already seen
outfile_report = open("UI_check_list.txt", "w")
for line in sorted(open("UI_check_list_temp.txt","r").readlines()):
    if line not in lines_seen: # not a duplicate
        outfile_report.write(line.replace('/','\\'))
        lines_seen.add(line)
outfile_report.close()
os.remove("UI_check_list_temp.txt")
						
with open("..\Data\descr_model_battle.txt") as input_file_m:
	with open("models_check_list.txt", "w") as log_file_m:
		for lines in input_file_m:
			m = re.search("(^model_flexi\s+|^model_flexi_m\s+)((\w+/)?data/models_unit/.*.cas)\,\s(\w+|\d+)", lines)
			if m is not None:
				log_file_m.writelines(m.group(2).replace('/','\\')+ '\n')

with open("..\Data\descr_model_battle.txt") as input_file_s:		
	with open("sprites_check_list.txt", "w") as log_file_s:
		for lines in input_file_s:
			m = re.search("(^model_sprite\s+\w+\,\s+\d+\.\d\,\s+)((\w+/)?data/sprites/.*)", lines)
			if m is not None:
				log_file_s.writelines(m.group(2).replace('/','\\')+'\n')
				
with open("..\Data\descr_model_battle.txt") as input_file_t:
	with open("textures_check_list.txt", "w") as log_file_t:
		for lines in input_file_t:
			m = re.search("(^texture\s+\w+\,\s+)((\w+/)?data/models_unit/.*/\w+.tga)", lines)
			if m is not None:
				log_file_t.writelines(m.group(2).replace('/','\\')+'.dds\n')

with open("models_check_list.txt") as input_file:
	with open("check_models_temp.txt", "w") as log_file:
		for lines in input_file:
			my_file = Path(os.path.join(get_parent_dir(get_parent_dir(os.getcwd())),lines).replace('\n',''))
			if os.path.exists(my_file):
				pass
			else:
				log_file.writelines(lines)
				
with open("textures_check_list.txt") as input_file1:
	with open("check_textures_temp.txt", "w") as log_file1:
		for lines in input_file1:
			my_file1 = Path(os.path.join(get_parent_dir(get_parent_dir(os.getcwd())),lines).replace('\n',''))
			if os.path.exists(my_file1):
				pass
			else:
				log_file1.writelines(lines)
				
with open("sprites_check_list.txt") as input_file2:
	with open("check_sprites_temp.txt", "w") as log_file2:
		for lines in input_file2:
			my_file2 = Path(os.path.join(get_parent_dir(get_parent_dir(os.getcwd())),lines).replace('\n',''))
			if os.path.exists(my_file2):
				pass
			else:
				log_file2.writelines(lines)

with open("UI_check_list.txt") as input_file3:
	with open("check_UI_temp.txt", "w") as log_file3:
		for lines in input_file3:
			my_file3 = Path(os.path.join(get_parent_dir(os.getcwd()),lines).replace('\n',''))
			if os.path.exists(my_file3):
				pass
			else:
				log_file3.writelines(lines)
				
#lines_seen = set() # holds lines already seen
outfile = open("check_content.txt", "w")
outfile.writelines('--------------------------------------------------------------------------------\nMissing models:\n--------------------------------------------------------------------------------\n')
for line in sorted(open("check_models_temp.txt","r").readlines()):
    if line not in lines_seen: # not a duplicate
        outfile.write(line)
        lines_seen.add(line)

outfile.writelines('--------------------------------------------------------------------------------\nMissing textures:\n--------------------------------------------------------------------------------\n')
for line in sorted(open("check_textures_temp.txt","r").readlines()):
    if line not in lines_seen: # not a duplicate
        outfile.write(line)
        lines_seen.add(line)

outfile.writelines('--------------------------------------------------------------------------------\nMissing sprites:\n--------------------------------------------------------------------------------\n')
for line in sorted(open("check_sprites_temp.txt","r").readlines()):
    if line not in lines_seen: # not a duplicate
        outfile.write(line)
        lines_seen.add(line)

outfile.writelines('--------------------------------------------------------------------------------\nMissing UIs:\n--------------------------------------------------------------------------------\n')
for line in sorted(open("check_UI_temp.txt","r").readlines()):
    if line not in lines_seen: # not a duplicate
        outfile.write(line)
        lines_seen.add(line)
		
outfile.close()
os.remove("check_models_temp.txt")
os.remove("check_sprites_temp.txt")
os.remove("check_textures_temp.txt")
os.remove("check_UI_temp.txt")
os.remove("models_check_list.txt")
os.remove("textures_check_list.txt")
os.remove("sprites_check_list.txt")
os.remove("UI_check_list.txt")