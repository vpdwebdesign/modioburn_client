import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "tools"

Page {
    id: homePage

    property string pageTitle: qsTr("Modio Burn Options")

    property string clientName: userName

    RowLayout {
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        height: 512

        Label {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: 100
            color: "#ababab"
            font.pixelSize: 50
            text: qsTr("Hello ") + clientName + qsTr(",\nWhat would you like to do today?")
        }

        Item {
            width: Math.round(parent.width / 1.7)
            anchors.verticalCenter: parent.verticalCenter
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
                onClicked: [clientInterfaceSwipeViewIndex = 0,
                    mainView.goToPage(3)]
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
                onClicked: [clientInterfaceSwipeViewIndex = 1,
                    mainView.goToPage(3)]
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
                onClicked: [clientInterfaceSwipeViewIndex = 2,
                    mainView.goToPage(3)]
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
                onClicked: [clientInterfaceSwipeViewIndex = 3,
                    mainView.goToPage(3)]
            }
        }
    }

    RowLayout {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        height: 100

        Item {
            width: parent.width / 1.8
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            Rectangle {
                id: moviesIconRectangle
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width / 2
                height: 70
                color: "transparent"
                border.color: "#ababab"
                opacity: 0.0

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Watch a movie")
                    font.pixelSize: 25
                }
            }

            Rectangle {
                id: seriesIconRectangle
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width / 2
                height: 70
                color: "transparent"
                border.color: "#ababab"
                opacity: 0.0

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Watch a series")
                    font.pixelSize: 25
                }
            }

            Rectangle {
                id: musicIconRectangle
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width / 2
                height: 70
                color: "transparent"
                border.color: "#ababab"
                opacity: 0.0

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Listen to music")
                    font.pixelSize: 25
                }
            }

            Rectangle {
                id: gamesIconRectangle
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width / 2
                height: 70
                color: "transparent"
                border.color: "#ababab"
                opacity: 0.0

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Play a game")
                    font.pixelSize: 25
                }
            }
        }
    }

    function whoAmI() {
        return qsTr("Message from Home Page")
    }
    // called immediately after push()
    function init() {
        console.log(qsTr("Init done from Home Page"))
    }
    // called immediately after pop()
    function cleanup() {
        console.log(qsTr("Cleanup done from Home Page"))
    }
}
