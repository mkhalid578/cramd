import QtQuick
import QtQuick.Controls.Basic as T

T.Button {
    id: control

    contentItem: Text {
        text: control.text
        color: control.hovered ? "#c4b5fd" : "#e5e7eb"
        font.pixelSize: 15
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        Behavior on color {
            ColorAnimation { duration: 130 }
        }
    }

    background: Rectangle {
        radius: 12
        color: control.down ? "#3b2b50"
              : control.hovered ? "#332642" : "#2b2435"
        border.color: control.hovered ? "#8b5cf6" : "#57436d"

        Behavior on color {
            ColorAnimation { duration: 130 }
        }
        Behavior on border.color {
            ColorAnimation { duration: 130 }
        }
    }
}