import QtQuick
import QtQuick.Controls.Basic as T
import QtQuick.Layouts

T. ComboBox {
    id: itemTypeCombo
    Accessible.name: qsTr("Packed item type")
    width:  88
    height: 48
    model: [
        //Travel & Luggage
        "🧳", "🎒", "💼",

        //Sports & Outdoor Gear
        "⛺", "🪵", "🛹", "🛴", "🎿", "🛷", "🏂", "🪂", "🪁", "🥏", "🥊", "🏹", "🎣", "🤿", "🛞",

        //Ball Sports
        "⚽", "🏀", "🏈", "⚾", "🥎", "🎾", "🏐", "🏉", "🎱", "🪀", "🏓", "🏸", "🏒", "🏑", "🏏", "🥍", "⛳",

        //Tools & Emergency Supplies
        "🧰", "🔧", "🔨", "🪓", "🪚", "🪜", "🔦", "🪢", "🧯", "🩹", "🩺", "⛽",

        //Shopping & Cargo
        "🛍️", "🛒", "📦", "✉️",

        //Food, Drinks & Outings
        "🧺", "🧊", "🍾", "🍷", "🍸", "🍹", "🍺", "🍻", "🥤", "🧃", "🧉", "🥛", "🍉", "🎃",

        //Pets & Animals
        "🐕", "🐈",

        //Miscellaneous Items
        "🎸", "🎺", "🎻", "🪕", "🥁", "🧸", "🪴", "🧹", "🗑️", "🧥", "🥾", "☂️", "⛱️"
    ]

    contentItem: Text {
        leftPadding: 10
        rightPadding: itemTypeCombo.indicator.width + 8
        text: itemTypeCombo.displayText
        font.pixelSize: 24
        color: "#312e81"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        elide: Text.ElideRight
    }

    indicator: Text {
        x: itemTypeCombo.width - width - 10
        y: (itemTypeCombo.height - height) / 2
        text: itemTypeCombo.popup.visible ? "⌃" : "⌄"
        color: "#6d28d9"
        font.pixelSize: 18
    }

    background: Rectangle {
        radius: 14
        color: itemTypeCombo.pressed ? "#ddd6fe" : "#f5f3ff"
        border.color: itemTypeCombo.activeFocus ? "#7c3aed" : "#c4b5fd"
        border.width: itemTypeCombo.activeFocus ? 2 : 1

        Behavior on color {
            ColorAnimation { duration: 120 }
        }
    }

    popup: T.Popup {
        y: itemTypeCombo.height + 4
        width: 152
        height: Math.min(itemTypeList.contentHeight + padding * 2, 280)
        padding: 6

        background: Rectangle {
            radius: 14
            color: "white"
            border.color: "#ddd6fe"
        }

        contentItem: ListView {
            id: itemTypeList
            clip: true
            implicitHeight: Math.min(contentHeight, 268)
            model: itemTypeCombo.popup.visible ? itemTypeCombo.delegateModel : null
            currentIndex: itemTypeCombo.highlightedIndex
            boundsBehavior: Flickable.StopAtBounds
            T.ScrollBar.vertical: T.ScrollBar {
                policy: T.ScrollBar.AsNeeded
            }
        }
    }

    delegate: T.ItemDelegate {
        width: itemTypeCombo.popup.width - 12
        text: modelData
        highlighted: itemTypeCombo.highlightedIndex === index

        contentItem: Text {
            text: modelData
            font.pixelSize: 24
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        background: Rectangle {
            radius: 9
            color: parent.highlighted ? "#ede9fe"
                          : parent.down ? "#ddd6fe" : "transparent"
        }
    }
}
