# ads-service-app

# Mandatory info:
this is our ads service app flowchart and following the implementation in DART

JSON 

url 	=
title 	=
length	=
stime	=
etime	=
id_video	=
id_screen	=


OOOOO		.2				oooooooooooooooooooo       ooooooo
OOOOO.1		.2				oooooooooooooooooooo       ooooooo
OOOOO.1		.2				oooooooooooooooooooo       ooooooo
OOOOO.1		.2				oooooooooooooooooooo       ooooooo
OOOOO 		.2				oooooooooooooooooooo       ooooooo

screen 							   video1 (N)			video2 (N)


APP 

Refresh Button
Video peview Button
Aspect Ratio    Landscape Yes[X] (Full screen) / NO [X] (normal screen) -----> normal
				|
				|
				--------------YES 90 degree rotation -------------

	
								should read again the json file  --> PS: read only index 0
								json should be outside the app binary
								 |
ooooooooooooooooooooooooooo		 |		ooooooooooooooooooooooooooo	
o                         o		 |		o                         o
o                         o		 |		o                         o
o                         o		 |		o                         o----------------------------------------------------------------> SERVER SIDE
o                         o		 |		o                         o<----------------------------------------------------------------
o                         o		 |		o xxxxxxxxxxxxxxxxxxxxxxx o
o     landscape Y [X] 90° o		 |		o xxxxxxxxxxxxxxxxxxxxxxx o
o               N [ ]     o		 |		o xxxxxxxxxxxxxxxxxxxxxxx o
o                         o		 |		o xxxxxxxxxxxxxxxxxxxxxxx o
o                         o		 |		o xxxxxxxxxxxxxxxxxxxxxxx o
o                         o		 |		o xxxxxxxxxxxxxxxxxxxxxxx o
o     refresh             o	-----|		o                         o
o                         o				o                         o
o     preview             o-----------> o                         o
o                         o				o                         o
o                         o				o                         o
ooooooooooooooooooooooooooo				ooooooooooooooooooooooooooo
