import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

InfoPopup {
    id: popup

    property var car: null
    property var packedItems: []
    property int suitcaseCount: 0
    property int strollerCount: 0
    property real suitcaseVolumeCuFt: 0
    property real strollerVolumeCuFt: 0
    signal suitcaseCountChangeRequested(int change)
    signal strollerCountChangeRequested(int change)

    function openForCar(selectedCar) {
        car = selectedCar
        open()
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 12

        Label {
            text: popup.car
                  ? qsTr("%1 %2 %3").arg(popup.car.model_year)
                .arg(popup.car.make).arg(popup.car.model)
                  : ""
            color: "#1f2937"
            font.pixelSize: 22
            font.bold: true
            wrapMode: Text.Wrap
            Layout.fillWidth: true
        }

        Image {
            source: "qrc:/qt/qml/cramd/qml/assets/RearLegroom.svg"
            fillMode: Image.PreserveAspectFit
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: 120
        }

        Label {
            text: qsTr("Total Stroller: %1 \n Total Suitcases: %2").arg(popup.strollerVolumeCuFt).arg(popup.suitcaseVolumeCuFt)
        }

        Label {
            text: qsTr("Packed items")
            color: "#334155"
            font.bold: true
            Layout.fillWidth: true
        }

        Flow {
            Layout.fillWidth: true
            spacing: 6

            Repeater {
                model: popup.packedItems

                delegate: Item {
                    required property string modelData
                    width: 30
                    height: 30

                    Label {
                        anchors.centerIn: parent
                        text: "🧳"
                        font.pixelSize: 24
                        visible: modelData === "suitcase"
                        Accessible.name: qsTr("Packed suitcase")
                    }

                    Image {
                        anchors.fill: parent
                        source: "qrc:/qt/qml/cramd/qml/assets/Stroller.svg"
                        sourceSize: Qt.size(30, 30)
                        visible: modelData === "stroller"
                        Accessible.name: qsTr("Packed stroller")
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Label {
                text: qsTr("Volume per stroller (ft³)")
                color: "#475569"
                Layout.fillWidth: true
            }

        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Button {
                Accessible.name: qsTr("Remove a suitcase")
                enabled: popup.suitcaseCount > 0
                Layout.preferredWidth: 48
                Layout.preferredHeight: 48
                onClicked: popup.suitcaseCountChangeRequested(-1)

                contentItem: Text {
                    text: "−"
                    color: "#5b21b6"
                    font.pixelSize: 26
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    radius: width / 2
                    color: parent.down ? "#ddd6fe" : "#ede9fe"
                    border.color: "#c4b5fd"
                    opacity: parent.enabled ? 1 : 0.45
                    scale: parent.down ? 0.92 : 1

                    Behavior on scale {
                        NumberAnimation { duration: 100 }
                    }
                }
            }

            Label {
                text: popup.suitcaseCount
                color: "#1f2937"
                font.pixelSize: 20
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                Layout.preferredWidth: 36
            }

            Button {
                Accessible.name: qsTr("Add a suitcase")
                Layout.preferredWidth: 48
                Layout.preferredHeight: 48
                onClicked: popup.suitcaseCountChangeRequested(1)

                contentItem: Text {
                    text: "+"
                    color: "white"
                    font.pixelSize: 26
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    radius: width / 2
                    color: parent.down ? "#5b21b6" : "#7c3aed"
                    scale: parent.down ? 0.92 : 1

                    Behavior on color {
                        ColorAnimation { duration: 130 }
                    }
                    Behavior on scale {
                        NumberAnimation { duration: 100 }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Label {
                text: qsTr("Volume per suitcase (ft³)")
                color: "#475569"
                Layout.fillWidth: true
            }

            TextField {
                id: suitcaseVolumeField
                text: "0"
                placeholderText: qsTr("Volume")
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                validator: DoubleValidator {
                    bottom: 0
                    decimals: 2
                    notation: DoubleValidator.StandardNotation
                }
                Layout.preferredWidth: 104
                onEditingFinished: {
                    if (acceptableInput) {
                        popup.suitcaseVolumeCuFt += Number(text)
                        text = popup.suitcaseVolumeCuFt.toFixed(2)
                    }
                }
            }
        }

        Label {
            text: qsTr("Strollers")
            color: "#334155"
            font.bold: true
            Layout.fillWidth: true
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            CargoItemsComboBox {}


            CargoItemCounter {
                Layout.preferredWidth: 48
                Layout.preferredHeight: 48
                Accessible.name: qsTr("Remove a stroller")
                onClicked: popup.strollerCountChangeRequested(-1)
                enabled: popup.strollerCount > 0

            }

            Label {
                text: popup.strollerCount
                color: "#1f2937"
                font.pixelSize: 20
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                Layout.preferredWidth: 16
            }

            CargoItemCounter {
                Accessible.name: qsTr("Add a stroller")
                text: qsTr("-")
                Layout.preferredWidth: 48
                Layout.preferredHeight: 48
                onClicked: popup.strollerCountChangeRequested(1)
            }
            TextField {
                id: strollerVolumeField
                text: "0"
                placeholderText: qsTr("Volume")
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                validator: DoubleValidator {
                    bottom: 0
                    decimals: 2
                    notation: DoubleValidator.StandardNotation
                }
                Layout.preferredWidth: 64
                onEditingFinished: {
                    if (acceptableInput) {
                        popup.strollerVolumeCuFt = Number(text)
                        text = popup.strollerVolumeCuFt.toFixed(2)
                    }
                }
            }
        }
    }
}
