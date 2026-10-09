import QtQuick.Controls.Basic
import QtQuick

TabButton {
    id: root
    text: qsTr("Favorites")

    property string buttonIcon:  "♡"


    contentItem: Column {
        spacing: 2
        anchors.centerIn: parent

        Label {
            text: root.buttonIcon
            color: root.checked ? "#fda4af" : "#bdbdbd"
            font.pixelSize: 22
            horizontalAlignment: Text.AlignHCenter
            width: root.width
        }
        Label {
            text: root.text
            color: root.checked ? "#f4f4f4" : "#bdbdbd"
            font.pixelSize: 11
            font.bold: root.checked
            horizontalAlignment: Text.AlignHCenter
            width: root.width
        }
    }

    background: Rectangle {
        radius: 14
        color: root.checked ? "#3b2d59" : "transparent"
        border.color: root.checked ? "#8b5cf6" : "transparent"

        Behavior on color {
            ColorAnimation { duration: 150 }
        }
    }
}