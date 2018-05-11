import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import "Common"
import "Common/JS/functions.js" as Js

Pane {

    property string customerName: Js.capitalize(Js.getFirstWord(name, ' '))
    property string pageTitle: qsTr("Welcome, " + customerName)

    RowLayout {
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: Math.round(mainAppWindow.height / 2)

        Label {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: 100
            color: "#ababab"
            font.pixelSize: 50
            text: qsTr("Hello ") + customerName + qsTr(",\nWhat would you like to do today?")
        }

        Item {
            width: (moviesIcon.width * 4) + (75 * 3)
            anchors.horizontalCenter: parent.horizontalCenter

            Image {
                id: moviesIcon
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/assets/icons/movies_.png"
            }

            MouseArea {
                id: moviesIconMousearea
                anchors.fill: moviesIcon
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onEntered: moviesIconRectangle.opacity = 1.0
                onExited: moviesIconRectangle.opacity = 0.0
                onClicked: function() {
                    mainView.push("Movies.qml");
                }
            }

            Image {
                id: seriesIcon
                anchors.left: moviesIcon.right
                anchors.leftMargin: 75
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/assets/icons/series_.png"
            }

            MouseArea {
                id: seriesIconMousearea
                anchors.fill: seriesIcon
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onEntered: seriesIconRectangle.opacity = 1.0
                onExited: seriesIconRectangle.opacity = 0.0
                onClicked: function() {
                    mainView.push("Series.qml");
                }
            }

            Image {
                id: musicIcon
                anchors.left: seriesIcon.right
                anchors.leftMargin: 75
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/assets/icons/music_.png"
            }

            MouseArea {
                anchors.fill: musicIcon
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onEntered: musicIconRectangle.opacity = 1.0
                onExited: musicIconRectangle.opacity = 0.0
                onClicked: function() {
                    mainView.push("Music.qml");
                }
            }

            Image {
                id: gamesIcon
                anchors.left: musicIcon.right
                anchors.leftMargin: 75
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/assets/icons/games_.png"
            }

            MouseArea {
                anchors.fill: gamesIcon
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onEntered: gamesIconRectangle.opacity = 1.0
                onExited: gamesIconRectangle.opacity = 0.0
                onClicked: function() {
                    mainView.push("Games.qml");
                }
            }
        }
    }

    RowLayout {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        height: Math.round(mainAppWindow.height / 4)

        Item {
            id: iconRectanglesItem
            width: parent.width
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            Rectangle {
                id: moviesIconRectangle
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                width: Math.round(parent.width / 4)
                height: 70
                color: "transparent"
                border.color: "#ababab"
                opacity: 0.0

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Movies")
                    font.pixelSize: 25
                }
            }

            Rectangle {
                id: seriesIconRectangle
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                width: Math.round(parent.width / 4)
                height: 70
                color: "transparent"
                border.color: "#ababab"
                opacity: 0.0

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Series")
                    font.pixelSize: 25
                }
            }

            Rectangle {
                id: musicIconRectangle
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                width: Math.round(parent.width / 4)
                height: 70
                color: "transparent"
                border.color: "#ababab"
                opacity: 0.0

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Music")
                    font.pixelSize: 25
                }
            }

            Rectangle {
                id: gamesIconRectangle
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                width: Math.round(parent.width / 4)
                height: 70
                color: "transparent"
                border.color: "#ababab"
                opacity: 0.0

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Games")
                    font.pixelSize: 25
                }
            }
        }
    }
}
