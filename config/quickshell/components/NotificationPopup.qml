import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

import "../config"
import "../data"

WrapperMouseArea {
    id: popup
    required property var notif
    required property var alignment
    required property int minWidth
    required property int maxWidth
    required property color borderColor
    property bool isSaved: false

    Layout.alignment: alignment
    Layout.minimumWidth: minWidth
    Layout.maximumWidth: maxWidth

    cursorShape: Qt.PointingHandCursor 
    hoverEnabled: true 
    onClicked: { if (!isSaved) Notifications.dismiss(notif); }

    ColumnLayout {
	spacing: 0
	WrapperRectangle {
	    Layout.fillWidth: true
	    topLeftRadius: 8
	    topRightRadius: 8

	    topMargin: 8
	    bottomMargin: 8
	    leftMargin: 12
	    rightMargin: 8

	    color: borderColor
	    NormalText {
		text: notif?.summary ?? "No summary"
	    }
	}

	WrapperRectangle {
	    Layout.alignment: Qt.AlignCenter
	    Layout.fillWidth: true
	    border.width: 4
	    border.color: borderColor

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
			visible: notif.image !== "" || notif.appIcon !== ""
			anchors.fill: parent
			fillMode: Image.PreserveAspectCrop
			sourceSize.width: 75
			sourceSize.height: 75
			source: (notif?.image || notif?.appIcon) ?? ""
		    }

		    ShaderEffect {
			visible: notif.image == "" && notif.appIcon == ""
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
		    text: notif?.body ?? "No body"
		}
	    }
	}
    }
}
