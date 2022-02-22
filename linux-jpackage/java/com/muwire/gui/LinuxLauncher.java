package com.muwire.gui;

import java.io.*;
import java.nio.file.*;

/**
 * Launches MuWire from a Linux AppImage.  Uses Java 9 APIs.
 * Sets the following properties:
 * i2p.dir.base - to the (read-only) installation of MuWire
 * muwire.pid - the pid of the java process
 * embeddedRouter - to "true"
 */
public class LinuxLauncher {
    private static final String APP_PATH = "jpackage.app-path";

    public static void main(String[] args) throws Exception {
        // 1. Determine paths
        String path = System.getProperty(APP_PATH, "unknown");
        File f = new File(path);
        File bin = f.getParentFile();
        File muwire = bin.getParentFile();
        File lib = new File(muwire, "lib");

        // 2. set Properties
        System.setProperty("embeddedRouter","true");
        System.setProperty("i2p.dir.base", lib.getAbsolutePath());
        System.setProperty("muwire.pid", String.valueOf(ProcessHandle.current().pid()));
        System.setProperty("auto.updater.class", "com.muwire.core.update.LinuxUpdater");

        // 3. Launch MuWire
        Launcher.main(args);
    }
}
