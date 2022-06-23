package com.muwire.gui;


import java.io.*;
import java.nio.file.*;


/**
 * Launches MuWire from a Mac App bundle.  Uses Java 9 apis.
 * Sts the following properties:
 * i2p.dir.base - this points to the (read-only) resources inside the bundle
 * mac.bundle.location - this points to the folder containing the bundle itself
 * muwire.pid - the pid of the Java process
 * embeededRouter - to "true"
 * updateType - to "mac"
 */
public class MacLauncher {

    private static final String APP_PATH = "jpackage.app-path";

    public static void main(String[]args) throws Exception {

        // 1. Determine paths
        String path = System.getProperty(APP_PATH,"unknown");
        File f = new File(path);
        File contents = f.getParentFile().getParentFile();
        File resources = new File(contents, "Resources");
        File bundleLocation = contents.getParentFile().getParentFile();

        // 2. Set system props
        System.setProperty("embeddedRouter","true");
        System.setProperty("i2p.dir.base", resources.getAbsolutePath());
        System.setProperty("mac.bundle.location", bundleLocation.getAbsolutePath());
        System.setProperty("muwire.pid", String.valueOf(ProcessHandle.current().pid()));
        System.setProperty("auto.updater.class","com.muwire.core.update.MacUpdater");

        // 3. Disable app nap
        try {
            System.load(resources.getAbsolutePath() + "/libMacLauncher.jnilib");
            disableAppNap();
        } catch (Throwable bad) {
            // this is pretty bad - MuWire is very slow if AppNap kicks in.
            // TODO: hook up to a console warning or similar.
            bad.printStackTrace();
        }

        // 4. Launch MuWire
        Launcher.main(args);
    }

    private static native void disableAppNap();
}


