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
    title: auth.authenticated ? qsTr("Home") : qsTr("Sign in")

    AuthService {
        id: auth
        baseUrl: "http://localhost:3000"
    }

    StackLayout {
        id: pages
        anchors.fill: parent
        currentIndex: auth.authenticated ? 1 : 0

        Item {
            LoginForm {
                id: loginForm
                anchors.centerIn: parent
                width: Math.min(parent.width - 32, 380)
                errorMessage: auth.errorMessage
                onLoginRequested: (user, password) => auth.login(user, password)
            }
        }

        LoginSuccessPage {
            userName: auth.userName
            onSignOutRequested: {
                auth.logout()
            }
        }
    }
}