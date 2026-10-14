import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import cramd.components

Item {
    id: root

    implicitWidth: 380
    implicitHeight: formContent.implicitHeight + 56

    property alias userName: userNameField.text
    property alias firstName: firstNameField.text
    property alias lastName: lastNameField.text
    property alias password: passwordField.text
    property string errorMessage: ""
    property string successMsg: ""

    signal registerRequested(string email, string first, string last, string password)
    signal backToLoginRequested()

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

            Button {
                text: qsTr("←  Back to sign in")
                Layout.alignment: Qt.AlignLeft
                Layout.preferredWidth: 164
                Layout.preferredHeight: 40
                onClicked: root.backToLoginRequested()

                contentItem: Text {
                    text: parent.text
                    color: "#d6d6d6"
                    font.pixelSize: 14
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    radius: 8
                    color: parent.down ? "#202020" : parent.hovered ? "#383838" : "#303030"
                    border.color: "#454545"
                }
            }


            Label {
                text: qsTr("Create Account")
                color: "#bdbdbd"
                Layout.fillWidth: true
            }

            Label {
                text: qsTr("Email")
                color: "#f4f4f4"
                Layout.fillWidth: true
            }

            CustomTextField {
                id: userNameField
                objectName: "userNameField"
                placeholderText: qsTr("Email")
                Layout.fillWidth: true
                onAccepted: passwordField.forceActiveFocus()
            }

            Label {
                text: qsTr("First Name")
                color: "#f4f4f4"
                Layout.fillWidth: true
            }

            CustomTextField {
                id: firstNameField
                placeholderText: qsTr("First Name")
                Layout.fillWidth: true
                onAccepted: passwordField.forceActiveFocus()
            }
            Label {
                text: qsTr("Last Name")
                color: "#f4f4f4"
                Layout.fillWidth: true
            }

            CustomTextField {
                id: lastNameField
                placeholderText: qsTr("Last Name")
                Layout.fillWidth: true
                onAccepted: passwordField.forceActiveFocus()
            }

            Label {
                text: qsTr("Password")
                color: "#f4f4f4"
                Layout.fillWidth: true
            }

            CustomTextField {
                id: passwordField
                objectName: "passwordField"
                placeholderText: qsTr("Password")
                echoMode: TextInput.Password
                Layout.fillWidth: true
                // onAccepted: {
                //     if (loginButton.enabled)
                //         root.loginRequested(root.userName, root.password)
                // }
            }

            Label {
                text: root.errorMessage
                color: "#ff8a80"
                visible: root.errorMessage.length > 0
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }

            Label {
                text: root.successMsg
                color: "green"
                visible: root.successMsg.length > 0
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }

            CustomButton {
                id: loginButton
                text: qsTr("Register")
                enabled: root.userName.trim().length > 0 && root.password.length > 0
                Layout.fillWidth: true
                Layout.preferredHeight: 48
                onClicked: root.registerRequested(root.userName, root.firstName, root.lastName, root.password)
            }
        }
    }
}
