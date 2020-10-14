# MuWire Packaging Project

This is a project for packaging MuWire for various platforms.

You need to have MuWire (https://github.com/zlatinb/muwire) and I2P (github or monotone) checked out as siblings to this project.

### Building a JRE for MuWire

0. Build I2P with `ant clean pkg`
1. Build MuWire as described in the MuWire README
2. Set JAVA_HOME to your installation of JDK11+
3. Set one or more of the following:
    JAVA_HOME_WIN - to where the windows jdk installation is
    JAVA_HOME_MAC - to where the osx jdk installation is
    JAVA_HOME_LINUX - to where the linux jdk installation is
4. run "jlink.sh"
5. If all goes well, the mini-jvms for each platform will be in the "dist" folder.

Note that compression is disabled because it is assumed that the final redistributable will be compressed using lzma or such.

The file "jlink.modules" contains modules which are forcibly included by jlink.

### Building the Windows installer

##### Option A: On Debian-based systems:

You need to have dos2unix and nsis installed.  Those are usually available on Debian systems

Run "nsis.sh"

##### Option B: on Windows

You need to have the following software:

* JDK 14+
* NSIS
* a bash-like environment, like Git-Bash or Cygwin

Set JAVA_HOME to point to your JDK 14 installation and run `sh jpackage.sh`.  Then go inside the `build` directory, and from there right-click on the `installer-jpackage.nsi` file and select "Compile with NSIS".

### Building the Mac bundle

Run "mac.sh"

### Building Linux AppImage

Set the "APPIMAGE_BINARY" to the absolute path of the App Image tool 
(You can download it from https://github.com/AppImage/AppImageKit/releases )

Run "linux.sh"

### Building on armhf/aarch64 (Raspberry Pi)

Same steps as Linux, excpet run `linux-armhf.sh` or `linux-aarch64.sh`
