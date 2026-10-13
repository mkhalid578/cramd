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

        }
    }

    Component {
        id: loginForm
        Item {
            LoginForm {
                anchors.centerIn: parent
                errorMessage: auth.errorMessage
                id: loginForm
                successMsg: auth.successMsg
                width: Math.min(parent.width - 32, 380)

                onLoginRequested: (user, password) => auth.login(user, password)

                onRegisterUserSelected: registerOverlay.push(registerForm)
            }
        }
    }

    Component {
        id: registerForm

        Item {
            RegisterForm {
                onRegisterUserSelected: pages.currentIndex = Main.Pages.Register
            }
        }
    }

    Component {
        id: mainPage

        MainPage {

            username: auth.userName
            firstName: auth.firstName

            onLogoutRequested: () => {
                                   auth.logout()
                                   pages.pop()
                               }
            service: cars

        }
    }

    StackView{
        id: pages
        anchors.fill: parent
        initialItem: loginForm
    }

    StackView {
        id: registerOverlay
        anchors.fill: parent
        z: 1
        initialItem: Item {}

        pushEnter: Transition {
            NumberAnimation {
                property: "y"
                from: registerOverlay.height
                to: 0
                duration: 350
                easing.type: Easing.OutCubic
            }
        }

        popExit: Transition {
            NumberAnimation {
                property: "y"
                from: 0
                to: registerOverlay.height + 10
                duration: 280
                easing.type: Easing.OutCubic
            }
        }
    }
}