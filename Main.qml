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

    enum Pages {Login = 0, Register = 1, Main = 2 }

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

    Connections {
        target: auth
        function onSuccessMsgChanged() {
            pages.currentIndex = Main.Pages.Login
        }
    }

    StackLayout {
        id: pages
        anchors.fill: parent
        currentIndex: auth.authenticated ? Main.Pages.Main : 0

        Item {
            LoginForm {
                anchors.centerIn: parent
                errorMessage: auth.errorMessage
                id: loginForm
                successMsg: auth.successMsg
                width: Math.min(parent.width - 32, 380)

                onLoginRequested: (user, password) => auth.login(user, password)

                onRegisterUserSelected: pages.currentIndex = Main.Pages.Register
            }
        }

        Item {
            RegisterForm {
                id: registFrom
                anchors.centerIn: parent
                width: Math.min(parent.width - 32, 380)
                errorMessage: auth.errorMessage
                successMsg: auth.successMsg
                onRegisterRequested: (user, first, last, password) => auth.registerUser(first, last, user, password)

            }
        }

        MainPage {

            username: auth.userName
            firstName: auth.firstName

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