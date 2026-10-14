import QtQuick
import QtQuick.Controls.iOS as T

T.TextField {
    id: control
    placeholderText: qsTr("Enter description")
    font.pixelSize: 16
    // onActiveFocusChanged: {
    //     if (activeFocus)
    //         Qt.callLater(() => Qt.inputMethod.show())
    // }

    background: Rectangle {
        implicitWidth: 200
        implicitHeight: 52
        radius: 4

        color: "transparent"
        border.width: control.activeFocus ? 2 : 1
        border.color: control.activeFocus ? "#5b21b6" : "purple"
    }
}