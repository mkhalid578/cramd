import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import cramd

Item {
    id: root

    property CarsService service: ({})

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 16

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
                text: service.busy ? qsTr("Loading…") : qsTr("Refresh")
                enabled: !service.busy
                onClicked: service.loadCars()
            }
        }

        Label {
            text: service.errorMessage
            color: "#ff8a80"
            visible: text.length > 0
            wrapMode: Text.Wrap
            Layout.fillWidth: true
        }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: 0
            model: service.carsModel
            clip: true
            spacing: 10
            topMargin: 2
            bottomMargin: 2
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
            }

            delegate: Rectangle {
                required property var car

                width: ListView.view.width
                height: 100
                radius: 8
                color: "white"
                border.color: "#dddddd"

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 12

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 4

                        Label {
                            text: `${car.model_year} ${car.make} ${car.model}`
                            font.bold: true
                            font.pixelSize: 18
                        }

                        Label {
                            text: `${car.trim} · ${car.powertrain}`
                            color: "#666666"
                        }
                    }

                    Label {
                        text: `${car.body_style}`
                        font.bold: true
                        font.pixelSize: 17
                    }
                }
            }
        }
    }
}
