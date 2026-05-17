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

	    delegate: WrapperMouseArea {
		Layout.alignment: Qt.AlignRight
		Layout.minimumWidth: 300
		Layout.maximumWidth: root.implicitWidth

		cursorShape: Qt.PointingHandCursor 
		hoverEnabled: true 
		onClicked: { Notifications.dismiss(modelData) }

		ColumnLayout {
		    spacing: 0
		    WrapperRectangle {
			Layout.fillWidth: true
			radius: 8
			bottomLeftRadius: 0
			bottomRightRadius: 0

			topMargin: 8
			bottomMargin: 8
			leftMargin: 12
			rightMargin: 8

			color: borderColor
			NormalText {
			    text: modelData?.summary ?? "No summary"
			}
		    }

		    WrapperRectangle {
			Layout.alignment: Qt.AlignCenter
			border.width: 4
			border.color: root.borderColor
			Layout.fillWidth: true

			color: Colors.bg
			leftMargin: 12
			bottomMargin: 16
			rightMargin: 8

			bottomLeftRadius: 8
			bottomRightRadius: 8
			RowLayout {
			    spacing: 12
			    Rectangle {
				Layout.topMargin: 8
				Layout.preferredHeight: 75
				Layout.preferredWidth: 75
				color: "transparent"
				Image {
				    visible: modelData.image !== "" || modelData.appIcon !== ""
				    anchors.fill: parent
				    fillMode: Image.PreserveAspectCrop
				    sourceSize.width: 75
				    sourceSize.height: 75
				    source: modelData.image !== ""
					? modelData.image
					: (modelData.appIcon !== "" ? modelData.appIcon : "")
				}

				ShaderEffect {
				    visible: modelData.image == "" && modelData.appIcon == ""
				    anchors.fill: parent
				    blending: false
				    property real stripe_width: 13
				    property real angle: 45
				    property color color1: Colors.bg
				    property color color2: Colors.magenta

				    fragmentShader: "../shaders/stripes.frag.qsb"
				}
			    }

			    NormalText {
				Layout.topMargin: 8
				Layout.fillWidth: true
				Layout.alignment: Qt.AlignTop
				wrapMode: Text.WordWrap
				text: modelData?.body ?? "No body"
			    }
			}
		    }
		}
	    }
	}
    }
}
