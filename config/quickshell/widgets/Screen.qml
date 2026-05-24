import Quickshell
import Quickshell.Wayland
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
    NotificationCenter { parentId: root }
}
