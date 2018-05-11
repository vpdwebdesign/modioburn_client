import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

RowLayout {
    id: parentLayout

    height: parent.height
    anchors.left: parent.left
    anchors.leftMargin: 250
    spacing: 20

    property int rectangleWidth: 150
    property int rectangleHeight: parent.height
    property int yearRectangleWidth: Math.round(rectangleWidth / 1.5)
    property string rectangleColor: "#607d8b"

    signal sortActivated(int col, int sortOrder)

    Rectangle {
        id: sortByTitle
        width: rectangleWidth
        height: rectangleHeight
        color: rectangleColor

        state: "ascending"

        Text {
            id: sortByTitleText
            text: qsTr("Title")
            font.pixelSize: 15
            color: "white"
            anchors.centerIn: parent
        }

        Image {
            id: sortByTitleButton
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 10
        }

        MouseArea {
            anchors.fill: sortByTitleButton
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                if (sortByTitle.state == "ascending")
                {
                    sortByTitle.state = "descending"
                    parentLayout.sortActivated(0, Qt.DescendingOrder)
                }
                else
                {
                    sortByTitle.state = "ascending"
                    parentLayout.sortActivated(0, Qt.AscendingOrder)
                }
            }
        }

        states: [
            State {
                name: "ascending"
                PropertyChanges {
                    target: sortByTitleButton
                    source: "qrc:/assets/icons/sort_down.png"
                }
            },
            State {
                name: "descending"
                PropertyChanges {
                    target: sortByTitleButton
                    source: "qrc:/assets/icons/sort_up.png"
                }
            }
        ]
    }

    Rectangle {
        id: sortByArtist
        width: rectangleWidth
        height: rectangleHeight
        color: rectangleColor

        state: "ascending"

        Text {
            text: qsTr("Artist")
            font.pixelSize: 15
            color: "white"
            anchors.centerIn: parent
        }

        Image {
            id: sortByArtistButton
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 10
        }

        MouseArea {
            anchors.fill: sortByArtistButton
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                if (sortByArtist.state == "ascending")
                {
                    sortByArtist.state = "descending"
                    parentLayout.sortActivated(1, Qt.DescendingOrder)
                }
                else
                {
                    sortByArtist.state = "ascending"
                    parentLayout.sortActivated(1, Qt.AscendingOrder)
                }
            }
        }

        states: [
            State {
                name: "ascending"
                PropertyChanges {
                    target: sortByArtistButton
                    source: "qrc:/assets/icons/sort_down.png"
                }
            },
            State {
                name: "descending"
                PropertyChanges {
                    target: sortByArtistButton
                    source: "qrc:/assets/icons/sort_up.png"
                }
            }
        ]
    }

    Rectangle {
        id: sortByAlbum
        width: rectangleWidth
        height: rectangleHeight
        color: rectangleColor

        state: "ascending"

        Text {
            text: qsTr("Album")
            font.pixelSize: 15
            color: "white"
            anchors.centerIn: parent
        }

        Image {
            id: sortByAlbumButton
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 10
        }

        MouseArea {
            anchors.fill: sortByAlbumButton
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                if (sortByAlbum.state == "ascending")
                {
                    sortByAlbum.state = "descending"
                    parentLayout.sortActivated(2, Qt.DescendingOrder)
                }
                else
                {
                    sortByAlbum.state = "ascending"
                    parentLayout.sortActivated(2, Qt.AscendingOrder)
                }
            }
        }

        states: [
            State {
                name: "ascending"
                PropertyChanges {
                    target: sortByAlbumButton
                    source: "qrc:/assets/icons/sort_down.png"
                }
            },
            State {
                name: "descending"
                PropertyChanges {
                    target: sortByAlbumButton
                    source: "qrc:/assets/icons/sort_up.png"
                }
            }
        ]
    }

    Rectangle {
        id: category
        width: rectangleWidth
        height: rectangleHeight
        color: rectangleColor

        Text {
            text: qsTr("Category")
            font.pixelSize: 15
            color: "white"
            anchors.centerIn: parent
        }
    }

    Rectangle {
        id: sortByYear
        width: yearRectangleWidth
        height: rectangleHeight
        color: rectangleColor

        state: "ascending"


        Text {
            text: qsTr("Year")
            font.pixelSize: 15
            color: "white"
            anchors.centerIn: parent
        }

        Image {
            id: sortByYearButton
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 10
        }

        MouseArea {
            anchors.fill: sortByYearButton
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                if (sortByYear.state == "ascending")
                {
                    sortByYear.state = "descending"
                    parentLayout.sortActivated(4, Qt.DescendingOrder)
                }
                else
                {
                    sortByYear.state = "ascending"
                    parentLayout.sortActivated(4, Qt.AscendingOrder)
                }
            }
        }

        states: [
            State {
                name: "ascending"
                PropertyChanges {
                    target: sortByYearButton
                    source: "qrc:/assets/icons/sort_down.png"
                }
            },
            State {
                name: "descending"
                PropertyChanges {
                    target: sortByYearButton
                    source: "qrc:/assets/icons/sort_up.png"
                }
            }
        ]
    }
}
