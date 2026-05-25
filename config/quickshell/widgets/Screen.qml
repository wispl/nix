import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick

// An invisible widget which covers the entire screen. Used for popups like
// notifications, notification center, and dashboards.
PanelWindow {
    id: root
    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    anchors.right: true

    WlrLayershell.layer: WlrLayer.Overlay
    color: "transparent"
    mask: Region { } // Pass all inputs through

    NotificationList { parentId: root }

    LazyLoader {
        id: notificationCenter
        NotificationCenter { parentId: root }
    }

    IpcHandler {
	target: "notificationCenter"
	function toggle(): void { notificationCenter.active = !notificationCenter.active; }
    }
}
