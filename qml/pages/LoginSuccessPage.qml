import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

Item {
    id: root

    property string userName: ""
    signal signOutRequested()

    Rectangle {
        anchors.fill: parent
        color: "#1f1f1f"

        Rectangle {
            anchors.centerIn: parent
            width: Math.min(parent.width - 32, 420)
            height: content.implicitHeight + 56
            radius: 12
            color: "#262626"
            border.color: "#3b3b3b"

            ColumnLayout {
                id: content
                anchors.fill: parent
                anchors.margins: 28
                spacing: 16

                Label {
                    text: qsTr("Signed in")
                    color: "#8ee6a1"
                    font.pixelSize: 14
                    font.bold: true
                    Layout.fillWidth: true
                }

                Label {
                    text: root.userName.length > 0
                          ? qsTr("Welcome, %1").arg(root.userName)
                          : qsTr("Welcome")
                    color: "#f4f4f4"
                    font.pixelSize: 26
                    font.bold: true
                    wrapMode: Text.Wrap
                    Layout.fillWidth: true
                }

                Label {
                    text: qsTr("You have successfully signed in.")
                    color: "#bdbdbd"
                    wrapMode: Text.Wrap
                    Layout.fillWidth: true
                }

                Button {
                    text: qsTr("Sign out")
                    Layout.fillWidth: true
                    onClicked: root.signOutRequested()
                }
            }
        }
    }
}
