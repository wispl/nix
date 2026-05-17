pragma Singleton

import Quickshell
import Quickshell.Bluetooth
import QtQuick

Singleton {
    readonly property bool enabled: Bluetooth?.defaultAdapter?.enabled ?? false
    readonly property bool connected: {
	for (let i = 0; i < Bluetooth.devices.count; i++) {
	    if (Bluetooth.devices.get(i).connected) return true;
	}
	return false;
    }
}

