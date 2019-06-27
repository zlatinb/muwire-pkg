#MuWire Packaging Project

This is a project for packaging MuWire for various platforms.

You need to have MuWire (https://github.com/zlatinb/muwire) and I2P (github or monotone) checked out as siblings to this project.

1. Build MuWire as described in the MuWire README
2. Set JAVA_HOME to your installation of JDK11+
3. Set one or more of the following:
    JAVA_HOME_WIN - to where the windows jdk installation is
    JAVA_HOME_MAC - to where the osx jdk installation is
    JAVA_HOME_LINUX - to where the linux jdk installation is
4. run "build.sh"
5. If all goes well, the mini-jvms for each platform will be in the "dist" folder.

Note that compression is disabled because it is assumed that the final redistributable will be compressed using lzma or such.

The file "jlink.modules" contains modules which are forcibly included by jlink.
