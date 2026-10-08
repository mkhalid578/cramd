import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

InfoPopup {
    property var car: null

    function openForCar(selectedCar) {
        car = selectedCar
        open()
    }

       RowLayout {
        Label {
            text: car ? car.model : ""
        }
    }
}
