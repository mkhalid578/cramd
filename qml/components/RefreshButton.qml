import QtQuick
import QtQuick.Controls.Basic as T
import QtQuick.Layouts

T.Button {

    id: control

    property bool busy

    contentItem: RowLayout {
        spacing: 8

        Text {
            text: "↻"
            color: "white"
            font.pixelSize: 20
            Layout.alignment: Qt.AlignVCenter

            RotationAnimation on rotation {
                from: 0
                to: 360
                duration: 900
                loops: Animation.Infinite
                running: control.busy
            }
        }

        T.Label {
            text: control.text
            color: "white"
            font.bold: true
            Layout.alignment: Qt.AlignVCenter
        }
    }

    background: Rectangle {
        radius: 12
        color: control.down ? "#5b21b6"
                      : control.hovered ? "#7c3aed" : "#6d28d9"
        opacity: control.enabled ? 1 : 0.65

        Behavior on color {
            ColorAnimation { duration: 130 }
        }
    }
}
