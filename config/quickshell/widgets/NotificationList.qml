import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

import "../data"
import "../config"
import "../components"

PopupWindow {
    id: root
    required property var parentId
    property color borderColor: Qt.darker(Colors.magenta, 3.0);

    anchor {
	window: parentId
	rect.w: parentWindow.width - 16
	rect.y: 16
	edges: Edges.Right | Edges.Top
	gravity: Edges.Left | Edges.Bottom
    }

    implicitHeight: 800
    implicitWidth: 400
    visible: true
    color: "transparent"

    mask: Region { item: notifs }

    ColumnLayout {
	id: notifs
	spacing: 12
	anchors.right: parent.right
	Repeater {
	    model: Notifications.list
	    delegate: NotificationPopup {
		required property var modelData

		notif: modelData
		alignment: Qt.AlignRight
		minWidth: 300
		maxWidth: root.implicitWidth
		borderColor: root.borderColor
	    }
	}
    }
}
