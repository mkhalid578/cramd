import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import cramd

ApplicationWindow {
    id: window
    width: 640
    height: 480
    minimumWidth: 320
    minimumHeight: 360
    visible: true
    title: qsTr("Sign in")

    LoginForm {
        anchors.centerIn: parent
        width: Math.min(parent.width - 32, 380)
        onLoginRequested: (user, lastname) => {
                              console.log(user, lastname)
                          }
    }
}