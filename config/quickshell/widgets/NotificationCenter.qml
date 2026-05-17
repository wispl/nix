import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "../config"
import "../components"
import "../data"

PopupWindow {
    id: popup
    required property var parentId
    anchor.window: parentId

    anchor.rect.x: parentWindow.width - implicitWidth - 16
    anchor.rect.y: 16

    implicitWidth: 500
    implicitHeight: parentWindow.height - 32 - 150
    color: "transparent"
    /* color: Colors.bg */
    visible: true

    WrapperRectangle {
	id: wrapper
	anchors.fill: parent
	/* color: "transparent" */
	color: Colors.bg
	radius: 8
	ColumnLayout {
	    spacing: 12
	    anchors.fill: parent
	    WrapperRectangle {
		width: popup.implicitWidth
		radius: wrapper.radius
		bottomLeftRadius: 0
		bottomRightRadius: 0

		topMargin: 8
		bottomMargin: 8

		Layout.alignment: Qt.AlignTop
		implicitWidth: parent.implicitWidth
		color: Colors.bgD

		NormalText {
		    color: Colors.magenta
		    text: " Working hard or hardly working?"
		}
	    }
	    WrapperRectangle {
		anchors.left: parent.left
		anchors.right: parent.right
		radius: wrapper.radius
		anchors.leftMargin: 16
		anchors.rightMargin: 16
		topMargin: 16
		bottomMargin: 16
		leftMargin: 16
		rightMargin: 16
		color: Colors.bgDD

		WrapperRectangle {
		    topMargin: 8
		    bottomMargin: 8
		    leftMargin: 16
		    rightMargin: 16

		    radius: wrapper.radius
		    color: Colors.bgD
		    RowLayout {
			spacing: 6
			Repeater {
			    model: ["All", "Some", "None"]
			    Button {
				required property string modelData
				leftPadding: 14
				rightPadding: 14
				background: Rectangle {
				    color: parent.hovered ? Colors.bgLLL : Colors.bgD
				    radius: 4
				}
				contentItem: NormalText {
				    text: modelData
				}
			    }
			}
		    }
		}
	    }
	}
	
    }
}
