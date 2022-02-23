package com.muwire.core.update;

import com.muwire.core.Core;
import com.muwire.core.RestartEvent;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;

import java.nio.file.Files;
import java.nio.file.StandardCopyOption;

public class MacUpdater implements AutoUpdater {
    
    private File updateFile;
    private File home;

    public void init(Core core) {
        core.getEventBus().register(UpdateDownloadedEvent.class, this);
        core.getEventBus().register(RestartEvent.class, this);
        home = core.home;
    }

    public void onUpdateDownloadedEvent(UpdateDownloadedEvent e) {
        updateFile = e.getUpdateFile();
    }

    public void onRestartEvent(RestartEvent e) {
        Runnable hook = () -> {
            var workingDir = new File(home, "mac_updates");
            workingDir.mkdirs();

            var target = new File(workingDir, updateFile.getName());
            try {
                Files.copy(updateFile.toPath(), target.toPath(), StandardCopyOption.REPLACE_EXISTING);

                try(InputStream scriptStream = MacUpdater.class.getClassLoader().getResourceAsStream("mac-update.sh")) {
                    var scriptFile = new File(workingDir, "mac-update.sh");
                    Files.copy(scriptStream, scriptFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                    if (!scriptFile.setExecutable(true))
                        throw new IOException("couldn't mark script file executable");
                }

                var pb = new ProcessBuilder("./mac-update.sh");
                var env = pb.environment();
                env.put("MW_PID", System.getProperty("muwire.pid"));
                env.put("MW_UPDATE_FILE", target.getAbsolutePath());
                env.put("MW_BUNDLE_LOCATION", System.getProperty("mac.bundle.location"));

                pb.directory(workingDir).
                    redirectErrorStream(true).
                    redirectOutput(new File(workingDir,"update.log")).
                    start();
            } catch (IOException bad) {
                bad.printStackTrace();
            }
        };
        Runtime.getRuntime().addShutdownHook(new Thread(hook));
    }
}
