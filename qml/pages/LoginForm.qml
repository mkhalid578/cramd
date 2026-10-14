import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import cramd.components

Rectangle {
    id: root

    implicitWidth: 380
    implicitHeight: formContent.implicitHeight + 32

    property alias userName: userNameField.text
    property alias password: passwordField.text
    property string errorMessage: ""
    property string successMsg: ""

    signal loginRequested(string userName, string password)
    signal registerUserSelected();
    signal inputFocusRequested(var input)

    color: "#F0EAD6"

    ColumnLayout {
        id: formContent
        anchors.centerIn: parent
        width: Math.min(parent.width - 32, 380)
        height: implicitHeight
        spacing: 32

        Label {
            text: qsTr("Cramd - will it fit?")
            color: "black"
            font.pixelSize: 24
            font.bold: true
            Layout.fillWidth: true
        }


        CustomTextField {
            id: userNameField
            objectName: "userNameField"
            placeholderText: qsTr("Email or Username")
            Layout.fillWidth: true
            onAccepted: passwordField.forceActiveFocus()
            onActiveFocusChanged: if (activeFocus) root.inputFocusRequested(userNameField)
        }


        CustomTextField {
            id: passwordField
            objectName: "passwordField"
            placeholderText: qsTr("Password")
            echoMode: TextInput.Password
            Layout.fillWidth: true
            onActiveFocusChanged: if (activeFocus) root.inputFocusRequested(passwordField)
            onAccepted: {
                if (loginButton.enabled)
                    root.loginRequested(root.userName, root.password)
            }
        }

        CustomButton {
            id: loginButton
            text: qsTr("Sign in")
            enabled: root.userName.trim().length > 0 && root.password.length > 0
            Layout.fillWidth: true
            Layout.preferredHeight: 48
            onClicked: root.loginRequested(root.userName, root.password)

        }


        Label {
            text: root.errorMessage
            color: "#ff8a80"
            visible: formContent.errorMessage.length > 0
            wrapMode: Text.Wrap
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredHeight: 48
            Layout.preferredWidth: 120
        }

        Label {
            text: qsTr("Don't have an account? SIGN UP")
            color: "#5b21b6"
            MouseArea {
                anchors.fill: parent
                onPressed: registerUserSelected()
            }
        }

    }
}
