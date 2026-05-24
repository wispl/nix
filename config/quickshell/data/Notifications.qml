pragma Singleton

import Quickshell
import Quickshell.Services.Notifications
import QtQuick

Singleton {
    id: root
    readonly property var list: server.trackedNotifications
    property var timers: []
    property var saved: []

    NotificationServer {
	id: server
	imageSupported: true
	actionsSupported: true
	bodySupported: true
	bodyImagesSupported: true
	bodyHyperlinksSupported: true
	bodyMarkupSupported: true

	onNotification: notif => {
	    if (notif === null) return;
	    notif.tracked = true;
	    root.timers.push(timerComp.createObject(root, {
		notification: notif
	    }));
	}
    }

    component NotificationTimer: QtObject {
	id: timer
	required property Notification notification
        readonly property var timer: Timer {
            running: true
            interval: timer.notification.expireTimeout > 0 ? timer.notification.expireTimeout : 5000
            onTriggered: {
		timer.notification.expire();
		saved = [timer.notification, ...saved];
            }
        }
	readonly property var connection: Connections {
	    target: timer.notification.Retainable
            function onDropped(): void {
		root.timers = root.timers.filter(i => i != timer);
            }

            function onAboutToDestroy(): void {
                timer.destroy();
            }
        }
    }

    Component {
	id: timerComp
	NotificationTimer {}
    }

    function dismiss(notif) {
	let data = {
	    summary: notif.summary,
	    body: notif.body,
	    image: notif.image,
	    appIcon: notif.appIcon
	};
	saved = [data, ...saved];
	notif.dismiss();
    }

    function clearSaved() {
	saved = [];
    }
}
