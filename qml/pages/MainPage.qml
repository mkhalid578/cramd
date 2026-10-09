import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import cramd

Item {
    id: root

    property string username: ""
    signal logoutRequested()
    property CarsService service: ({})

    CarInfoPopup {
        id: popup
    }

    ColumnLayout {
        anchors.fill: parent

        Image {
            source: "qrc:/qt/qml/cramd/qml/assets/CramdLogo.svg"
            fillMode: Image.PreserveAspectFit
            Layout.fillWidth: true
            Layout.leftMargin: 16
            Layout.rightMargin: 16
            Layout.preferredHeight: Math.min(root.width / 3, 120)
        }

        StackLayout {
            id: tabPages
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: tabBar.currentIndex

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.margins: 20
                spacing: 16

                Label {
                    text: qsTr("Welcome %1").arg(root.username)
                    color: "#f4f4f4"
                    Layout.fillWidth: true
                }

                RowLayout {
                    Layout.fillWidth: true

                    Label {
                        text: qsTr("Cars")
                        color: "#f4f4f4"
                        font.pixelSize: 24
                        font.bold: true
                        Layout.fillWidth: true
                    }

                    Button {
                        text: root.service.busy ? qsTr("Loading…") : qsTr("Refresh")
                        enabled: !root.service.busy
                        onClicked: root.service.loadCars()
                    }
                }

                Label {
                    text: root.service.errorMessage
                    color: "#ff8a80"
                    visible: text.length > 0
                    wrapMode: Text.Wrap
                    Layout.fillWidth: true
                }

                ListView {
                    id: carList

                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.minimumHeight: 0
                    model: root.service.carsModel
                    clip: true
                    spacing: 10
                    topMargin: 2
                    bottomMargin: 2
                    boundsBehavior: Flickable.StopAtBounds
                    // snapMode: ListView.SnapOneItem

                    function updateCurrentIndexFromPosition() {
                        if (count === 0 || width <= 0)
                            return

                        const pageSize = width + spacing
                        const index = Math.round((contentX - originX) / pageSize)
                        currentIndex = Math.max(0, Math.min(count - 1, index))
                    }

                    onMovementEnded: updateCurrentIndexFromPosition()

                    delegate: CarDelegate {
                        onSelected: (selectedCar) => popup.openForCar(selectedCar)
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.margins: 20
                spacing: 16

                Label {
                    text: qsTr("Profile")
                    color: "#f4f4f4"
                    font.pixelSize: 24
                    font.bold: true
                    Layout.fillWidth: true
                }

                Label {
                    text: root.username
                    color: "#f4f4f4"
                    font.pixelSize: 18
                    Layout.fillWidth: true
                }

                Button {
                    text: qsTr("Log Out")
                    Layout.fillWidth: true
                    onClicked: root.logoutRequested()
                }
            }
        }

        TabBar {
            id: tabBar
            Layout.fillWidth: true
            implicitHeight: 76
            spacing: 6
            padding: 8

            background: Rectangle {
                color: "#1f1f1f"
                border.color: "#3b3b3b"
                border.width: 1
                radius: 18
            }


            CustomTabButton {
                text: qsTr("Home")
                buttonIcon:  "⌂"

            }

            CustomTabButton {
                id: profileTab
                text: qsTr("Profile")
                buttonIcon: "●"
            }
        }
    }
}
