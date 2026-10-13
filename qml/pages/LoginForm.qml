import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import cramd.components 1.0

Item {
    id: root

    implicitWidth: 380
    implicitHeight: formContent.implicitHeight + 56

    property alias userName: userNameField.text
    property alias password: passwordField.text
    property string errorMessage: ""
    property string successMsg: ""

    signal loginRequested(string userName, string password)
    signal registerUserSelected();

    Rectangle {
        anchors.fill: parent
        radius: 12
        color: "#262626"
        border.color: "#3b3b3b"

        ColumnLayout {
            id: formContent
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
                text: qsTr("Sign up?")
                color: "#bdbdbd"
                Layout.fillWidth: true
                MouseArea {
                    anchors.fill: parent
                    onClicked: registerUserSelected()
                }
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

            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                SignInButton {
                    id: loginButton
                    text: qsTr("Sign in")
                    enabled: root.userName.trim().length > 0 && root.password.length > 0
                    Layout.fillWidth: true
                    Layout.preferredHeight: 48
                    onClicked: root.loginRequested(root.userName, root.password)

                }


                SignUpButton {
                    id: signUpButton
                    text: qsTr("Create account")
                    Layout.fillWidth: true
                    Layout.preferredHeight: 48
                    onClicked: registerUserSelected()

                }
            }
        }
    }
}
