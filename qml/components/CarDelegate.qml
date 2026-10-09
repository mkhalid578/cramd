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
                    id: favoriteButton
                    Accessible.name: favorite ? qsTr("Remove from favorites")
                                  : qsTr("Add to favorites")
                    Layout.preferredWidth: 48
                    Layout.preferredHeight: 44
                    onClicked: favoriteToggled(car)

                    contentItem: Text {
                        text: favorite ? "♥" : "♡"
                        color: favorite ? "#fff1f2" : "#e11d48"
                        font.pixelSize: 23
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        scale: favoriteButton.down ? 0.88 : 1

                        Behavior on scale {
                            NumberAnimation { duration: 100 }
                        }
                    }

                    background: Rectangle {
                        radius: 14
                        color: favoriteButton.down ? "#be123c"
                                       : favorite ? "#e11d48" : "#fff1f2"
                        border.color: "#fecdd3"

                        Behavior on color {
                            ColorAnimation { duration: 140 }
                        }
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                Button {
                    id: detailsButton
                    text: qsTr("More info ›")
                    Layout.preferredHeight: 44
                    Accessible.name: qsTr("More information about %1 %2")
                    .arg(car.model_year).arg(car.make)
                    onClicked: selected(car)

                    background: Rectangle {
                        radius: 14
                        gradient: Gradient {
                            GradientStop { position: 0; color: detailsButton.down ? "#5b21b6" : "#7c3aed" }
                            GradientStop { position: 1; color: detailsButton.down ? "#6d28d9" : "#4f46e5" }
                        }
                    }
                }
            }
        }
    }
}
