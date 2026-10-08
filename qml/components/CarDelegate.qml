import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

Rectangle {
    required property var car
    signal selected(var car)

    width: ListView.view.width
    height: 160
    anchors.margins: 16
    radius: 8
    color: "white"
    border.color: "#dddddd"

    MouseArea {
        anchors.fill: parent
        onClicked: selected(car)
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 12

            Image {
                source: CarMake.urlForMake(`${car.make}`)
                fillMode: Image.PreserveAspectFit
            }

            Label {
                text: `${car.model_year}`
                color: "black"
            }

            Label {
                text: `${car.model}`
                font.bold: true
                font.pixelSize: 18
                color: "black"
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                Button {
                    text: "+"
                    icon.color: "black"
                    Layout.preferredWidth: 48
                    background: Rectangle {
                        radius: 8
                        border.color: "black"
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                Button {
                    text: "More Info"
                    background: Rectangle {
                        radius: 8
                        border.color: "black"
                    }
                }
            }
        }
    }
}
