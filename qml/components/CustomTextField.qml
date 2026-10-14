import QtQuick
import QtQuick.Controls.Basic as T

T.TextField {
    id: control
    placeholderText: qsTr("Enter description")

    background: Rectangle {
        implicitWidth: 200
        implicitHeight: 40
        radius: 8
        color: "black"
        border.width: control.activeFocus ? 2 : 1
        border.color: control.activeFocus ? "#5b21b6" : "grey"
    }
}