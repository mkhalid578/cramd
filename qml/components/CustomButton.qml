import QtQuick
import QtQuick.Controls.Basic as T

T.Button {
    id: control


    contentItem: Text {
        text: control.text
        color: "white"
        font.pixelSize: 15
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    background: Rectangle {
        radius: 8
        gradient: Gradient {
            GradientStop {
                position: 0
                color: control.down ? "#5b21b6" : "#7c3aed"
            }

            GradientStop {
                position: 1
                color: control.down ? "#4f46e5" : "#6366f1"

            }
        }
        opacity: control.enabled ? 1 : 0.45
        scale: control.down ? 0.97 : 1

        Behavior on opacity {
            NumberAnimation {
                duration: 350
            }
        }

        Behavior on scale {
            NumberAnimation { duration: 100 }
        }
    }
}
