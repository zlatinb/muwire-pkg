@echo off
cd %~dp0
start jre\bin\javaw.exe -Xmx512M -cp "lib\MuWire.jar;lib\unnamed.jar" -Djava.library.path=".;lib" com.muwire.gui.Launcher 
exit
