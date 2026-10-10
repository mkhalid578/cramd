import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

Rectangle {
    required property var car
    property bool favorite: false
    property int suitcaseCount: 0
    property int strollerCount: 0
    readonly property real edgeFadeHeight: 36
    signal selected(var car)
    signal favoriteToggled(var car)
    signal suitcaseAdded(var car)
    signal strollerAdded(var car)

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
                spacing: 8

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

                Button {
                    id: suitcaseButton
                    Accessible.name: qsTr("Add suitcase to %1 %2. %3 packed")
                                     .arg(car.model_year).arg(car.make).arg(suitcaseCount)
                    Layout.preferredWidth: 72
                    Layout.preferredHeight: 44
                    onClicked: {

                        suitcaseAdded(car)
                    }

                    contentItem: RowLayout {
                        spacing: 5

                        Text {
                            text: "🧳"
                            font.pixelSize: 17
                            Layout.alignment: Qt.AlignVCenter
                        }

                        Label {
                            text: `${suitcaseCount} +`
                            color: "#075985"
                            font.bold: true
                            font.pixelSize: 13
                            Layout.alignment: Qt.AlignVCenter
                        }
                    }

                    background: Rectangle {
                        radius: 14
                        color: suitcaseButton.down ? "#bae6fd" : "#e0f2fe"
                        border.color: "#7dd3fc"

                        Behavior on color {
                            ColorAnimation { duration: 130 }
                        }
                    }
                }

                Button {
                    id: strollerButton
                    Accessible.name: qsTr("Add stroller to %1 %2. %3 packed")
                                     .arg(car.model_year).arg(car.make).arg(strollerCount)
                    Layout.preferredWidth: 72
                    Layout.preferredHeight: 44
                    onClicked: strollerAdded(car)

                    contentItem: RowLayout {
                        spacing: 4

                        Image {
                            source: "qrc:/qt/qml/cramd/qml/assets/Stroller.svg"
                            sourceSize: Qt.size(22, 22)
                            Layout.preferredWidth: 22
                            Layout.preferredHeight: 22
                        }

                        Label {
                            text: `${strollerCount} +`
                            color: "#6d28d9"
                            font.bold: true
                            font.pixelSize: 13
                            Layout.alignment: Qt.AlignVCenter
                        }
                    }

                    background: Rectangle {
                        radius: 14
                        color: strollerButton.down ? "#ddd6fe" : "#ede9fe"
                        border.color: "#c4b5fd"

                        Behavior on color {
                            ColorAnimation { duration: 130 }
                        }
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                Button {
                    id: detailsButton
                    text: qsTr("Info ›")
                    Layout.preferredWidth: 92
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
