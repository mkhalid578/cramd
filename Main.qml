import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import cramd

ApplicationWindow {
    id: window
    width: 402
    height: 874
    visible: true
    title: auth.authenticated ? qsTr("Home") : qsTr("Sign in")

    Client {
        id: api
        baseUrl: "http://localhost:3000"
    }

    AuthService {
        id: auth
        client: api
    }

    CarsService {
        id: cars
        client: api
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

        MainPage {

            username: auth.userName
            onLogoutRequested: auth.logout()
            service: cars

        }

        LoginSuccessPage {
            userName: auth.userName
            onSignOutRequested: {
                auth.logout()
            }
        }
    }
}