import QtQuick
import QtQuick.Controls
import Quickshell.Widgets

import "../config"

Button {
    required property string iconString
    required property string backgroundColor
    required property int fontSize

    leftPadding: 14
    rightPadding: 14
    background: Rectangle {
	color: parent.hovered ? Colors.bgLLL : backgroundColor
	radius: 4
    }
    contentItem: Text {
	color: Colors.fg
	font.pointSize: fontSize
	text: iconString
    }
}
