@echo off
cd %~dp0
start jre\bin\javaw.exe -Xmx512M -cp "MuWire.jar;unnamed.jar" -Djava.library.path=".;lib" com.muwire.gui.Launcher 
exit
