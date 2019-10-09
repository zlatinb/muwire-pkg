@echo off
cd %~dp0
start /LOW jre\bin\javaw.exe -Xmx512M -cp "MuWire.jar;unnamed.jar;jbigi.jar" -Djava.library.path=".;lib" -DembeddedRouter=true -DupdateType=exe com.muwire.gui.Launcher 
exit
