import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import cramd

Item {
    id: root

    property string username: ""
    signal logoutRequested()

    property CarsService service: ({})

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 16

        Label {
            text: qsTr("Welcome %1").arg(username)
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
                text: qsTr("Log Out")
                onClicked: logoutRequested()
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
            id: carList

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: 0
            model: service.carsModel
            clip: true
            spacing: 10
            topMargin: 2
            bottomMargin: 2
            boundsBehavior: Flickable.StopAtBounds
            orientation: Qt.Horizontal
            snapMode: ListView.SnapOneItem

            function updateCurrentIndexFromPosition() {
                if (count === 0 || width <= 0)
                    return

                const pageSize = width + spacing
                const index = Math.round((contentX - originX) / pageSize)
                currentIndex = Math.max(0, Math.min(count - 1, index))
            }

            onMovementEnded: updateCurrentIndexFromPosition()

            delegate: CarDelegate {}
        }

        RowLayout {

            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter

            Repeater {
                model: carList.count
                Rectangle {
                    width: 8
                    height: 8
                    radius: width / 2
                    color: "white"
                    scale: index == carList.currentIndex ? 1.2 : 1.0
                }
            }
        }

        Label {
            property int activeIndex: carList.currentIndex
            text: carList.count > 0
              ? qsTr("%1 / %2").arg(activeIndex + 1).arg(carList.count)
              : qsTr("0 / 0")
            color: "#bdbdbd"
            horizontalAlignment: Text.AlignHCenter
            Layout.fillWidth: true
        }
    }
}
