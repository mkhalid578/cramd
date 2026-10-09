import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

Rectangle {
    required property var car
    property bool favorite: false
    readonly property real edgeFadeHeight: 36
    signal selected(var car)
    signal favoriteToggled(var car)

    width: ListView.view.width - ListView.view.leftMargin - ListView.view.rightMargin
    height: 160
    opacity: {
        const list = ListView.view
        const itemTop = y - list.contentY
        return Math.min(1,
                        Math.max(0, (itemTop + height) / edgeFadeHeight),
                        Math.max(0, (list.height - itemTop) / edgeFadeHeight))
    }
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
                    text: favorite ? "♥" : "+"
                    icon.color: "black"
                    Layout.preferredWidth: 48
                    onClicked: favoriteToggled(car)
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
