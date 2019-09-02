import QtQuick 2.10

Item {
    Shortcut {
        sequence: "Left"
        onActivated: videoObject.seekBy(-5)
    }
    Shortcut {
        sequence: "Right"
        onActivated: videoObject.seekBy(5)
    }
    Shortcut {
        sequence: "Space"
        onActivated: videoObject.pause(!videoObject.isPaused)
    }
    Shortcut {
        sequence: "Up"
        onActivated: videoObject.currentVolume += 10
    }
    Shortcut {
        sequence: "Down"
        onActivated: videoObject.currentVolume -= 10
    }
    Shortcut {
        sequence: "m"
        onActivated: videoObject.muted = !videoObject.muted
    }
}
