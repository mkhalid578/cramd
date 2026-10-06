import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

Item {
    id: root

    implicitWidth: 380
    implicitHeight: 380

    property alias userName: userNameField.text
    property alias password: passwordField.text
    property string errorMessage: ""

    signal loginRequested(string userName, string password)

    Rectangle {
        anchors.fill: parent
        radius: 12
        color: "#262626"
        border.color: "#3b3b3b"

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 28
            spacing: 16

            Label {
                text: qsTr("Welcome back")
                color: "#f4f4f4"
                font.pixelSize: 24
                font.bold: true
                Layout.fillWidth: true
            }

            Label {
                text: qsTr("Sign in to continue")
                color: "#bdbdbd"
                Layout.fillWidth: true
            }

            Label {
                text: qsTr("User name")
                color: "#f4f4f4"
                Layout.fillWidth: true
            }

            TextField {
                id: userNameField
                objectName: "userNameField"
                placeholderText: qsTr("User name")
                Layout.fillWidth: true
                onAccepted: passwordField.forceActiveFocus()
            }

            Label {
                text: qsTr("Password")
                color: "#f4f4f4"
                Layout.fillWidth: true
            }

            TextField {
                id: passwordField
                objectName: "passwordField"
                placeholderText: qsTr("Password")
                echoMode: TextInput.Password
                Layout.fillWidth: true
                onAccepted: {
                    if (loginButton.enabled)
                        root.loginRequested(root.userName, root.password)
                }
            }

            Label {
                text: root.errorMessage
                color: "#ff8a80"
                visible: root.errorMessage.length > 0
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }

            Button {
                id: loginButton
                text: qsTr("Sign in")
                enabled: root.userName.trim().length > 0 && root.password.length > 0
                Layout.fillWidth: true
                onClicked: root.loginRequested(root.userName, root.password)
            }
        }
    }
}
