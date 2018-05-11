import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

RowLayout {
    spacing: 10

    Rectangle {
        id: itemNumberRectangle
        width: 50
        height: 30
        color: "teal"

        Text {
            text: qsTr("#")
            font.pixelSize: 15
            color: "white"
            anchors.centerIn: parent
        }
    }

    Rectangle {
        id: itemTypeRectangle
        width: 80
        height: 30
        color: "teal"

        Text {
            text: qsTr("Type")
            font.pixelSize: 15
            color: "white"
            anchors.centerIn: parent
        }
    }

    Rectangle {
        id: itemNameRectangle
        width: 180
        height: 30
        color: "teal"

        Text {
            text: qsTr("Name")
            font.pixelSize: 15
            color: "white"
            anchors.centerIn: parent
        }
    }

    Rectangle {
        id: quantityRectangle
        width: 120
        height: 30
        color: "teal"

        Text {
            text: qsTr("Quantity")
            font.pixelSize: 15
            color: "white"
            anchors.centerIn: parent
        }
    }

    Rectangle {
        id: pppRectangle
        width: 120
        height: 30
        color: "teal"

        Text {
            text: qsTr("Unit Cost")
            font.pixelSize: 15
            color: "white"
            anchors.centerIn: parent
        }
    }

    Rectangle {
        id: totalPriceRectangle
        width: 120
        height: 30
        color: "teal"

        Text {
            text: qsTr("Total Cost")
            font.pixelSize: 15
            color: "white"
            anchors.centerIn: parent
        }
    }

    Rectangle {
        id: copyMediumRectangle
        width: 120
        height: 30
        color: "teal"

        Text {
            text: qsTr("Copy Medium")
            font.pixelSize: 15
            color: "white"
            anchors.centerIn: parent
        }
    }
}
