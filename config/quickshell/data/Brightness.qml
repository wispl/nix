pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    property string devpath: ""
    property real value: 0
    property real maxValue: 0

    readonly property var icons: ["󰃝", "󰃞", "󰃟", "󰃠"]
    readonly property var icon: icons[Math.floor((value * 100) / 25)]

    Process {
	running: true
	command: ["sh", "-c", "echo /sys/class/backlight/?*/brightness"]
	
	stdout: StdioCollector {
	    onStreamFinished: devpath = text.trim()
	}
    }

    FileView {
	id: file1
	path: devpath !== "" ? devpath.substring(0, devpath.lastIndexOf('/')) + "/max_brightness" : ""
	onLoaded: {
	    maxValue = text();
	    file2.preload = true;
	}
    }


    FileView {
	id: file2
	path: devpath
	preload: false
	watchChanges: true

	onLoaded: value = text() / maxValue;
	onFileChanged: {
	    reload();
	    value = text() / maxValue;
	}
    }
}
