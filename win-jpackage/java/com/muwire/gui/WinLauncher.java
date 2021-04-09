package com.muwire.gui;

import java.io.*;
import java.nio.file.*;

/**
 * Launches MuWire from a Windows installation.  Uses Java 9 APIs.
 * Sets the following properties:
 * i2p.dir.base - to the (read-only) installation of MuWire
 * muwire.pid - the pid of the java process
 * embeddedRouter - to "true"
 * updateType - to "exe"
 */
public class WinLauncher {
	private static final String APP_PATH = "jpackage.app-path";
	
	public static void main(String[] args) throws Exception {
		// 1. Determine paths
		String path = System.getProperty(APP_PATH, "unknown");
		File f = new File(path);
		
		// 2. set Properties
		System.setProperty("embeddedRouter","true");
		System.setProperty("updateType","exe");
		System.setProperty("i2p.dir.base", f.getParentFile().getAbsolutePath());
		System.setProperty("muwire.pid", String.valueOf(ProcessHandle.current().pid()));
		
		// 3. Launch MuWire
		Launcher.main(args);
	}
}