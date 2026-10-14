import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import cramd

ApplicationWindow {
    id: window
    width: Qt.platform.os === "ios" ? Screen.width : 402
    height: Qt.platform.os === "ios" ? Screen.height : 874
    visible: true
    title: auth.authenticated ? qsTr("Home") : qsTr("Sign in")

    enum Pages {Login = 0, Register = 1, Main = 2 }

    property int page: auth.authenticated ? Main.Pages.Main : Main.Pages.Login

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
        function onAuthenticatedChanged() {
            if (auth.authenticated)
                pages.push(mainPage)
            else
                pages.pop()

        }
    }

    Component {
        id: loginForm


            LoginForm {
                id: loginCard
                errorMessage: auth.errorMessage
                successMsg: auth.successMsg

                onLoginRequested: (user, password) => auth.login(user, password)

                onRegisterUserSelected: pages.push(registerForm)
            }
    }

    Component {
        id: registerForm



            RegisterForm {
                id: registerCard

                errorMessage: auth.errorMessage
                successMsg: auth.successMsg
                onRegisterRequested: (user, first, last, password) => auth.registerUser(first, last, user, password)
                onBackToLoginRequested: pages.pop()
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
        anchors.margins: 8
        initialItem: loginForm
    }
}