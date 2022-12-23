Hadrian v0.4.6

By - Samuel Roehr (aka GodsPetMonkey)
sroehr@gmail.com

You can always find the latest version, information and guides @ - 
http://forums.totalwar.org/vb/showthread.php?t=38858
http://www.twcenter.net/downloads/db/?mod=244

ALWAYS BACKUP YOUR FILES!

Guides - Here are some guides to using Hadrian.
http://www.users.on.net/~roehr/RTW/Guides/HadrianGuide.htm
http://www.users.on.net/~roehr/RTW/Guides/unitstobuildings.htm

Information - You will need some VB6 runtimes in order to execute this program, at a guess, these would include
 - MSCOMCTL.ocx - http://www.majorgeeks.com/files/mscomctl.zip
 - COMDLG32.ocx - http://www.ascentive.com/support/new/images/lib/COMDLG32.OCX
 - msvbvm60.dll - http://www.microsoft.com/downloads/details.aspx?FamilyID=bf9a24f9-b5c5-48f4-8edd-cdf2d29a79d5&displaylang=en (thanks Soulflame!)

Put the OCX files you get into your /windows/system32 directory. the DLL is in a self installer.


Hadrian is a program that is designed to allow GUI editing of RTW's building file. It also supports the enums and description files. Hadrian is designed for both new and advanced users, and it can be easy to use the more advanced features and cause the game to stop working. Always be mindful of the hardcoded limits imposed by CA.

Basic Guide - This guide will help you to enable a unit to be built by a certain structure. You must know the unit you want to use beforehand!
First, fire up Hadrian, then open your export_descr_buildings.txt file, then select the base building complex from the left most dropdown box at the top of the screen. Then select the particular iteration of the building to the right of that. Now select the capabilities tab.
If the building you selected can already build the unit, and you just want to enable it for a certain faction, select the unit from the "Units" dropdown box, and then add the faction by typing its name (or culture) in the editbox below the factions list box (note, you can remove the others by highlighting them and pressing the R button, if there are none in there, it will be enabled for all factions to be built) and press the A button, adding it to the list. Then press the E button below the "Units" drop box, then hit "Save Changes" and finally, press "Save" and select a file to save to. Your done, copy the file and rename appropriately.
If the unit has to be added to the building, proceed to fill out the relevant fields. Make sure you put 'recruit' (ALL lower case!!!) in the "Type" editbox and the "Name" editbox matches the 'type' entry from your export_descr_unit.txt file. When ready, press the A button, then hit "Save Changes" and finally, "Save". That’s it, make sure you copy the file and rename appropriately, and it should work. If the game CTDs, please make sure all your inputs where correct before contacting me about it.

Remember, if you don’t know what it does, leave it as it is!

Revision History - 
0.4.6 - More bug fixes

0.4.5 - Minor bug fixes

0.4.4 - Fixed an issue with adding units to buildings with out any units prior

0.4.3 - Added ability to import a list of unit 'Names' (Types) from a export_descr_unit.txt file
	Added "Cascade" button to the recruitment section of the building's capabilities. This button will copy the selected recruit into all buildings above this one (by level) it the same complex
	Fixed up some bugs with adding building capabilities

0.4.2 - Fixed an issue where a units "Magic Number" wouldn't be displayed when selected in building capabilities
	Renamed "Magic Number" to "Starting Experiance"

0.4.1 - Fixed issue with negative figures for bonuses
	Increased file handling flexibility

0.4.0 - Fixed several interface issues
	Fixed several minor bugs
	Added ability to edit /text/export_buildings.txt
	Added ability to automatically generate export_descr_buildings_enums.txt from /text/export_buildings.txt
	Made some of the file handling more robust

0.3.2 - Fixed an issue that prevented Hadrian from reading the buildings file from RTR 3.0

0.3.1 - Fixed up some UI issues

0.3.0 - Added "Create New Complex" button and functionality
	Added "Remove Complex" functionality
	Added the ability to add a new building (level) to a complex by use of the "Levels:" listbox
	Added the ability to remove a building (level) from a complex by use of the "Levels:" listbox
	Many bugfixes

0.2.1 - Added autocomplete-as-you-type functionality for a limited number of dropdown boxes

0.2.0 - First public release! Reads, edits and saves RTW building Files!

0.1.0 - Testing release, Full read functionality.
