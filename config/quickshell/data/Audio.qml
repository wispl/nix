pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire
import QtQuick

Singleton {
    property PwNode sink: Pipewire.defaultAudioSink

    property bool muted: sink?.audio?.muted ?? false
    property real volume: sink?.audio?.volume ?? 2

    readonly property var icons: ["󰕿", "󰖀", "󰕾"]
    readonly property string mutedIcon: "󰖁"
    readonly property string icon: muted ? mutedIcon : icons[Math.floor((volume * 10) / 3)]

    PwObjectTracker {
	objects: [sink]
    }

    function setVolume(volume: real): void {
        if (sink?.ready && sink?.audio) {
            sink.audio.muted = false;
            sink.audio.volume = volume;
        }
    }

    function toggleMute(): void {
        if (sink?.ready && sink?.audio) {
            sink.audio.muted = !sink.audio.muted ;
        }
    }
}
