# define the name of the installer
Outfile "calculator-setup.exe"
 
# define the directory to install to, the desktop in this case as specified  
# by the predefined $DESKTOP variable
InstallDir "$DESKTOP\calculator"
 
# default section
Section
 
# define the output path for this file
SetOutPath "$INSTDIR"
 
# define what to install and place it in the output path
File /a /r "calculator-app\"
 
SectionEnd
