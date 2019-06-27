@echo off
cd %~dp0
start jre\bin\javaw.exe -Xmx512M -p lib --add-modules ALL-MODULE-PATH -Djava.library.path=".;lib" com.muwire.gui.Launcher 
exit
