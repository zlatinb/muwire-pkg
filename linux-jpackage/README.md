# Building a Linux AppImage with JPackage

### Requirements
* JDK 14 or newer
* AppImage tool
* A GPG key if you want to sign.

### Building
1. Set `JAVA_HOME` to the installation of the JDK
2. Set `APPIMAGE_BINARY` to the absolute path of the AppImage
3. If you want to sign the app image, set the `APPIMAGE_OPTS` variable with the appropriate options.
4. Run `build.sh`
