import Quickshell
import Quickshell.Wayland
import QtQuick

import "../config"

// Renders the Wallpaper along with a frame.
PanelWindow {
    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    anchors.right: true
    margins.top: 44 - 8

    WlrLayershell.layer: WlrLayer.Background
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.namespace: "quickshell-wallpaper"

    ShaderEffectSource {
        id: shader
        sourceItem: rect
    }

    Image {
	id: rect
	anchors.fill: parent
	source: Quickshell.env("WALLPAPER")
	asynchronous: true
	cache: false
	sourceSize.width: parent.width
	sourceSize.height: parent.height
    }

    ShaderEffect {
	anchors.fill: parent
	blending: false
	property variant source: shader
	property real radius: 8
	property real padding: 16
	property color frame_color: Colors.bg

	fragmentShader: "../shaders/roundrect.frag.qsb"
    }
}
