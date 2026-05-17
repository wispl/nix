pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

// This is a very simplified Niri ipc implementation which relies on a bunch
// of assumptions. I use niri with named workspaces 1, 2, 3, 4, 5. These workspaces
// do not move and are fixed in their order. This means I can keep track of windows
// in arrays indexed by their ID. Another method could be to use dictionaries.
// urgentWorkspaces uses an optimization to avoid loops
Singleton {
    readonly property string socket: Quickshell.env("NIRI_SOCKET")
    property var workspaces: [[], [], [], [], []]  // stores windows in each workspace
    property var urgentWorkspaces: [0, 0, 0, 0, 0] // urgent workspaces, 1 means urgent, 0, means not urgent
    property int focusedWorkspaceId: 0             // currently focused workspace

    function handleWorkspaceActivated(event) {
	focusedWorkspaceId = event.id
    }

    function handleWorkspaceUrgencyChanged(event) {
	urgentWorkspaces[event.id] = event.urgent;
    }

    function handleWindowOpenedOrChanged(event) {
	let workspace = workspaces[event.window.workspace_id - 1];
	let window = event.window.id;
	
	if (!workspace.includes(window)) {
	    workspace.push(window);
	    workspacesChanged();
	}
    }

    // This assumes you don't use a script to close windows
    function handleWindowClosed(event) {
	let workspace = workspaces[focusedWorkspaceId - 1];
	workspace = workspace.filter(id => id != event.id);
	workspaces[focusedWorkspaceId - 1] = workspace;
	workspacesChanged();
    }

    // Mainly using this to get initial list of windows after calling "EventStream"
    function handleWindowsChanged(event) {
	let w = [[], [], [], [], []]
	for (const window of event.windows) {
	    const id = window.workspace_id - 1
	    if (id < 5) w[id].push(window.id);
	    if (window.is_focused) focusedWorkspaceId = window.workspace_id;
	}
	workspaces = w;
    }

    Socket {
	connected: true
	path: socket

	parser: SplitParser {
	    onRead: (data) => {
		try {
		    const json = JSON.parse(data);

		    switch (Object.keys(json)[0]) {
		    case "WorkspaceActivated": handleWorkspaceActivated(json.WorkspaceActivated); break;
		    case "WorkspaceUrgencyChanged": handleUrgencyChanged(json.WorkspaceUrgencyChanged); break;
		    case "WindowOpenedOrChanged": handleWindowOpenedOrChanged(json.WindowOpenedOrChanged); break
		    case "WindowClosed": handleWindowClosed(json.WindowClosed); break;
		    case "WindowsChanged": handleWindowsChanged(json.WindowsChanged); break;
		    }
		} catch (e){
		    console.warn("Unable to parse niri event: ", e)
		}
	    }
	}

	Component.onCompleted: {
	    write('"EventStream"\n');
	    flush();
	}
    }
}
