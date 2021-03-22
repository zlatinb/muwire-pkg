package com.muwire.gui;


import java.io.*;
import java.nio.file.*;

public class MacLauncher {
    public static void main(String[]args) throws Exception {

        // 1. Select home directory
        File home = new File(System.getProperty("user.home"));
        File library = new File(home, "Library");
        File appSupport = new File(library, "Application Support");
        home = new File(appSupport, "MuWire");
        if (!home.exists())
            home.mkdirs();
        else if (!home.isDirectory()) {
            System.err.println(home + " exists but is not a directory.  Please get it out of the way");
            System.exit(1);
        }

        // 2. Deploy resources
        var resourcesList = MacLauncher.class.getClassLoader().getResourceAsStream("resources.csv");
        var reader = new BufferedReader(new InputStreamReader(resourcesList));

        String line;
        while((line = reader.readLine()) != null) {
            deployResource(home, line);
        }

        // 3. Set some system props
        System.setProperty("embeddedRouter","true");
        System.setProperty("updateType","mac");

        // 4. Launch MuWire
        Launcher.main(args);
    }

    private static void deployResource(File home, String description) throws Exception {
        String []split = description.split(",");
        String url = split[0];
        String target = split[1];
        boolean overwrite = Boolean.parseBoolean(split[2]);

        var resource = MacLauncher.class.getClassLoader().getResourceAsStream(url);

        File targetFile = home;
        for (String element : target.split("/")) {
            targetFile = new File(targetFile, element);
        }

        File targetDir = targetFile.getParentFile();
        if (!targetDir.exists())
            targetDir.mkdirs();
        else if (!targetDir.isDirectory())
            throw new Exception(targetDir + " exists but not a directory.  Please get it out of the way");

        if (!targetFile.exists() || overwrite)
            Files.copy(resource, targetFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
    }
}


