@echo off
cd %~dp0
start jre\bin\javaw.exe -Xmx512M -cp "MuWire.jar;unnamed.jar" -Djava.library.path=".;lib" -DembeddedRouter=true com.muwire.gui.Launcher 
exit
