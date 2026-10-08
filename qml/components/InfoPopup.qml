import QtQuick
import QtQuick.Controls

Popup {
    id: popup

    parent: Overlay.overlay
    anchors.centerIn: Overlay.overlay
    width: Overlay.overlay ? Overlay.overlay.width - 32 : 0
    height: Overlay.overlay ? Overlay.overlay.height - 128 : 0
    padding: 16
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    background: Rectangle {
        radius: 16
        color: "white"
        border.color: "#dddddd"
    }

    enter: Transition {
        ParallelAnimation {
            NumberAnimation {
                target: popup.background
                property: "opacity"
                from: 0
                to: 1
                duration: 180
                easing.type: Easing.OutCubic
            }
            NumberAnimation {
                target: popup.background
                property: "scale"
                from: 0.96
                to: 1
                duration: 180
                easing.type: Easing.OutCubic
            }
        }
    }

    exit: Transition {
        ParallelAnimation {
            NumberAnimation {
                target: popup.background
                property: "opacity"
                to: 0
                duration: 140
                easing.type: Easing.InCubic
            }
            NumberAnimation {
                target: popup.background
                property: "scale"
                to: 0.96
                duration: 140
                easing.type: Easing.InCubic
            }
        }
    }
}
