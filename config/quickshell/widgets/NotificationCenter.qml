import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "../config"
import "../components"
import "../data"

PopupWindow {
    id: notificationCenter
    required property var parentId
    anchor.window: parentId

    anchor.rect.x: parentWindow.width - implicitWidth - 16
    anchor.rect.y: 16

    implicitWidth: 480
    implicitHeight: 900
    color: "transparent"
    visible: false

    IpcHandler {
	target: "notificationCenter"
	function toggle(): void { notificationCenter.visible = !notificationCenter.visible; }
    }

    Column {
	spacing: 0
	anchors.fill: parent

	WrapperRectangle {
	    width: notificationCenter.implicitWidth
	    topLeftRadius: 8
	    topRightRadius: 8

	    topMargin: 8
	    bottomMargin: 8

	    Layout.alignment: Qt.AlignTop
	    implicitWidth: parent.implicitWidth
	    color: Qt.darker(Colors.magenta, 4.2);

	    NormalText {
		color: Colors.magenta
		text: " Working hard or hardly working?"
	    }
	}

	DashboardBox {
	    implicitHeight: 150
	    WrapperRectangle {
		implicitHeight: 150
		anchors {
		    left: parent.left
		    right: parent.right
		    top: parent.top
		    bottom: parent.bottom
		    leftMargin: 12
		    rightMargin: 12
		    topMargin: 12
		    bottomMargin: 12
		}
		color: Colors.bg
		radius: 8
		RowLayout {
		    spacing: 8
		    ClippingWrapperRectangle {
			Layout.leftMargin: 20
			implicitWidth: 80
			implicitHeight: 80
			radius: 100
			border.width: 2
			border.color: Colors.magenta
			Image {
			    asynchronous: true
			    fillMode: Image.PreserveAspectCrop
			    source: "/home/wisp/.local/state/profile.png"
			    sourceSize.width: 80
			    sourceSize.height: 80
			}
		    }

		    ColumnLayout {
			spacing: 16
			NormalText {
			    font.pointSize: Fonts.size.large
			    text: "Hello, wisp" 
			}
			NormalText {
			    text: "\"Getting hit by a brick hurts\""
			}
		    }
		}
	    }
	}

	DashboardBox {
	    bottomLeftRadius: 8
	    bottomRightRadius: 8
	    implicitHeight: 700
	    WrapperRectangle {
		color: Colors.bg
		radius: 8
		anchors {
		    fill: parent
		    leftMargin: 12
		    rightMargin: 12
		    bottomMargin: 16
		}
		ColumnLayout {
		    id: column
		    spacing: 0
		    anchors {
			fill: parent
			leftMargin: 12
			rightMargin: 12
			topMargin: 12
		    }

		    RowLayout {
			Layout.alignment: Qt.AlignTop
			Layout.bottomMargin: 12
			Layout.preferredWidth: parent.width

			NormalText {
			    font.pointSize: Fonts.size.large
			    text: "Notifications"
			}
			IconButton {
			    Layout.alignment: Qt.AlignRight
			    iconString: "  clear"
			    fontColor: Colors.bg
			    backgroundColor: Colors.red
			    fontSize: Fonts.size.smallIcons
			    onClicked: { Notifications.clearSaved() }
			}
		    }

		    Rectangle {
			Layout.preferredWidth: parent.width
			Layout.preferredHeight: parent.height - 64
			color: "transparent"
			ListView {
			    model: Notifications.saved

			    spacing: 12
			    clip: true
			    anchors.fill: parent

			    delegate: NotificationPopup {
				required property var modelData
				width: column.width

				isSaved: true
				notif: modelData
				alignment: Qt.AlignRight
				minWidth: 1 // these don't matter for list view 
				maxWidth: 1 // these don't matter for list view 
				borderColor: Colors.bgL
			    }
			}
		    }
		}
	    }
	}
    }
}
