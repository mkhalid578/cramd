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
    property int loginRequestId: 0
    property string signedInUser: ""

    Client {
        id: api
        baseUrl: "http://localhost:3000"

        onResponseReceived: (requestId, statusCode, body) => {
                        if (requestId !== window.loginRequestId)
                        return

                        if (statusCode >= 200 && statusCode < 300) {
                            window.signedInUser = loginForm.userName
                            loginForm.password = ""
                            pages.currentIndex = 1
                            window.title = qsTr("Home")
                        } else {
                            loginForm.errorMessage = qsTr("Login Failed: %1").arg(body.error)
                        }
                    }

        onRequestFailed: (requestId, message) => {
                     if (requestId === window.loginRequestId)
                     loginForm.errorMessage = message
                 }
    }

    StackLayout {
        id: pages
        anchors.fill: parent

        Item {
            LoginForm {
                id: loginForm
                anchors.centerIn: parent
                width: Math.min(parent.width - 32, 380)
                onLoginRequested: (user, password) => {
                              errorMessage = ""
                              window.loginRequestId = api.post("auth/login", {
                                                   email: user,
                                                   password: password
                                               })
                          }
            }
        }

        LoginSuccessPage {
            userName: window.signedInUser
            onSignOutRequested: {
                window.signedInUser = ""
                pages.currentIndex = 0
                window.title = qsTr("Sign in")
            }
        }
    }
}