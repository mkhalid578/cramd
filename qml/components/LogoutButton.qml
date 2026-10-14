import QtQuick
import QtQuick.Controls.Basic as T
import QtQuick.Layouts

T.Button {
    id: control

    text: qsTr("Log Out")
    Layout.fillWidth: true

    contentItem: RowLayout {
        spacing: 10
        anchors.centerIn: parent

        Text {
            text: "⇥"
            color: "#fca5a5"
            font.pixelSize: 20
            Layout.alignment: Qt.AlignVCenter
        }

        T.Label {
            text: control.text
            color: "#fecaca"
            font.bold: true
            Layout.alignment: Qt.AlignVCenter
        }
    }

    background: Rectangle {
        radius: 12
        color: control.down ? "#7f1d1d"
                     : control.hovered ? "#3f1d25" : "#2b1c22"
        border.color: "#7f343d"
        border.width: 1

        Behavior on color {
            ColorAnimation { duration: 130 }
        }
    }
}