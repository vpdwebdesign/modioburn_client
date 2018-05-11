import QtQuick 2.9
import QtMultimedia 5.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import ModioBurn.Tools 1.0

import "Common"

Pane {

    property string pageTitle: qsTr("Music")

    property int delegateHeight: 220
    property int musicRectangleWidth: 150
    property int musicRectangleHeight: delegateHeight - 20
    property string musicRectangleColor: "transparent"
    property real musicRectangleOpacity: 1.0
    property int musicYearRectangleWidth: Math.round(musicRectangleWidth / 1.5)
    property int musicFontSize: 16

    ParentModel {
        id: parentModelMusic
    }

    RowLayout {
        id: searchBarRow
        width: parent.width
        height: 80
        SearchBar {
            id: search
            Layout.alignment: Qt.AlignHCenter
            placeHolder: qsTr("Music title, artist, album, category or year")
            fuzzySearchEnabled: true
            onSearchActivated: {
                parentModelMusic.filter(ParentModel.Music, searchString)
            }
        }
    }

    Item {
        id: sortBarRow
        width: parent.width
        height: 30
        anchors.top: searchBarRow.bottom
        SortBarMusic {
            onSortActivated: {
                parentModelMusic.sort(ParentModel.Music, col, sortOrder)
            }
        }

    }
    ListView {
        id: musicView
        clip: true
        anchors.top: sortBarRow.bottom
        anchors.topMargin: 20
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        model: parentModelMusic.musicModel
        delegate: musicDelegate
        ScrollBar.vertical: ScrollBar {
            id: musicScrollbar
            active: true
            contentItem: Rectangle {
                implicitWidth: 6
                radius: width / 2
                color: musicScrollbar.pressed ? "#607d8b" : "#a5b7c0"
            }
        }
    }

    Component {
        id: musicDelegate
        Item {
            width: parent.width
            height: delegateHeight

            Image {
                id: musicThumb
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter
                source: "file:" + thumb
            }

            MouseArea {
                anchors.fill: musicThumb
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: notYet.open()
            }


            RowLayout {
                height: parent.height
                anchors.left: musicThumb.right
                anchors.leftMargin: 30
                spacing: 20

                Rectangle {
                    id: titleRectangle
                    width: musicRectangleWidth
                    height: musicRectangleHeight
                    color: musicRectangleColor
                    opacity: musicRectangleOpacity

                    Text {
                        anchors.centerIn: parent
                        color: "#595959"
                        text: title
                        font.pixelSize: musicFontSize
                        width: parent.width - 10
                        wrapMode: Text.WordWrap
                    }

                }

                Rectangle {
                    id: artistRectangle
                    width: musicRectangleWidth
                    height: musicRectangleHeight
                    color: musicRectangleColor
                    opacity: musicRectangleOpacity

                    Text {
                        anchors.centerIn: parent
                        color: "#595959"
                        text: artist
                        font.pixelSize: musicFontSize
                        width: parent.width - 10
                        wrapMode: Text.WordWrap
                    }
                }

                Rectangle {
                    id: albumRectangle
                    width: musicRectangleWidth
                    height: musicRectangleHeight
                    color: musicRectangleColor
                    opacity: musicRectangleOpacity

                    Text {
                        anchors.centerIn: parent
                        color: "#595959"
                        text: album
                        font.pixelSize: musicFontSize
                        width: parent.width - 10
                        wrapMode: Text.WordWrap
                    }
                }

                Rectangle {
                    id: categoryRectangle
                    width: musicRectangleWidth
                    height: musicRectangleHeight
                    color: musicRectangleColor
                    opacity: musicRectangleOpacity

                    Text {
                        anchors.centerIn: parent
                        color: "#595959"
                        text: category.replace(/{|}|"/g, '').replace(/,/g, ", ");
                        font.pixelSize: musicFontSize
                        width: parent.width - 10
                        wrapMode: Text.WordWrap
                    }
                }

                Rectangle {
                    id: yearRectangle
                    width: musicYearRectangleWidth
                    height: musicRectangleHeight
                    color: musicRectangleColor
                    opacity: musicRectangleOpacity

                    Text {
                        anchors.centerIn: parent
                        color: "#595959"
                        text: year
                        font.pixelSize: musicFontSize
                        width: parent.width - 10
                        wrapMode: Text.WordWrap
                    }
                }
            }

            ColumnLayout {
                anchors.right: parent.right
                anchors.rightMargin: 30
                height: delegateHeight

                RowLayout {
                    anchors.horizontalCenter: parent.horizontalCenter
                    Button {
                        text: "Play"
                        onClicked: {
                            if (fileManager.fileExists(url))
                            {
                                var audioPlayerComponent = Qt.createComponent("qrc:/AudioPlayer.qml");
                                if (audioPlayerComponent.status === Component.Ready) {

                                    apWin = audioPlayerComponent.createObject(mainAppWindow, {
                                                                                  "songUrl": "file:" + url,
                                                                                  "coverArtUrl": "file:" + thumb,
                                                                                  "songTitle": title,
                                                                                  "albumTitle": album,
                                                                                  "artistName": artist
                                                                              })
                                    apWin.show()
                                    mainToolBar.audioPlayingIconVisible = true
                                    mainToolBar.audioItemsCountVisible = false
                                }
                            }
                            else
                            {
                                errorDialog.title = "File Not Found"
                                errorMessage.text = "Cannot access the specified file. Please ask the attendant for assistance."
                                errorDialog.open()
                            }
                        }
                    }
                    Button {
                        text: "Buy"
                        onClicked: notYet.open()
                    }

                }

                Label {
                    background: Rectangle {
                              color: "transparent"
                              border.color: "#cccccc"
                    }
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#333333"
                    padding: 10
                    text: "Duration " + duration
                    font.pixelSize: musicFontSize
                }

            }

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 20
                height: 1
                color: "#bfbfbf"
            }
        }

    }    

    Dialog {
        id: errorDialog
        x: Math.round(parent.width / 2) - Math.round(width / 2)
        y: Math.round(parent.height / 2) - Math.round(height / 2)
        width: 350
        modal: true
        focus: true
        Label {
            id: errorMessage
            width: parent.width
            wrapMode: Label.Wrap
        }
        standardButtons: Dialog.Close
    }
}
