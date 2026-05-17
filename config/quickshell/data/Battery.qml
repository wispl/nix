pragma Singleton

import Quickshell
import Quickshell.Services.UPower
import QtQuick

Singleton {
    readonly property int percentage:  Math.round(UPower.displayDevice.percentage * 100)
    readonly property var state: UPower.displayDevice.state 
    readonly property string icon: {
	if (state === UPowerDeviceState.Charging) {
	    return "󰂄";
	}

	if (percentage >= 80) return "󰁹";
	if (percentage >= 60) return "󰂁";
	if (percentage >= 40) return "󰁿";
	if (percentage >= 20) return "󰁽";
	return "󰁻";
    }
}
