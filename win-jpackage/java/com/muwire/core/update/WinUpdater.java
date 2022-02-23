package com.muwire.core.update;

import com.muwire.core.Core;
import com.muwire.core.RestartEvent;

import com.muwire.gui.Elevator;

import java.io.File;

public class WinUpdater implements AutoUpdater {

    private File updateFile;

    public void init(Core core) {
        core.getEventBus().register(UpdateDownloadedEvent.class, this);
        core.getEventBus().register(RestartEvent.class, this);
    }

    public void onUpdateDownloadedEvent(UpdateDownloadedEvent e) {
        updateFile = e.getUpdateFile();
    }

    public void onRestartEvent(RestartEvent e) {
        Runnable hook = () -> {
            try {
                Elevator.executeAsAdministrator(updateFile.getAbsolutePath(),"/S");
            } catch (Exception bad) {
                bad.printStackTrace();
            }
        };
        Runtime.getRuntime().addShutdownHook(new Thread(hook));
    }
}
