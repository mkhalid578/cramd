import QtQuick.Controls.Basic as T
import QtQuick
import QtQuick.Layouts

T.Button
{
    id: control
    width: 48
    height: 48
    contentItem: Text {
        text: control.text
        color: "#0e7490"
        font.pixelSize: 26
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    background: Rectangle {
        radius: width / 2
        color: parent.down ? "#a5f3fc" : "#cffafe"
        border.color: "#67e8f9"
        opacity: parent.enabled ? 1 : 0.45
        scale: parent.down ? 0.92 : 1

        Behavior on scale {
            NumberAnimation { duration: 100 }
        }
    }
}
