pragma Singleton

import Quickshell
import QtQuick

Singleton {
    readonly property QtObject family: QtObject {
	readonly property string mono: "FantasqueSansM Nerd Font Propo"
    }

    readonly property QtObject size: QtObject {
	readonly property int large: 18
	readonly property int normal: 15
	readonly property int icons: 14
	readonly property int smallIcons: 12
    }
}
