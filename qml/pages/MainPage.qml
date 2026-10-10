import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import cramd

Item {
    id: root

    property string username: ""
    signal logoutRequested()
    property CarsService service: ({})
    property bool carsLoaded: false
    property var packedItemsByCar: ({})

    function carKey(car) {
        if (car.id !== undefined && car.id !== null)
            return String(car.id)

        return [car.make, car.model, car.model_year, car.trim].join("|")
    }

    function suitcaseCountFor(car) {
        return packedItemCountFor(car, "suitcase")
    }

    function strollerCountFor(car) {
        return packedItemCountFor(car, "stroller")
    }

    function packedItemsFor(car) {
        return car ? packedItemsByCar[carKey(car)] || [] : []
    }

    function packedItemCountFor(car, type) {
        return packedItemsFor(car).filter(item => item === type).length
    }

    function updatePackedItems(car, type, change) {
        if (!car)
            return

        const itemsByCar = Object.assign({}, packedItemsByCar)
        const key = carKey(car)
        const items = packedItemsFor(car).slice()

        if (change > 0) {
            items.push(type)
        } else {
            const index = items.lastIndexOf(type)
            if (index >= 0)
                items.splice(index, 1)
        }

        itemsByCar[key] = items
        packedItemsByCar = itemsByCar
    }

    function loadCarsIfNeeded() {
        if (service && service.loadCars && !carsLoaded && !service.busy)
            service.loadCars()
    }

    onVisibleChanged: {
        if (visible)
            loadCarsIfNeeded()
    }

    onServiceChanged: {
        if (visible)
            loadCarsIfNeeded()
    }

    Connections {
        target: root.service
        function onCarsChanged() {
            root.carsLoaded = true
        }
    }

    CarInfoPopup {
        id: popup
        packedItems: root.packedItemsFor(car)
        suitcaseCount: root.suitcaseCountFor(car)
        onSuitcaseCountChangeRequested: change => {
            root.updatePackedItems(car, "suitcase", change)
        }
        strollerCount: root.strollerCountFor(car)
        onStrollerCountChangeRequested: change => {
            root.updatePackedItems(car, "stroller", change)
        }
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

                Label {
                    text: qsTr("Cars")
                    color: "#f4f4f4"
                    font.pixelSize: 24
                    font.bold: true
                    Layout.fillWidth: true
                }

                Label {
                    text: root.service.errorMessage
                    color: "#ff8a80"
                    visible: text.length > 0
                    wrapMode: Text.Wrap
                    Layout.fillWidth: true
                }

                Item {
                    id: carListContainer

                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.minimumHeight: 0
                    property real pullDistance: 0
                    readonly property real refreshThreshold: 72

                    ListView {
                        id: carList
                        anchors.fill: parent
                        model: root.service.carsModel
                        clip: true
                        spacing: 12
                        topMargin: 4
                        leftMargin: 8
                        rightMargin: 8
                        bottomMargin: 12
                        boundsBehavior: Flickable.DragAndOvershootBounds
                        ScrollBar.vertical: ScrollBar {
                            policy: ScrollBar.AsNeeded
                        }

                        onMovementStarted: carListContainer.pullDistance = 0
                        onContentYChanged: {
                            if (dragging && contentY < originY)
                                carListContainer.pullDistance = Math.max(
                                            carListContainer.pullDistance,
                                            originY - contentY)
                        }
                        onMovementEnded: {
                            if (carListContainer.pullDistance >= carListContainer.refreshThreshold
                                    && !root.service.busy)
                                root.service.loadCars()

                            carListContainer.pullDistance = 0
                            updateCurrentIndexFromPosition()
                        }

                        function updateCurrentIndexFromPosition() {
                            if (count === 0 || width <= 0)
                                return

                            const pageSize = width + spacing
                            const index = Math.round((contentX - originX) / pageSize)
                            currentIndex = Math.max(0, Math.min(count - 1, index))
                        }

                        delegate: CarDelegate {
                            suitcaseCount: root.suitcaseCountFor(car)
                            strollerCount: root.strollerCountFor(car)
                            onSelected: (selectedCar) => popup.openForCar(selectedCar)
                            onSuitcaseAdded: (selectedCar) => {
                                root.updatePackedItems(selectedCar, "suitcase", 1)
                                popup.openForCar(selectedCar)
                            }
                            onStrollerAdded: (selectedCar) => {
                                root.updatePackedItems(selectedCar, "stroller", 1)
                                popup.openForCar(selectedCar)
                            }
                        }
                    }

                    RowLayout {
                        anchors.horizontalCenter: parent.horizontalCenter
                        y: 8
                        spacing: 8
                        opacity: root.service.busy ? 1
                                                    : Math.min(1, carListContainer.pullDistance
                                                               / carListContainer.refreshThreshold)
                        visible: opacity > 0 || root.service.busy

                        Text {
                            text: root.service.busy ? "↻" : "↓"
                            color: "#6d28d9"
                            font.pixelSize: 18

                            RotationAnimation on rotation {
                                from: 0
                                to: 360
                                duration: 900
                                loops: Animation.Infinite
                                running: root.service.busy
                            }
                        }

                        Label {
                            text: root.service.busy ? qsTr("Updating cars…")
                                                    : carListContainer.pullDistance
                                                      >= carListContainer.refreshThreshold
                                                      ? qsTr("Release to refresh")
                                                      : qsTr("Pull to refresh")
                            color: "#6d28d9"
                            font.pixelSize: 12
                        }
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
                    id: logoutButton
                    text: qsTr("Log Out")
                    Layout.fillWidth: true
                    onClicked: root.logoutRequested()

                    contentItem: RowLayout {
                        spacing: 10
                        anchors.centerIn: parent

                        Text {
                            text: "⇥"
                            color: "#fca5a5"
                            font.pixelSize: 20
                            Layout.alignment: Qt.AlignVCenter
                        }

                        Label {
                            text: logoutButton.text
                            color: "#fecaca"
                            font.bold: true
                            Layout.alignment: Qt.AlignVCenter
                        }
                    }

                    background: Rectangle {
                        radius: 12
                        color: logoutButton.down ? "#7f1d1d"
                                     : logoutButton.hovered ? "#3f1d25" : "#2b1c22"
                        border.color: "#7f343d"
                        border.width: 1

                        Behavior on color {
                            ColorAnimation { duration: 130 }
                        }
                    }
                }
            }
        }

        TabBar {
            id: tabBar
            Layout.fillWidth: true
            Layout.margins: 8
            spacing: 6

            // background: Rectangle {
            //     color: "#1f1f1f"
            //     border.color: "#3b3b3b"
            //     border.width: 1
            //     radius: 18
            // }


            CustomTabButton {
                text: qsTr("Home")
                buttonIcon:  "⌂"

            }

            CustomTabButton {
                id: profileTab
                text: qsTr("Profile")
                buttonIcon: "⚙"
            }
        }
    }
}
