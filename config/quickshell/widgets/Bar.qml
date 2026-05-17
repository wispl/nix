import Quickshell
import Quickshell.Widgets
import Quickshell.Services.UPower
import Quickshell.Io

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "../data"
import "../config"
import "../components"

// The top bar, self-explanatory
PanelWindow {
    implicitHeight: 44
    color: Colors.bg
    exclusiveZone: 44 - 8
    anchors {
	top: true
	left: true
	right: true
    }

    // Left: dashboard button, window count, workspace, power profiles
    RowLayout {
	anchors.fill: parent
	spacing: 0
	RowLayout {
	    Layout.leftMargin: 8
	    spacing: 8
	    Layout.alignment: Qt.AlignLeft

	    // Dashboard button
	    IconButton {
		fontSize: Fonts.size.icons
		iconString: "󰕮"
		backgroundColor: Colors.bgL
	    }

	    // Window count
	    BarItem {
		RowLayout {
		    NormalText {
			color: Colors.magenta
			text: Niri?.workspaces[Niri.focusedWorkspaceId - 1]?.length ?? 0
		    }
		    NormalText {
			color: Colors.magenta
			text: ""
		    }
		}
	    }

	    // Workspaces
	    BarItem {
		implicitHeight: 31
		RowLayout {
		    spacing: 6
		    Repeater {
			model: [1, 2, 3, 4, 5]
			Item {
			    required property int modelData
			    Layout.preferredWidth: modelData == Niri.focusedWorkspaceId ? 28 : 20
			    WrapperRectangle {
				anchors.centerIn: parent
				height: 8
				radius: 2

				width: modelData == Niri.focusedWorkspaceId ? 28 :
				    Niri.workspaces[modelData - 1].length > 0 ? 20 : 8

				color: {
				    if (Niri.focusedWorkspaceId === modelData) return Colors.yellow;
				    if (Niri.urgentWorkspaces[modelData - 1]) return Colors.red;
				    if (Niri.workspaces[modelData - 1].length != 0) return Colors.magenta;
				    return Colors.bgLLL;
				}

				Process {
				    id: switchWorkspace
				    command: ["niri", "msg", "action", "focus-workspace", modelData]
				}

				MouseArea {
				    anchors.fill: parent
				    cursorShape: Qt.PointingHandCursor 
				    hoverEnabled: true 
				    onClicked: switchWorkspace.running = true
				}

				Behavior on width {
				    NumberAnimation { duration: 100; easing.type: Easing.OutCubic }
				}
			    }
			}
		    }
		}
	    }

	    // Power Profiles
	    Item {
		implicitHeight: 31
		BarItem {
		    border.width: 3
		    border.color: PowerProfiles.profile == PowerProfile.Performance ? Qt.darker(Colors.magenta, 3.0) : Colors.bgL

		    implicitWidth: content.implicitWidth
		    implicitHeight: parent.implicitHeight - 6
		    ShaderEffect {
			anchors.fill: parent
			blending: false
			property real stripe_width: 18
			property real angle: -15
			property color color1: Colors.bgL
			property color color2: PowerProfiles.profile == PowerProfile.Performance ? Qt.darker(Colors.magenta, 3.0) :
					       PowerProfiles.profile == PowerProfile.Balanced ? Qt.darker(Colors.magenta, 5.0) : Colors.bgL

			fragmentShader: "../shaders/stripes.frag.qsb"
		    }
		}
		BarItem {
		    id: content
		    color: "transparent"
		    RowLayout {
			required property int modelData
			spacing: 10
			Repeater {
			    model: [PowerProfile.PowerSaver, PowerProfile.Balanced, PowerProfile.Performance]
			    NormalText {
				font.pointSize: Fonts.size.icons
				color: modelData == PowerProfiles.profile ? Colors.fg : Colors.bgLLL
				text: {
				    switch (modelData) {
				    case PowerProfile.PowerSaver: return "";
				    case PowerProfile.Balanced: return "";
				    case PowerProfile.Performance: return "";
				    }
				}
				MouseArea {
				    anchors.fill: parent
				    cursorShape: Qt.PointingHandCursor 
				    hoverEnabled: true 
				    onClicked: PowerProfiles.profile = modelData
				}
			    }
			}
		    }
		}
	    }
	}

	// Right: volume, battery, bluetooth, battery, clock, notification button, profile
	RowLayout {
	    Layout.alignment: Qt.AlignRight
	    Layout.rightMargin: 8
	    spacing: 8

	    Item {
		implicitWidth: 100
		implicitHeight: 31
		BarItem {
		    anchors.fill: parent
		    color: Audio.muted ? Colors.bgLLL : Colors.bgL
		}
		BarItem {
		    anchors.verticalCenter: parent.verticalCenter
		    anchors.left: parent.left
		    anchors.leftMargin: 4
		    color: Audio.volume > 1 ? Colors.red : Qt.darker(Colors.magenta, 2.5)
		    height: parent.implicitHeight - 8
		    width: (parent.implicitWidth - 8) * Math.min(Audio.volume, 1)
		}
		BarItem {
		    anchors.fill: parent
		    color: "transparent"
		    NormalText {
			horizontalAlignment: Text.AlignHCenter
			text: Audio.muted ? "MUTED" : qsTr("Vol %1%").arg(Math.min((Audio.volume * 100).toFixed(0), 100))
		    }
		}
	    }

	    BarItem {
		RowLayout {
		    anchors.fill: parent
		    spacing: 1
		    // Bluetooth
		    NormalText {
			text: Bluetooth.connected ? "󰂯" : "󰂲"
			Layout.leftMargin: 10
		    }
		    // Wifi / Network
		    NormalText {
			text: "󰤨"
		    }
		    // Separator
		    NormalText {
			color: Colors.magenta
			text: "//"
			Layout.rightMargin: 1
			Layout.leftMargin: -4
		    }

		    // Battery
		    NormalText {
			text: qsTr("%1").arg(Battery.icon)
		    }
		    NormalText {
			text: qsTr("%1%").arg(Battery.percentage)
			Layout.rightMargin: 2
		    }
		}
	    }

	    // Time
	    BarItem {
		id: time
		property bool showDate: false

		WrapperMouseArea {
		    RowLayout {
			NormalText {
			    color: Colors.yellow
			    text: Time.date
			    visible: time.showDate
			}
			NormalText {
			    color: Colors.magenta
			    text: "//"
			    visible: time.showDate
			}
			NormalText {
			    text: Time.time
			}
		    }

		    hoverEnabled: true 
		    onEntered: time.showDate = true
		    onExited: time.showDate = false
		}

	    }

	    // Notification Button
	    IconButton {
		iconString: "󰗣"
		fontSize: Fonts.size.icons
		backgroundColor: Colors.bg
	    }
	}
    }
}
